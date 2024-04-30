// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        code_mem.v
// Description: Code memory.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// Instruction Formats
//
// Format A: <opcode>(5) <Ra>(3) <zero>(5) <Rb>(3)
// Format B: <opcode>(5) <Ra>(3) <inmk>(8)
//
// inmk -> Inmediate Value

// MODIFIED BY: amoraschi
// Date: 2024-04-29 (initial)

`include "globals.vh"

module code_mem (
  input wire [7:0] address, // IN: Instruction Address

  output wire [15:0] data   // OUT: Instruction Data
);

  reg [15:0] code[0:255];
  integer i;

  assign data = code[address];

  initial begin
    // Xilinx ISE Synthesis
    // Needs Positions Initialized
    for (i = 0; i < 256; i = i + 1)
      code[i] = 16'h0000;

    // Code Memory Content

    // data_out = 2 * data_in - 5
    // Example: data_in = 6, data_out = 7

    `include "code/simple.code"
  end
endmodule