// Design:      Simple RPN calculator
// File:        globals.vh
// Description: Global macros and definitions
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-02-27 (initial)

// MODIFIED BY: amoraschi
// Date: 2024-04-29 (initial)

// Assembly Operation Codes
`define LDI     5'd1
`define MOV     5'd2
`define ADD     5'd3
`define SUB     5'd4
`define STOP    5'd5

// Registers
`define R0      3'd0
`define R1      3'd1
`define R2      3'd2
`define R3      3'd3
`define R4      3'd4
`define R5      3'd5
`define R6      3'd6
`define R7      3'd7

// ALU Operation Codes
`define ALU_ADD  2'd0
`define ALU_TRA  2'd1
`define ALU_SUB  2'd2
`define ALU_TRB  2'd3