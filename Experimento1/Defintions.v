`timescale 1ns / 1ps
`ifndef DEFINTIONS_V
`define DEFINTIONS_V
	
// Cualquier operacion que use valores
// inmediatos debe tener los 2 MSB en alto

`default_nettype none	
`define NOP   4'd0	// 0000
`define LED   4'd2	// 0010
`define BLE   4'd3	// 0011
`define STO   4'd12	// 1100
`define ADD   4'd5	// 0101
`define JMP   4'd6	// 0110
`define SUB   4'd7	// 0111

`define R0 8'd0
`define R1 8'd1
`define R2 8'd2
`define R3 8'd3
`define R4 8'd4
`define R5 8'd5
`define R6 8'd6
`define R7 8'd7


`endif
