`include "Defintions.v"
`include "Collaterals.v"

module VGA_Controller (
	input wire Clock,
	input wire Enable,
	input wire Reset,
	input wire[2:0] iPixel,
	output wire oHorizontalSync,
	output wire oVerticalSync,
	output wire oRed,
	output wire oGreen,
	output wire oBlue,
	output wire[9:0] oColumnCount,
	output wire[9:0] oRowCount
);

wire[10:0] wColumnCount;
wire wColumnReset, wRowReset;
wire[9:0] wColumnCount_2, wRowCount;

assign wColumnCount_2 = {wColumnCount[10:1]};

assign wColumnReset = (wColumnCount == 11'd1599);
assign wRowReset = (wRowCount == 10'd524 && wColumnReset);

assign oColumnCount = wColumnCount_2;
assign oRowCount = wRowCount;

UPCOUNTER_POSEDGE # ( 11 ) COLUMN_COUNTER 
(
	.Clock( Clock ),
	.Reset( wColumnReset | Reset ),
	.Initial( 11'd0 ),
	.Enable( 1'b1 ),
	.Q( wColumnCount )
);

UPCOUNTER_POSEDGE # ( 10 ) ROW_COUNTER 
(
	.Clock( Clock ),
	.Reset( wRowReset | Reset ),
	.Initial( 10'd0 ),
	.Enable( wColumnReset ),
	.Q( wRowCount )
);

parameter H_VISIBLE_AREA 	= 640;
parameter H_FRONT_PORCH 	= 16;
parameter H_PULSE		= 96;
parameter H_BACK_PORCH		= 48;
parameter HORIZONTAL_LINE	= 800;

parameter V_VISIBLE_AREA 	= 480;
parameter V_FRONT_PORCH 	= 10;
parameter V_PULSE		= 2;
parameter V_BACK_PORCH		= 33;
parameter VERTICAL_LINE		= 525;


assign oHorizontalSync = 
(
		wColumnCount_2 >= (H_VISIBLE_AREA + H_FRONT_PORCH ) &&
		wColumnCount_2 <= (H_VISIBLE_AREA + H_FRONT_PORCH + H_PULSE )
) ? 1'b0 : 1'b1;

assign oVerticalSync = 
(
		wRowCount >= (V_VISIBLE_AREA + V_FRONT_PORCH ) &&
		wRowCount <= (V_VISIBLE_AREA + V_FRONT_PORCH + V_PULSE )
) ? 1'b0 : 1'b1;
	
assign {oRed,oGreen,oBlue} = (wColumnCount_2 < H_VISIBLE_AREA && wRowCount < V_VISIBLE_AREA) ?
 {iPixel} :	//display color
 {`BLACK}; //black

endmodule
