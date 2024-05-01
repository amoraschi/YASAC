// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        yasac.v
// Description: Yasac processor.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// Modified by: amoraschi
// Date: 2024-04-29 (initial)

`include "src/control_unit.v"
`include "src/data_unit.v"

module yasac (
  input wire CLK,                                     // IN: Clock (Rising Edge)
  input wire RESET,                                   // IN: Reset (Sync, Active High)
  input wire START,                                   // IN: Start Operation
  input wire [7:0]
    PORT08,                                           // IN: Input Ports
    PORT09,
    PORT10,
    PORT11,
    PORT12,
    PORT13,
    PORT14,
    PORT15,                                           // IN: Input Ports

  output wire RDY,                                    // OUT: Ready Indicator
  output wire [7:0]
    PORT00,                                           // OUT: Output Ports
    PORT01,
    PORT02,
    PORT03,
    PORT04,
    PORT05,
    PORT06,
    PORT07,                                           // OUT: Output Ports
  output wire [1:0] STATE_OUT                         // OUT: FSM State Output
);

  // Internal
  wire [4:0] OPCODE;
  wire [3:0] ALU_OPERATION;
  wire [2:0] STATUS_SEL;
  wire [7:0] STATUS;
  wire
    INC_PROGCOUNT,
    CLR_PROGCOUNT,
    WRITE_PROGCOUNT,
    READ_PROGCOUNT,
    WRITE_INSTREG,
    WRITE_REGS,
    USE_IMMEDIATE,
    WRITE_MEM,
    READ_MEM,
    WRITE_MEMADDR,
    WRITE_STATREG;
  wire
    CLR_STATBIT,
    SET_STATBIT,
    PRESET_STACKPTR,
    INC_STACKPTR,
    DEC_STACKPTR,
    READ_STACKPTR;

  // Control Unit
  control_unit control_unit (
    .CLK(CLK),                                        // IN: Clock (Rising Edge)
    .RESET(RESET),                                    // IN: Reset (Sync, Active High)
    .START(START),                                    // IN: Start Operation
    .RDY(RDY),                                        // OUT: Ready Indicator
    .OPCODE(OPCODE),                                  // IN: Instruction Operation Code
    .STATUS_SEL(STATUS_SEL),                          // IN: Status Bit Selector
    .STATUS(STATUS),                                  // IN: Status from Status Register
    .ALU_OPERATION(ALU_OPERATION),                    // IN: ALU Operation Code
    .INC_PROGCOUNT(INC_PROGCOUNT),                    // OUT: Increment Program Counter
    .CLR_PROGCOUNT(CLR_PROGCOUNT),                    // OUT: Clear Program Counter
    .WRITE_PROGCOUNT(WRITE_PROGCOUNT),                // OUT: Write Program Counter (Branch)
    .READ_PROGCOUNT(READ_PROGCOUNT),                  // OUT: Read Program Counter (Call)
    .WRITE_INSTREG(WRITE_INSTREG),                    // OUT: Write Instruction Register
    .WRITE_REGS(WRITE_REGS),                          // OUT: Write Register Array
    .USE_IMMEDIATE(USE_IMMEDIATE),                    // OUT: Use Immediate Value
    .WRITE_MEM(WRITE_MEM),                            // OUT: Write Data Memory
    .READ_MEM(READ_MEM),                              // OUT: Read Data Memory
    .WRITE_MEMADDR(WRITE_MEMADDR),                    // OUT: Write Memory Address Register
    .WRITE_STATREG(WRITE_STATREG),                    // OUT: Write Status Register
    .STATE_OUT(STATE_OUT),                            // OUT: FSM State Output
    .CLR_STATBIT(CLR_STATBIT),                        // OUT: Clear Status Register Bit
    .SET_STATBIT(SET_STATBIT),                        // OUT: Set Status Register Bit
    .PRESET_STACKPTR(PRESET_STACKPTR),                // OUT: Preset Stack Pointer
    .INC_STACKPTR(INC_STACKPTR),                      // OUT: Increment Stack Pointer
    .DEC_STACKPTR(DEC_STACKPTR),                      // OUT: Decrement Stack Pointer
    .READ_STACKPTR(READ_STACKPTR)                     // OUT: Read Stack Pointer
  );

  // Data Unit
  data_unit data_unit (
    .CLK(CLK),                                        // IN: Clock (Rising Edge)
    .ALU_OPERATION(ALU_OPERATION),                    // IN: ALU Operation Code
    .INC_PROGCOUNT(INC_PROGCOUNT),                    // IN: Increment Program Counter
    .CLR_PROGCOUNT(CLR_PROGCOUNT),                    // IN: Clear Program Counter
    .WRITE_PROGCOUNT(WRITE_PROGCOUNT),                // IN: Write Program Counter (Branch)
    .READ_PROGCOUNT(READ_PROGCOUNT),                  // IN: Read Program Counter (Call)
    .WRITE_INSTREG(WRITE_INSTREG),                    // IN: Write Instruction Register
    .WRITE_REGS(WRITE_REGS),                          // IN: Write Register Array
    .USE_IMMEDIATE(USE_IMMEDIATE),                    // IN: Use Immediate Value
    .WRITE_MEM(WRITE_MEM),                            // IN: Write Data Memory
    .READ_MEM(READ_MEM),                              // IN: Read Data Memory
    .WRITE_MEMADDR(WRITE_MEMADDR),                    // IN: Write Memory Address Register
    .WRITE_STATREG(WRITE_STATREG),                    // IN: Write Status Register
    .CLR_STATBIT(CLR_STATBIT),                        // IN: Clear Status Register Bit
    .SET_STATBIT(SET_STATBIT),                        // IN: Set Status Register Bit
    .PRESET_STACKPTR(PRESET_STACKPTR),                // IN: Preset Stack Pointer
    .INC_STACKPTR(INC_STACKPTR),                      // IN: Increment Stack Pointer
    .DEC_STACKPTR(DEC_STACKPTR),                      // IN: Decrement Stack Pointer
    .READ_STACKPTR(READ_STACKPTR),                    // IN: Read Stack Pointer
    .OPCODE(OPCODE),                                  // OUT: Instruction Operation Code
    .STATUS_SEL(STATUS_SEL),                          // OUT: Status Bit Selector
    .STATUS(STATUS),                                  // OUT: Status from Status Register
    .PORT00(PORT00),                                  // OUT: Output Ports
    .PORT01(PORT01),
    .PORT02(PORT02),
    .PORT03(PORT03),
    .PORT04(PORT04),
    .PORT05(PORT05),
    .PORT06(PORT06),
    .PORT07(PORT07),                                  // OUT: Output Ports
    .PORT08(PORT08),                                  // IN: Input Ports
    .PORT09(PORT09),
    .PORT10(PORT10),
    .PORT11(PORT11),
    .PORT12(PORT12),
    .PORT13(PORT13),
    .PORT14(PORT14),
    .PORT15(PORT15)                                   // IN: Input Ports
  );
endmodule