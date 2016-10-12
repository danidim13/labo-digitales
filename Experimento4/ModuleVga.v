`timescale 1ns / 1ps
`include "Defintions.v"

module Bichillo
(
	input wire Clock,
	input wire Reset,
	output wire VGA_HSYNC,
	output wire VGA_VSYNC,
	output wire VGA_RED,
	output wire VGA_GREEN,
	output wire VGA_BLUE
);

wire [1:0] wHalfClock;

UPCOUNTER_POSEDGE # ( 2 ) HALF_CLOCK 
(
	.Clock( Clock ),
	.Reset( Reset ),
	.Initial( 2'd0 ),
	.Enable( 1'b1 ),
	.Q( wHalfClock )
);


VGA_Controller vga (
	.Clock(wHalfClock[1]),
	.Enable(1'b1),
	.Reset(Reset),
	.iPixel(`RED),
	.oHorizontalSync(VGA_HSYNC),
	.oVerticalSync(VGA_VSYNC),
	.oRed(VGA_RED),
	.oGreen(VGA_GREEN),
	.oBlue(VGA_BLUE)
);


endmodule

