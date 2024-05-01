// Design:      Simple RPN calculator
// File:        globals.vh
// Description: Global macros and definitions
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-02-27 (initial)

// Modified by: amoraschi
// Date: 2024-04-29 (initial)

// Assembly Operation Codes
`define LDI     5'h01
`define MOV     5'h02
`define ADD     5'h03
`define SUB     5'h04
`define STOP    5'h05
`define LD      5'h06
`define ST      5'h07
`define LDS     5'h08
`define STS     5'h09
`define JMP     5'h0a
`define BRBS    5'h0b   // BRCS/BRLO, BRZS/BREQ, BRMI, BRVS, BRLT
`define BRBC    5'h0c   // BRCC/BRSH, BRZC/BRNE, BRPL, BRVC, BRGE
`define AND     5'h0d
`define OR      5'h0e
`define EOR     5'h0f
`define ROR     5'h10
`define ROL     5'h11
`define BCLR    5'h12
`define BSET    5'h13
`define PUSH    5'h14
`define POP     5'h15
`define CALL    5'h16
`define RET     5'h17

// Registers
`define R0      3'h0
`define R1      3'h1
`define R2      3'h2
`define R3      3'h3
`define R4      3'h4
`define R5      3'h5
`define R6      3'h6
`define R7      3'h7

// ALU Operation Codes
`define ALU_ADD  4'h0
`define ALU_TRA  4'h1
`define ALU_SUB  4'h2
`define ALU_TRB  4'h3
`define ALU_NEG  4'h4
`define ALU_AND  4'h5
`define ALU_OR   4'h6
`define ALU_EOR  4'h7
`define ALU_ROR  4'h8
`define ALU_ROL  4'h9

// Status Register Flags
`define CF      3'h0
`define ZF      3'h1
`define NF      3'h2
`define VF      3'h3
`define SF      3'h4

// Branch Pseudo-Instructions
`define BRCS    {`BRBS, `CF}
`define BRLO    {`BRBS, `CF}
`define BRZS    {`BRBS, `ZF}
`define BREQ    {`BRBS, `ZF}
`define BRMI    {`BRBS, `NF}
`define BRVS    {`BRBS, `VF}
`define BRLT    {`BRBS, `SF}
`define BRCC    {`BRBS, `CF}
`define BRSH    {`BRBC, `CF}
`define BRZC    {`BRBC, `ZF}
`define BRNE    {`BRBC, `ZF}
`define BRPL    {`BRBC, `NF}
`define BRVC    {`BRBC, `VF}
`define BRGE    {`BRBC, `SF}

// Last Memory Address before I/O Address Space
`define RAMEND 8'hef