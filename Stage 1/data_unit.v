// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        data_unit.v
// Description: Data unit.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// MODIFIED BY: amoraschi
// Date: 2024-04-29 (initial)

`include "code_mem.v"
`include "alu.v"

module data_unit(
  input wire clk,             // IN: Clock (Rising Edge)
  input wire [1:0] operation, // IN: ALU Operation Code
  input wire incpc,           // IN: UP Program Counter
  input wire clpc,            // IN: CLEAR Program Counter
  input wire writeir,         // IN: WRITE Instruction Register
  input wire writereg,        // IN: WRITE Register Array
  input wire inmediate,       // IN: Use Inmediate Value
  input wire [7:0] data_in,   // IN: External Data

  output wire [4:0] opcode,   // OUT: Instruction Operation Code
  output wire [7:0] data_out  // OUT: External Data
);

  reg [7:0] progcount;        // Program Counter Register
  reg [15:0] instreg;         // Instruction Register
  reg [7:0] registers [0:7];  // Register Array

  // Internal signals
  wire [15:0] inst;           // Current Instruction (Code Memory)
  wire [2:0]
    sela,
    selb;                     // Register Selection

  wire [7:0] inmk;            // Inmediate Value
  wire [7:0]
    rega,
    regb;                     // Register Array OUT

  wire [7:0] alu_b;           // ALU:B IN
  wire [7:0] bus;             // Internal BUS

  // Program Counter Register
  always @(posedge clk)
    if (clpc)
      progcount <= 'b0;
    else if (incpc)
      progcount <= progcount + 1;

  // Instruction Register
  always @(posedge clk)
    if (writeir)
      instreg <= inst;

  assign opcode = instreg[15:11];
  assign sela = instreg[10:8];
  assign selb = instreg[2:0];
  assign inmk = instreg[7:0];

  // Register Array
  always @(posedge clk)
    if (writereg)
      registers[sela] <= bus;
    else
      registers[7] <= data_in;

  assign rega = registers[sela];
  assign regb = registers[selb];
  assign data_out = registers[6];

  // Code Memory
  code_mem code_mem (
    .address(progcount),
    .data(inst)
  );

  // ALU:B Multiplexer
  assign alu_b = inmediate ? inmk : regb;

  alu alu (
    .data_a(rega),
    .data_b(alu_b),
    .operation(operation),
    .data_r(bus)
  );
endmodule