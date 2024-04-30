// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        alu.v
// Description: Arithmetic-Logic Unit
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// MODIFIED BY: amoraschi
// Date: 2024-04-29 (initial)

`include "globals.vh"

module alu #(
  parameter WIDTH = 8     // Data Width
) (
  input wire [7:0] data_a,        // IN: Data A
  input wire [7:0] data_b,        // IN: Data B
  input wire [1:0] operation,     // IN: ALU Operation Code

  output reg [7:0] data_r         // OUT: Data Result
);

  always @(*) begin
    case (operation)
      `ALU_ADD: begin
        data_r = data_a + data_b;
      end
      `ALU_SUB: begin
        data_r = data_a - data_b;
      end
      `ALU_TRA: begin
        data_r = data_a;
      end
      `ALU_TRB: begin
        data_r = data_b;
      end
      default: // Unreachable
        data_r = 'bx;
    endcase
  end
endmodule
