 
`timescale 1ns / 1ps 
`include "Defintions.v" 
 
 
module MiniAlu 
( 
 input wire Clock, 
 input wire Reset, 
 output wire [7:0] oLed 
 
  
); 
 
wire [15:0]  wIP,wIP_temp; 
reg         rWriteEnable,rBranchTaken; 
wire [27:0] wInstruction; 
wire [3:0]  wOperation; 
reg [15:0]   rResult; 
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination, wDestinationPrev; 
wire [15:0] wSourceData0,wSourceData1,wSourceData0_RAM,wSourceData1_RAM,wResultPrev,wIPInitialValue,wImmediateValue; 
 
wire wHazard0, wHazard1, wWriteEnablePrev, wIsImmediate;
 
ROM InstructionRom  
( 
	.iAddress(     wIP          ), 
	.oInstruction( wInstruction ) 
); 
 
RAM_DUAL_READ_PORT DataRam 
( 
	.Clock(         Clock        ), 
	.iWriteEnable(  rWriteEnable ), 
	.iReadAddress0( wInstruction[7:0] ), 
	.iReadAddress1( wInstruction[15:8] ), 
	.iWriteAddress( wDestination ), 
	.iDataIn(       rResult      ), 
	.oDataOut0(     wSourceData0_RAM ), 
	.oDataOut1(     wSourceData1_RAM ) 
); 

 
assign wIPInitialValue = (Reset) ? 8'b0 : wDestination; 
UPCOUNTER_POSEDGE IP 
( 
.Clock(   Clock                ),  
.Reset(   Reset | rBranchTaken ), 
.Initial( wIPInitialValue + 1  ), 
.Enable(  1'b1                 ), 
.Q(       wIP_temp             ) 
); 
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp; 
 
FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) FFD1  
( 
	.Clock(Clock), 
	.Reset(Reset), 
	.Enable(1'b1), 
	.D(wInstruction[27:24]), 
	.Q(wOperation) 
); 
 
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2 
( 
	.Clock(Clock), 
	.Reset(Reset), 
	.Enable(1'b1), 
	.D(wInstruction[7:0]), 
	.Q(wSourceAddr0) 
); 
 
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3 
( 
	.Clock(Clock), 
	.Reset(Reset), 
	.Enable(1'b1), 
	.D(wInstruction[15:8]), 
	.Q(wSourceAddr1) 
); 
 
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4 
( 
	.Clock(Clock), 
	.Reset(Reset), 
	.Enable(1'b1), 
	.D(wInstruction[23:16]), 
	.Q(wDestination) 
); 
 
 
reg rFFLedEN; 
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS 
( 
	.Clock(Clock), 
	.Reset(Reset), 
	.Enable( rFFLedEN ), 
	.D( wSourceData1[7:0] ), 
	.Q( oLed    ) 
); 
 
assign wImmediateValue = {wSourceAddr1,wSourceAddr0}; 
 
///////////////////////////////// 
// Data Hazards en el pipeline // 
 
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD41 
( 
	.Clock(Clock), 
	.Reset(Reset), 
	.Enable(1'b1), 
	.D(wDestination), 
	.Q(wDestinationPrev) 
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 ) FFDRES 
( 
	.Clock(Clock), 
	.Reset(Reset), 
	.Enable(rWriteEnable), 
	.D(rResult), 
	.Q(wResultPrev) 
); 
 
FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FFDWRITE 
( 
	.Clock(Clock), 
	.Reset(Reset), 
	.Enable(1'b1), 
	.D( {rWriteEnable} ), 
	.Q( {wWriteEnablePrev} ) 
); 

assign wIsImmediate = wOperation[3] && wOperation[2];

assign wHazard0 = ((wDestinationPrev == wSourceAddr0) && wWriteEnablePrev && ~wIsImmediate ) ? 1'b1 : 1'b0; 
assign wHazard1 = ((wDestinationPrev == wSourceAddr1) && wWriteEnablePrev && ~wIsImmediate ) ? 1'b1 : 1'b0; 

assign wSourceData0 = (wHazard0) ? wResultPrev : wSourceData0_RAM; 
assign wSourceData1 = (wHazard1) ? wResultPrev : wSourceData1_RAM;
 
//                             // 
///////////////////////////////// 
 
 
always @ ( * ) 
begin 
	case (wOperation) 
	//------------------------------------- 
	`NOP: 
	begin 
		rFFLedEN     <= 1'b0; 
		rBranchTaken <= 1'b0; 
		rWriteEnable <= 1'b0; 
		rResult      <= 0; 
	end 
	//------------------------------------- 
	`ADD: 
	begin 
		rFFLedEN     <= 1'b0; 
		rBranchTaken <= 1'b0; 
		rWriteEnable <= 1'b1; 
		rResult      <= wSourceData1 + wSourceData0; 
	end 
	//------------------------------------- 
	`SUB: 
	begin 
		rFFLedEN     <= 1'b0; 
		rBranchTaken <= 1'b0; 
		rWriteEnable <= 1'b1; 
		rResult      <= wSourceData1 - wSourceData0; 
	end 
	//------------------------------------- 
	`STO: 
	begin 
		rFFLedEN     <= 1'b0; 
		rWriteEnable <= 1'b1; 
		rBranchTaken <= 1'b0; 
		rResult      <= wImmediateValue; 
	end 
	//------------------------------------- 
	`BLE: 
	begin 
		rFFLedEN     <= 1'b0; 
		rWriteEnable <= 1'b0; 
		rResult      <= 0; 
		if (wSourceData1 <= wSourceData0 ) 
			rBranchTaken <= 1'b1; 
		else 
			rBranchTaken <= 1'b0; 
		 
	end 
	//-------------------------------------	 
	`JMP: 
	begin 
		rFFLedEN     <= 1'b0; 
		rWriteEnable <= 1'b0; 
		rResult      <= 0; 
		rBranchTaken <= 1'b1; 
	end 
	//-------------------------------------	 
	`LED: 
	begin 
		rFFLedEN     <= 1'b1; 
		rWriteEnable <= 1'b0; 
		rResult      <= 0; 
		rBranchTaken <= 1'b0; 
	end 
	//------------------------------------- 
	default: 
	begin 
		rFFLedEN     <= 1'b1; 
		rWriteEnable <= 1'b0; 
		rResult      <= 0; 
		rBranchTaken <= 1'b0; 
	end	 
	//-------------------------------------	 
	endcase	 
end 


endmodule 
