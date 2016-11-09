`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:27:15 11/09/2016
// Design Name:   Sprite_Controller
// Module Name:   C:/Users/yoe/Desktop/Experimento4/Monitor/testSprite.v
// Project Name:  Monitor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Sprite_Controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testSprite;

	// Inputs
	reg [9:0] iColumnCount;
	reg [9:0] iRowCount;
	reg imask;
	reg iEnable;
	reg [9:0] iPosX;
	reg [9:0] iPosY;
	reg [2:0] iColorSprite;
	reg [2:0] iColorBack;

	// Outputs
	wire [2:0] oRGB;

	// Instantiate the Unit Under Test (UUT)
	Sprite_Controller spriteTest (
		.iColumnCount(iColumnCount), 
		.iRowCount(iRowCount), 
		.imask(imask), 
		.iEnable(iEnable), 
		.iPosX(iPosX), 
		.iPosY(iPosY), 
		.iColorSprite(iColorSprite), 
		.iColorBack(iColorBack), 
		.oRGB(oRGB)
	);

	initial begin
		// Initialize Inputs
		iColumnCount = 0;
		iRowCount = 0;
		imask = 0;
		iEnable = 0;
		iPosX = 5;
		iPosY = 5;
		iColorSprite = 2;
		iColorBack = 5;
	
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      always
			begin 
				#10 
				iColumnCount = iColumnCount + 1;
				iRowCount = iRowCount  + 1;
				{iEnable,imask} = {iEnable,imask} +1;
			end 
endmodule

