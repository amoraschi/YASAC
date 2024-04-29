// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        control_unit.v
// Description: Control unit.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// MODIFIED BY: amoraschi
// Date: 2024-04-29 (initial)

`include "globals.vh"

module control_unit (
  // External
  input wire clk,             // IN: Clock (Rising Edge)
  input wire reset,           // IN: RESET (Sync, Active-High)
  input wire start,           // IN: START Operation

  output reg ready,           // OUT: READY Indicator

  // Data Unit
  input wire [4:0] opcode,    // IN: Instruction Operation Code

  output reg [1:0] operation, // OUT: ALU Operation Code
  output reg incpc,           // OUT: UP Program Counter
  output reg clpc,            // OUT: CLEAR Program Counter
  output reg writeir,         // OUT: WRITE Instruction Register
  output reg writereg,        // OUT: WRITE Register Array
  output reg inmediate,       // OUT: Use Inmediate Value
  output wire [1:0] state_out // OUT: FSM State
);

  // State Definition
  localparam [1:0]
    READY = 0,
    FETCH = 1,
    EXEC  = 2;

  // State Variables
  reg [1:0]
    state,
    next_state;

  // State OUT
  assign state_out = state;

  // State Machine
  always @(posedge clk)
    if (reset == 1'b1)
      state <= READY;
    else
      state <= next_state;

  // Control Logic
  always @* begin
    // Default OUT Values
    ready = 1'b0; operation = 'b0;
    incpc = 1'b0; clpc = 1'b0;
    writeir = 1'b0; writereg = 1'b0;
    inmediate = 1'b0;
    next_state = 'bx;

    case (state)
      READY: begin
        ready = 1'b1;

        if (start) begin
          clpc = 1'b1;

          next_state = FETCH;
        end else
          next_state = READY;
      end
      FETCH: begin
        writeir = 1'b1;
        incpc = 1'b1;

        next_state = EXEC;
      end
      EXEC: begin
        next_state = FETCH;

        case(opcode)
          `LDI: begin
            operation = `ALU_TRB;
            writereg = 1'b1;
            inmediate = 1'b1;
          end
          `ADD: begin
            operation = `ALU_ADD;
            writereg = 1'b1;
          end
          `SUB: begin
            operation = `ALU_SUB;
            writereg = 1'b1;
          end
          `MOV: begin
            operation = `ALU_TRB;
            writereg = 1'b1;
          end
          default:
            next_state = READY;
        endcase
      end
      default: // Unreachable
        next_state = 'bx;
    endcase
  end
endmodule