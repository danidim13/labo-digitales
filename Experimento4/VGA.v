`include "Definitions.v"
`include "Collaterals.v"

module VGA_Controller (
	input wire Clock,
	input wire Enable,
	input wire[2:0] iPixel,
	output reg oHorizontalSync,
	output reg oVerticalSync,
	output reg oRed,
	output reg oGreen,
	output reg oBlue
);

wire[9:0] wColumnCount, wRowCount,
wire wColumnReset, wRowReset;

assign wColumnReset = (wColumnCount == 10'd799);
assign wRowReset = (wRowReset == 10'd520);

UPCOUNTER_POSEDGE # ( 10 ) COLUMN_COUNTER 
(
	.Clock( Clock ),
	.Reset( wColumnReset ),
	.Initial( 10'd0 ),
	.Enable( 1'b1 ),
	.Q( wColumnCount ),
);

UPCOUNTER_POSEDGE # ( 10 ) ROW_COUNTER 
(
	.Clock( Clock ),
	.Reset( wRowReset ),
	.Initial( 10'd0 ),
	.Enable( 1'b1 ),
	.Q( wRowCount ),
);


always @(posedge Clock)
begin
	if (Enable)
	begin
		// Display Time Vertical
		if (wRowCount < 480)
		begin
			oVerticalSync <= 1;
			if (wColumnCount < 640)
			begin
				{oRed,oGreen,oBlue} <= iPixel;	
				oHorizontalSync <= 1;
			end
			else if (wColumnCount < 656)
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSyn <= 1;
			end
			else if (wColumnCount < 752) 
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSync <= 0;

			end
			else if (wColumnCount < 800)
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSyn <= 1;
			end
			
		end

		// Front Porch Vertical
		else if (wRowCount < 490)
		begin
			oVerticalSync <= 1;
			if (wColumnCount < 656)
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSyn <= 1;
			end
			else if (wColumnCount < 752) 
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSync <= 0;

			end
			else if (wColumnCount < 800)
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSyn <= 1;
			end
		end

		// PW Vertical
		else if (wRowCount < 492)
		begin
			oVerticalSync <= 0;
			if (wColumnCount < 656)
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSyn <= 1;
			end
			else if (wColumnCount < 752) 
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSync <= 0;

			end
			else if (wColumnCount < 800)
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSyn <= 1;
			end
		end

		// Back Porch Vertical
		else if (wRowCount < 521)
		begin
			oVerticalSync <= 1;
			if (wColumnCount < 656)
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSyn <= 1;
			end
			else if (wColumnCount < 752) 
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSync <= 0;

			end
			else if (wColumnCount < 800)
			begin
				{oRed,oGreen,oBlue} <= `Black;
				oHorizontalSyn <= 1;
			end
		end
	end




