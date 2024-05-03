// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        code_mem.v
// Description: Code memory.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

//// Instruction formats
//
// format A: <opcode>(5) <Ra>(3) <zero>(5) <Rb>(3)
// format B: <opcode>(5) <Ra>(3) <k>(8)
// format C: <opcode>(5) <s>(3) <k>(8)
//
// k -> inmediate value
// s -> branch condition code

// Modified by: amoraschi
// Date: 2024-04-29 (initial)

`include "src/globals.vh"

module code_mem (
  input wire [7:0] ADDRESS,   // IN: Address

  output wire [15:0] DATA     // OUT: Data
);

  reg [15:0] CODE[0:255];
  integer I;

  assign DATA = CODE[ADDRESS];

  initial begin
    // Xilinx ISE synthesis needs all the positions to be initialized
    for (I = 0; I < 256; I = I + 1)
      CODE[I] = 16'h0000;

    // Code Memory
    // `include "src/code/branch_test.code"
    // `include "src/code/fibonacci.code"
    // `include "src/code/logic_test.code"
    // `include "src/code/shift_cl_se_test.code"
    // `include "src/code/stack_test.code"
    `include "src/code/displacement_test.code"
    // `include "src/code/register_call_test.code"
    // `include "src/code/register_jmp_test.code"
  end
endmodule