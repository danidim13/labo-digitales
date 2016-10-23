`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:30:52 01/30/2011
// Design Name:   MiniAlu
// Module Name:   D:/Proyecto/RTL/Dev/MiniALU/TestBench.v
// Project Name:  MiniALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MiniAlu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "Defintions.v"
module TestBench;

	// Inputs
	reg Clock;
	reg Reset;

	// Outputs
	wire [7:0] oLed;

	wire wHS, wVS, vga_red, vga_green, vga_blue;
	// Instantiate the Unit Under Test (UUT)
	/*MiniAlu uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.oLed(oLed)
	);*/
	Bichillo semiCLK(
		.Clock(Clock),	
		.Reset(Reset),
		.VGA_HSYNC(wHS),
		.VGA_VSYNC(wVS),
		.VGA_RED(vga_red),
		.VGA_GREEN(vga_green),
		.VGA_BLUE(vga_blue)
	);
/*
	RAM_SINGLE_READ_PORT # (3,24,640*480) VideoMemory
	(
	.Clock( Clock ),
	.iWriteEnable( EnableALU ),
	.iReadAddress(wHS*wVS+wHS ),
	.iWriteAddress( ),
	.iDataIn( ),
	.oDataOut({oVGA_R,oVGA_G,oVGA_B})
	);*/



/*	VGA_Controller vga (
		.Clock(Clock),
		.Enable(1'b1),
		.Reset(Reset),
		.iPixel({oVGA_R,oVGA_G,oVGA_B}),
		.oHorizontalSync(wHS),
		.oVerticalSync(wVS),
		.oRed(vga_red),
		.oGreen(vga_green),
		.oBlue(vga_blue),
		.oQHS (wHS)
		.oQVS (wVS)
	);*/
	
	always
	begin
		#5  Clock =  ! Clock;

	end

	initial begin
		$dumpfile("signals.vcd");
		$dumpvars;
		// Initialize Inputs
		Clock = 0;
		Reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
		Reset = 1;
		#50
		Reset = 0;
        
		// Add stimulus here

		#18000000
		$finish;

	end
      
endmodule

