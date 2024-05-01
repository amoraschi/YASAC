// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        alu.v
// Description: Arithmetic-Logic Unit
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// Output flags calculated based on the Atmel AVR Instruction Set Manual

// Modified by: amoraschi
// Date: 2024-04-29 (initial)

`include "src/globals.vh"

module alu (
  input wire [7:0] DATA_A,         // IN: Data A
  input wire [7:0] DATA_B,         // IN: Data B
  input wire [3:0] ALU_OPERATION,  // IN: ALU Operation Code
  input wire [7:0] ST_IN,          // IN: Status Register

  output reg [7:0] DATA_R,         // OUT: Data Result
  output reg [7:0] ST_OUT          // OUT: Status Register (---SVNZC)
);

  // Result
  always @(*) begin
    // Default Status
    ST_OUT = ST_IN;

    case (ALU_OPERATION)
      `ALU_ADD: begin
        DATA_R = DATA_A + DATA_B;
        ST_OUT[`CF] = DATA_A[7] & DATA_B[7] | DATA_B[7] & ~DATA_R[7] | DATA_A[7] & ~DATA_R[7];
        ST_OUT[`VF] = DATA_A[7] & DATA_B[7] & ~DATA_R[7] | ~DATA_A[7] & ~DATA_B[7] & DATA_R[7];
        ST_OUT[`ZF] = ~|DATA_R;
        ST_OUT[`NF] = DATA_R[7];
        ST_OUT[`SF] = ST_OUT[`VF] ^ ST_OUT[`NF];
      end
      `ALU_SUB: begin
        DATA_R = DATA_A - DATA_B;
        ST_OUT[`CF] = ~DATA_A[7] & DATA_B[7] | DATA_B[7] & DATA_R[7] | ~DATA_A[7] & DATA_R[7];
        ST_OUT[`VF] = DATA_A[7] & ~DATA_B[7] & ~DATA_R[7] | ~DATA_A[7] & DATA_B[7] & DATA_R[7];
        ST_OUT[`ZF] = ~|DATA_R;
        ST_OUT[`NF] = DATA_R[7];
        ST_OUT[`SF] = ST_OUT[`VF] ^ ST_OUT[`NF];
      end
      `ALU_TRA: begin
        DATA_R = DATA_A;
      end
      `ALU_TRB: begin
        DATA_R = DATA_B;
      end
      `ALU_NEG: begin
        DATA_R = -DATA_A;
        ST_OUT[`CF] = |DATA_A;
        ST_OUT[`VF] = (DATA_A == 8'h80) ? 1'b1 : 1'b0;
        ST_OUT[`ZF] = ~|DATA_R;
        ST_OUT[`NF] = DATA_R[7];
        ST_OUT[`SF] = ST_OUT[`VF] ^ ST_OUT[`NF];
      end
      `ALU_AND: begin
        DATA_R = DATA_A & DATA_B;
        ST_OUT[`VF] = 1'b0;
        ST_OUT[`ZF] = ~|DATA_R;
        ST_OUT[`NF] = DATA_R[7];
        ST_OUT[`SF] = ST_OUT[`VF] ^ ST_OUT[`NF];
      end
      `ALU_OR: begin
        DATA_R = DATA_A | DATA_B;
        ST_OUT[`VF] = 1'b0;
        ST_OUT[`ZF] = ~|DATA_R;
        ST_OUT[`NF] = DATA_R[7];
        ST_OUT[`SF] = ST_OUT[`VF] ^ ST_OUT[`NF];
      end
      `ALU_EOR: begin
        DATA_R = DATA_A ^ DATA_B;
        ST_OUT[`VF] = 1'b0;
        ST_OUT[`ZF] = ~|DATA_R;
        ST_OUT[`NF] = DATA_R[7];
        ST_OUT[`SF] = ST_OUT[`VF] ^ ST_OUT[`NF];
      end
      `ALU_ROR: begin
        DATA_R = {ST_IN[`CF], DATA_A[7:1]};
        ST_OUT[`CF] = DATA_A[0];
        ST_OUT[`VF] = ST_IN[`CF] ^ DATA_A[0];         // N^C Post-Shift
        ST_OUT[`ZF] = ~|DATA_R;
        ST_OUT[`NF] = DATA_R[7];
        ST_OUT[`SF] = ST_OUT[`VF] ^ ST_OUT[`NF];
      end
      `ALU_ROL: begin
        DATA_R = {DATA_A[6:0], ST_IN[`CF]};
        ST_OUT[`CF] = DATA_A[7];
        ST_OUT[`VF] = DATA_A[7] ^ DATA_A[6];          // N^C Post-Shift
        ST_OUT[`ZF] = ~|DATA_R;
        ST_OUT[`NF] = DATA_R[7];
        ST_OUT[`SF] = ST_OUT[`VF] ^ ST_OUT[`NF];
      end
      default: // Theoretically Unreachable
        DATA_R = 'bx;
    endcase
  end
endmodule
