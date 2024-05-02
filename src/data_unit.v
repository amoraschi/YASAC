// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        data_unit.v
// Description: Data unit.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// Modified by: amoraschi
// Date: 2024-04-29 (initial)

`include "src/globals.vh"
`include "src/alu.v"
`include "src/code_mem.v"
`include "src/data_mem.v"

module data_unit (
  input wire CLK,                     // IN: Clock (Rising Edge)
  input wire [3:0] ALU_OPERATION,     // IN: ALU Operation Code
  input wire INC_PROGCOUNT,           // IN: Increment Program Counter
  input wire CLR_PROGCOUNT,           // IN: Clear Program Counter
  input wire WRITE_PROGCOUNT,         // IN: Write Program Counter (Branch)
  input wire READ_PROGCOUNT,          // IN: Read Program Counter (Call)
  input wire WRITE_INSTREG,           // IN: Write Instruction Register
  input wire WRITE_REGS,              // IN: Write Register Array
  input wire USE_IMMEDIATE,           // IN: Use Immediate Value
  input wire USE_DISPLACEMENT,        // IN: Use Displacement Value
  input wire WRITE_MEM,               // IN: Write Data Memory
  input wire READ_MEM,                // IN: Read Data Memory
  input wire WRITE_MEMADDR,           // IN: Write Memory Address Register
  input wire WRITE_STATREG,           // IN: Write Status Register
  input wire CLR_STATBIT,             // IN: Clear Status Register Bit
  input wire SET_STATBIT,             // IN: Set Status Register Bit
  input wire PRESET_STACKPTR,         // IN: Preset Stack Pointer
  input wire INC_STACKPTR,            // IN: Increment Stack Pointer
  input wire DEC_STACKPTR,            // IN: Decrement Stack Pointer
  input wire READ_STACKPTR,           // IN: Read Stack Pointer
  input wire [7:0]
    PORT08,                           // IN: Input Ports
    PORT09,
    PORT10,
    PORT11,
    PORT12,
    PORT13,
    PORT14,
    PORT15,                            // IN: Input Ports

  output wire [4:0] OPCODE,           // OUT: Operation Code of Current Instruction
  output wire [2:0] STATUS_SEL,       // OUT: Status Bit Selector
  output wire [7:0] STATUS,           // OUT: Status from Status Register
  output wire [7:0]
    PORT00,                           // OUT: Output Ports
    PORT01,
    PORT02,
    PORT03,
    PORT04,
    PORT05,
    PORT06,
    PORT07                            // OUT: Output Ports
);

  reg [7:0] PROGCOUNT;              // Program Counter Register
  reg [15:0] INSTREG;               // Instruction Register
  reg [7:0] REGS [0:7];             // Register Array
  reg [7:0] MEMADDR;                // Memory Address Register
  reg [7:0] STATREG;                // Status Register (---SVNZC)
  reg [7:0] STACKPTR;               // Stack Pointer Register

  // Internal
  wire [15:0] INSTRUCTION;          // Code Memory Instruction
  wire [2:0] SEL_A, SEL_B;          // Register Selection
  wire [7:0] INM_VALUE;             // Immediate Value
  wire [4:0] DISP_VALUE;            // Displacement Value
  wire [7:0] REG_A, REG_B;          // Register Array Outputs
  wire [7:0] ALU_A;                 // ALU A Input
  wire [7:0] ALU_B;                 // ALU B Input
  wire [7:0] BUS;                   // Internal Bus
  wire [7:0] ALU_OUT;               // ALU Output
  wire [7:0] ST_OUT;                // ALU Status Output
  wire [7:0] DATA_OUT;              // Data Memory Output

  // Program Counter Register
  always @(posedge CLK)
    if (CLR_PROGCOUNT)
        PROGCOUNT <= 'b0;
    else if (INC_PROGCOUNT)
      PROGCOUNT <= PROGCOUNT + 1;
    else if (WRITE_PROGCOUNT)
      PROGCOUNT <= BUS;

  // Stack Pointer Register
  always @(posedge CLK)
    if (PRESET_STACKPTR)
      STACKPTR <= `RAMEND;
    else if (INC_STACKPTR)
      STACKPTR <= STACKPTR + 1;
    else if (DEC_STACKPTR)
      STACKPTR <= STACKPTR - 1;

  // Instruction Register
  always @(posedge CLK)
    if (WRITE_INSTREG)
      INSTREG <= INSTRUCTION;

  assign OPCODE = INSTREG[15:11];
  assign SEL_A = INSTREG[10:8];
  assign SEL_B = INSTREG[2:0];
  assign INM_VALUE = INSTREG[7:0];
  assign STATUS_SEL = INSTREG[10:8];
  assign DISP_VALUE = INSTREG[7:3];

  // Register Array
  always @(posedge CLK)
    if (WRITE_REGS)
      REGS[SEL_A] <= BUS;

  assign REG_A = REGS[SEL_A];
  assign REG_B = REGS[SEL_B];

  // Code Memory
  code_mem code_mem (
    .ADDRESS(PROGCOUNT),
    .DATA(INSTRUCTION)
  );

  // Memory Address Register
  always @(posedge CLK)
    if (WRITE_MEMADDR)
      MEMADDR <= BUS;

  // Data Memory
  data_mem data_mem (
    .CLK(CLK),
    .WRITE_MEM(WRITE_MEM),
    .ADDRESS(MEMADDR),
    .DATA_IN(BUS),
    .DATA_OUT(DATA_OUT),
    .PORT00(PORT00),
    .PORT01(PORT01),
    .PORT02(PORT02),
    .PORT03(PORT03),
    .PORT04(PORT04),
    .PORT05(PORT05),
    .PORT06(PORT06),
    .PORT07(PORT07),
    .PORT08(PORT08),
    .PORT09(PORT09),
    .PORT10(PORT10),
    .PORT11(PORT11),
    .PORT12(PORT12),
    .PORT13(PORT13),
    .PORT14(PORT14),
    .PORT15(PORT15)
  );

  // ALU
  assign ALU_A = USE_DISPLACEMENT ? {{3{DISP_VALUE[4]}}, DISP_VALUE} : REG_A;
  assign ALU_B = USE_IMMEDIATE ? INM_VALUE : REG_B;

  alu alu (
    .DATA_A(ALU_A),
    .DATA_B(ALU_B),
    .ALU_OPERATION(ALU_OPERATION),
    .ST_IN(STATREG),
    .DATA_R(ALU_OUT),
    .ST_OUT(ST_OUT)
  );

  // Status Register
  always @(posedge CLK)
    if (WRITE_STATREG)
      STATREG <= ST_OUT;
    else if (CLR_STATBIT)
      STATREG[STATUS_SEL] <= 1'b0;
    else if (SET_STATBIT)
      STATREG[STATUS_SEL] <= 1'b1;

  assign STATUS = STATREG;

  // Bus Multiplexer
  assign BUS =
    READ_MEM ? DATA_OUT :
    READ_STACKPTR ? STACKPTR :
    READ_PROGCOUNT ? PROGCOUNT :
    ALU_OUT;
endmodule
