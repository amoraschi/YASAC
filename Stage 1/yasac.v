// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        yasac.v
// Description: Yasac processor.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// MODIFIED BY: amoraschi
// Date: 2024-04-29 (initial)

`include "control_unit.v"
`include "data_unit.v"

module yasac (
	input wire clk,                 // IN: Clock (Rising Edge)
	input wire reset,               // IN: RESET (Sync, Active-High)
	input wire start,               // IN: START Operation
	input wire [7:0] data_in,       // IN: External Data

	output wire ready,              // OUT: READY Indicator
	output wire [7:0] data_out,     // OUT: External Data
	output wire [1:0] state_out     // OUT: FSM State
);

	// Internal Signals
	wire [4:0] opcode;      // Instruction Operation Code
	wire [1:0] operation;   // ALU Operation Code
	wire
		incpc,
		clpc,
		writeir,
		writereg,
		inmediate;

	// Control Unit
	control_unit control_unit (
		.clk(clk),              // IN: Clock (Rising Edge)
		.reset(reset),          // IN: RESET (Sync, Active-High)
		.start(start),          // IN: START Operation
		.opcode(opcode),        // IN: Instruction Operation Code
		.inmediate(inmediate),	// IN: Use Inmediate Value
		.ready(ready),          // OUT: READY Indicator
		.operation(operation),	// OUT: ALU Operation Code
		.incpc(incpc),          // OUT: UP Program Counter
		.clpc(clpc),            // OUT: CLEAR Program Counter
		.writeir(writeir),			// OUT: WRITE Instruction Register
		.writereg(writereg),		// OUT: WRITE Register Array
		.state_out(state_out)   // OUT: FSM State
	);

	// Data Unit
	data_unit data_unit (
		.clk(clk),							// IN: Clock (Rising Edge)
		.incpc(incpc),					// IN: UP Program Counter
		.clpc(clpc),						// IN: CLEAR Program Counter
		.writeir(writeir),			// IN: WRITE Instruction Register
		.writereg(writereg),		// IN: WRITE Register Array
		.inmediate(inmediate),	// IN: Use Inmediate Value
		.data_in(data_in),			// IN: External Data
		.operation(operation),	// OUT: ALU Operation Code
		.opcode(opcode),				// OUT: Instruction Operation Code
		.data_out(data_out)			// OUT: External Data
	);
endmodule