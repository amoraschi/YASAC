## Yet Another Simple Academic Computer (YASAC)

The YASAC Verilog implementation is based on a slightly re-designed version
of the CS2010 and CS simple computers used in various courses of the
Electronics Technology Department (Universidad de Sevilla), developed by
professors and students of the Department along the years.

(This is work in progress and, probably, it will always be.)

> [!NOTE]  
> This is a small project to learn Verilog and Assembly, and an attempt at refactoring the original code from the Electronics Technology Department (Universidad de Sevilla). Stages will be added as they get modified. Internal system may change. Original code can be found at [jjchico-edc/yasac-public](https://gitlab.com/jjchico-edc/yasac-public)

### Introduction

* 16 bit instructions.
* 16 bit instructions memory (ROM 256x16).
* 8 registers (R0, ..., R7).
* 8 bit data memory (RAM 256x8)
* 8 memory-mapped output ports (RAM 0xF0 to 0xF7).
* 8 memory-mapped input ports (RAM 0xF8 to 0xFF).

The YASAC borrows the instructions of the Atmel's AVR core but it only
implements a subset of those and uses different instruction formats.

### Design stages

The YASAC has been designed in cummulative stages. To minimize hassle, this repository only contains the last stage refactored.

#### Stage 1

Minimal system.

* Only code memory.
* Basic ALU.
* Instructions: LDI, MOV, ADD, SUB, STOP.
* Basic I/O: R6 -> din, R7 -> dout

#### Stage 2

Data memory and memory addressing. Memory-mapped I/O.

* Data memory
* Complete I/O: datamem[240-255] -> i/o ports 0-15
  - port00 to port07 (0xF0 to 0xF7): output
  - port08 to port15 (0xF8 to 0xFF): input
* New instructions: STS, LDS, LD, ST

#### Stage 3

Improve ALU and jump instructions.

* ALU with status outputs.
* Status register.
* Jump/branch instructions: JMP, BRBS, BRBC.

#### Stage 4

Improve processing instruction set.

* Improve ALU with additional oprations.
* New instructions: logic, shift and status register updates.

#### Stage 5

Stack and subroutines.

* Stack pointer.
* Stack instructions: CALL, RET, PUSH, POP.

### Stage 6

* Moved testbench input port assignments to a different file

### YASAC core

File `yasac.v` contains the YASAC core. This is the processor and memories and
it can be implemented in FPGA chips using different configurations.
`yasac_tb.v` contains a test bench for the YASAC core. You can adapt the
test bench to suit your own version of YASAC or the program being tested.

### Sample programs and code snippets

See the source code in the stages folders for additional examples.

### Improvement ideas

#### Indirect addressing with displacement.

* Data unit modifications.
* New instructions: LDD, STD (may deprecate LD and ST).

#### Interrupts

* Interruption lines and interruption register?
* Define interruption vectors in the memory map.
* Timer peripheral.
* New instructions: RETI

#### Input UART and bootloader

* Serial port peripheral (UART).
* Writable program memory.
* ROM bootloader: transfer code from external computer.

### Original Authors

* Jorge Juan-Chico
* David Guerrero Martos

Based on the work of many others at the Departamento de Tecnología
Electrónica, Universidad de Sevilla.

### LICENSE

This project and all the files included is free software unless otherwise
stated: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.
See <http://www.gnu.org/licenses/>.
