// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        control_unit.v
// Description: Control unit.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// Modified by: amoraschi
// Date: 2024-04-29 (initial)

`include "src/globals.vh"

module control_unit (
  // External signals
  input wire CLK,                     // IN: Clock (Rising Edge)
  input wire RESET,                   // IN: Reset (Sync, Active High)
  input wire START,                   // IN: Start Operation

  output reg RDY,                    // OUT: Ready Indicator 

  // Data unit signals
  input wire [4:0] OPCODE,            // IN: Instruction Operation Code
  input wire [2:0] STATUS_SEL,        // IN: Status Bit Selector
  input wire [7:0] STATUS,            // IN: Status from Status Register

  output reg [3:0] ALU_OPERATION,     // OUT: ALU Operation Code
  output reg INC_PROGCOUNT,           // OUT: Increment Program Counter
  output reg CLR_PROGCOUNT,           // OUT: Clear Program Counter
  output reg WRITE_PROGCOUNT,         // OUT: Write Program Counter (Branch)
  output reg READ_PROGCOUNT,          // OUT: Read Program Counter (Call)
  output reg WRITE_INSTREG,           // OUT: Write Instruction Register
  output reg WRITE_REGS,              // OUT: Write Register Array
  output reg USE_IMMEDIATE,           // OUT: Use Immediate Value
  output reg WRITE_MEM,               // OUT: Write Data Memory
  output reg READ_MEM,                // OUT: Read Data Memory
  output reg WRITE_MEMADDR,           // OUT: Write Memory Address Register
  output reg WRITE_STATREG,           // OUT: Write Status Register
  output reg CLR_STATBIT,             // OUT: Clear Status Register Bit
  output reg SET_STATBIT,             // OUT: Set Status Register Bit
  output reg PRESET_STACKPTR,         // OUT: Preset Stack Pointer
  output reg INC_STACKPTR,            // OUT: Increment Stack Pointer
  output reg DEC_STACKPTR,            // OUT: Decrement Stack Pointer
  output reg READ_STACKPTR,           // OUT: Read Stack Pointer
  output wire [1:0] STATE_OUT         // OUT: FSM State Output
);

    // State Definition
    localparam [2:0]
      READY = 0,
      FETCH = 1,
      EXEC1 = 2,
      EXEC2 = 3,
      EXEC3 = 4;

    // State Variables
    reg [2:0]
      STATE,
      NEXT_STATE;

    // State Output
    assign STATE_OUT = STATE;

    // State change process
    always @(posedge CLK)
      if (RESET == 1'b1)
        STATE <= READY;
      else
        STATE <= NEXT_STATE;

    // Next State Logic
    always @(*) begin
      // Default
      NEXT_STATE = 'bx;

      case (STATE)
        READY:
          if (START)
            NEXT_STATE = FETCH;
          else
            NEXT_STATE = READY;
        FETCH:
          NEXT_STATE = EXEC1;
        EXEC1:
          case (OPCODE)
            `STOP:
              NEXT_STATE = READY;
            `LDI, `MOV, `ADD, `SUB, `JMP, `BRBS, `BRBC,
            `AND, `OR, `EOR, `ROR, `ROL, `BCLR, `BSET:
              NEXT_STATE = FETCH;
            `LD, `ST, `LDS, `STS, `PUSH, `POP, `CALL, `RET:
              NEXT_STATE = EXEC2;
            default:
              NEXT_STATE = 'bx;
          endcase
        EXEC2:
          case (OPCODE)
            `LD, `ST, `LDS, `STS, `PUSH:
              NEXT_STATE = FETCH;
            `POP, `CALL, `RET:
              NEXT_STATE = EXEC3;
            default:
              NEXT_STATE = 'bx;
          endcase
        EXEC3:
          case (OPCODE)
            `POP, `CALL, `RET:
              NEXT_STATE = FETCH;
            default:
              NEXT_STATE = 'bx;
          endcase
        default: // Theoretically Unreachable
          NEXT_STATE = 'bx;
      endcase
    end

    // Output Logic
    always @(*) begin
      // Default
      RDY = 1'b0; ALU_OPERATION = 'b0;
      INC_PROGCOUNT = 1'b0; CLR_PROGCOUNT = 1'b0; WRITE_PROGCOUNT = 1'b0; READ_PROGCOUNT = 1'b0;
      WRITE_INSTREG = 1'b0; WRITE_REGS = 1'b0; USE_IMMEDIATE = 1'b0;
      WRITE_MEM = 1'b0; READ_MEM = 1'b0; WRITE_MEMADDR = 1'b0;
      WRITE_STATREG = 1'b0; CLR_STATBIT = 1'b0; SET_STATBIT = 1'b0;
      PRESET_STACKPTR = 1'b0; INC_STACKPTR = 1'b0; DEC_STACKPTR = 1'b0; READ_STACKPTR = 1'b0;

      case (STATE)
        READY: begin
          RDY = 1'b1;

          if (START) begin
            CLR_PROGCOUNT = 1'b1;
            PRESET_STACKPTR = 1'b1;
          end
        end
        FETCH: begin
          WRITE_INSTREG = 1'b1;
          INC_PROGCOUNT = 1'b1;
        end
        EXEC1:
          case (OPCODE)
            `LDI: begin
              ALU_OPERATION = `ALU_TRB;
              WRITE_REGS = 1'b1;
              USE_IMMEDIATE = 1'b1;
            end
            `ADD: begin
              ALU_OPERATION = `ALU_ADD;
              WRITE_REGS = 1'b1;
              WRITE_STATREG = 1'b1;
            end
            `SUB: begin
              ALU_OPERATION = `ALU_SUB;
              WRITE_REGS = 1'b1;
              WRITE_STATREG = 1'b1;
            end
            `MOV: begin
              ALU_OPERATION = `ALU_TRB;
              WRITE_REGS = 1'b1;
            end
            `LD, `ST, `LDS, `STS: begin
              ALU_OPERATION = `ALU_TRB;
              WRITE_MEMADDR = 1'b1;
              if (OPCODE == `LDS || OPCODE == `STS)
                USE_IMMEDIATE = 1'b1;
            end
            `JMP: begin
              ALU_OPERATION = `ALU_TRB;
              USE_IMMEDIATE = 1'b1;
              WRITE_PROGCOUNT = 1'b1;
            end
            `BRBS:
              if (STATUS[STATUS_SEL] == 1'b1) begin
                ALU_OPERATION = `ALU_TRB;
                USE_IMMEDIATE = 1'b1;
                WRITE_PROGCOUNT = 1'b1;
              end
            `BRBC:
              if (STATUS[STATUS_SEL] == 1'b0) begin
                ALU_OPERATION = `ALU_TRB;
                USE_IMMEDIATE = 1'b1;
                WRITE_PROGCOUNT = 1'b1;
              end
            `AND: begin
              ALU_OPERATION = `ALU_AND;
              WRITE_REGS = 1'b1;
              WRITE_STATREG = 1'b1;
            end
            `OR: begin
              ALU_OPERATION = `ALU_OR;
              WRITE_REGS = 1'b1;
              WRITE_STATREG = 1'b1;
            end
            `EOR: begin
              ALU_OPERATION = `ALU_EOR;
              WRITE_REGS = 1'b1;
              WRITE_STATREG = 1'b1;
            end
            `ROR: begin
              ALU_OPERATION = `ALU_ROR;
              WRITE_REGS = 1'b1;
              WRITE_STATREG = 1'b1;
            end
            `ROL: begin
              ALU_OPERATION = `ALU_ROL;
              WRITE_REGS = 1'b1;
              WRITE_STATREG = 1'b1;
            end
            `BCLR:
              CLR_STATBIT = 1'b1;
            `BSET:
              SET_STATBIT = 1'b1;
            `PUSH, `CALL: begin
              READ_STACKPTR = 1'b1;
              WRITE_MEMADDR = 1'b1;
              DEC_STACKPTR = 1'b1;
            end
            `POP, `RET:
              INC_STACKPTR = 1'b1;
          endcase
      EXEC2:
        case (OPCODE)
          `LD, `LDS: begin
            READ_MEM = 1'b1;
            WRITE_REGS = 1'b1;
          end
          `ST, `STS, `PUSH: begin
            ALU_OPERATION = `ALU_TRA;
            WRITE_MEM = 1'b1;
          end
          `POP, `RET: begin
            READ_STACKPTR = 1'b1;
            WRITE_MEMADDR = 1'b1;
          end
          `CALL: begin
            READ_PROGCOUNT = 1'b1;
            WRITE_MEM = 1'b1;
          end
        endcase
      EXEC3:
        case (OPCODE)
          `POP: begin
            READ_MEM = 1'b1;
            WRITE_REGS = 1'b1;
          end
          `CALL: begin
            ALU_OPERATION = `ALU_TRB;
            WRITE_PROGCOUNT = 1'b1;
            USE_IMMEDIATE = 1'b1;
          end
          `RET: begin
            READ_MEM = 1'b1;
            WRITE_PROGCOUNT = 1'b1;
          end
        endcase
    endcase
  end
endmodule