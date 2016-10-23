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

VGA_Controller vga (
	.Clock(Clock),
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

