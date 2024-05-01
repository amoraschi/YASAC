// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        data_mem.v
// Description: Data memory and memory-mapped I/O.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-28 (initial)

// Memory map
//   00:EF: RAM
//   F0:F7: output ports
//   F8:FF: input ports
//
// Strategy
//   * Use a synchronous RAM block for RAM. It should be mapped to block RAM.
//   * Use registers for input and output ports.
//   * Input ports are written at each clock cycle (registered input).
//   * Select RAM or registers for input/output depending on the address.
//   * Output ports can also be read.

// Modified by: amoraschi
// Date: 2024-04-29 (initial)

module data_mem (
  input wire CLK,                     // IN: Clock (Rising Edge)
  input wire WRITE_MEM,               // IN: Write Memory
  input wire [7:0] ADDRESS,           // IN: Address
  input wire [7:0] DATA_IN,           // IN: Data
  input wire [7:0]
    PORT08,                           // IN: Input Ports
    PORT09,
    PORT10,
    PORT11,
    PORT12,
    PORT13,
    PORT14,
    PORT15,                           // IN: Input Ports

  output wire [7:0] DATA_OUT,         // OUT: Data
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

  reg [7:0] MEMORY[0:255];
  reg [7:0]
    PORT_REG00,
    PORT_REG01,
    PORT_REG02,
    PORT_REG03,
    PORT_REG04,
    PORT_REG05,
    PORT_REG06,
    PORT_REG07,
    PORT_REG08,
    PORT_REG09,
    PORT_REG10,
    PORT_REG11,
    PORT_REG12,
    PORT_REG13,
    PORT_REG14,
    PORT_REG15;
  reg [7:0] PORT_OUT;

  // Initialize RAM
  initial begin: MEM_INIT
    integer I;

    for (I = 0; I < 'hf0; I = I + 1)
      MEMORY[I] = 'b0;

    PORT_REG00 = 'b0;
    PORT_REG01 = 'b0;
    PORT_REG02 = 'b0;
    PORT_REG03 = 'b0;
    PORT_REG04 = 'b0;
    PORT_REG05 = 'b0;
    PORT_REG06 = 'b0;
    PORT_REG07 = 'b0;
    PORT_REG08 = 'b0;
    PORT_REG09 = 'b0;
    PORT_REG10 = 'b0;
    PORT_REG11 = 'b0;
    PORT_REG12 = 'b0;
    PORT_REG13 = 'b0;
    PORT_REG14 = 'b0;
    PORT_REG15 = 'b0;
  end

  // RAM Write
  always @(posedge CLK)
    // Write only RAM
    if (WRITE_MEM && ADDRESS < 8'hf0)
      MEMORY[ADDRESS] <= DATA_IN;

  // OUT Write
  always @(posedge CLK)
    if (WRITE_MEM && ADDRESS >= 8'hf0 && ADDRESS < 8'hf8)
      case(ADDRESS[3:0])
        4'h0: PORT_REG00 <= DATA_IN;
        4'h1: PORT_REG01 <= DATA_IN;
        4'h2: PORT_REG02 <= DATA_IN;
        4'h3: PORT_REG03 <= DATA_IN;
        4'h4: PORT_REG04 <= DATA_IN;
        4'h5: PORT_REG05 <= DATA_IN;
        4'h6: PORT_REG06 <= DATA_IN;
        4'h7: PORT_REG07 <= DATA_IN;
      endcase

  // OUT Read
  assign PORT00 = PORT_REG00;
  assign PORT01 = PORT_REG01;
  assign PORT02 = PORT_REG02;
  assign PORT03 = PORT_REG03;
  assign PORT04 = PORT_REG04;
  assign PORT05 = PORT_REG05;
  assign PORT06 = PORT_REG06;
  assign PORT07 = PORT_REG07;

  // IN Write
  always @(posedge CLK) begin
    PORT_REG08 <= PORT08;
    PORT_REG09 <= PORT09;
    PORT_REG10 <= PORT10;
    PORT_REG11 <= PORT11;
    PORT_REG12 <= PORT12;
    PORT_REG13 <= PORT13;
    PORT_REG14 <= PORT14;
    PORT_REG15 <= PORT15;
  end

  // Async Read
  always @(*)
    case(ADDRESS[3:0])
      4'h0: PORT_OUT = PORT_REG00;
      4'h1: PORT_OUT = PORT_REG01;
      4'h2: PORT_OUT = PORT_REG02;
      4'h3: PORT_OUT = PORT_REG03;
      4'h4: PORT_OUT = PORT_REG04;
      4'h5: PORT_OUT = PORT_REG05;
      4'h6: PORT_OUT = PORT_REG06;
      4'h7: PORT_OUT = PORT_REG07;
      4'h8: PORT_OUT = PORT_REG08;
      4'h9: PORT_OUT = PORT_REG09;
      4'ha: PORT_OUT = PORT_REG10;
      4'hb: PORT_OUT = PORT_REG11;
      4'hc: PORT_OUT = PORT_REG12;
      4'hd: PORT_OUT = PORT_REG13;
      4'he: PORT_OUT = PORT_REG14;
      4'hf: PORT_OUT = PORT_REG15;
      default: PORT_OUT = 'bx;
    endcase

  // OUT Data
  assign DATA_OUT = (ADDRESS < 8'hf0) ? MEMORY[ADDRESS] : PORT_OUT;
endmodule