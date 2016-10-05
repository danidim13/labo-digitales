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

	VGA_Controller vga (
		.Clock(Clock),
		.Enable(1'b1),
		.Reset(Reset),
		.iPixel(`RED),
		.oHorizontalSync(wHS),
		.oVerticalSync(wVS),
		.oRed(vga_red),
		.oGreen(vga_green),
		.oBlue(vga_blue)
	);
	
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

