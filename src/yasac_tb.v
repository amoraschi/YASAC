// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        yasac_tb.v
// Description: Yasac processor. Test bench.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// Modified by: amoraschi
// Date: 2024-04-29 (initial)

`timescale 1ns / 1ps
`include "src/yasac.v"

module test ();
  reg CLK;                // Clock (Rising Edge)
  reg RESET;              // Reset (Sync, Active Low)
  reg START;              // Start Operation
  wire RDY;               // Ready Indicator
  reg [7:0]
    PORT08,               // Input Ports
    PORT09,
    PORT10,
    PORT11,
    PORT12,
    PORT13,
    PORT14,
    PORT15;               // Input Ports
  wire [7:0]
    PORT00,               // Output Ports
    PORT01,
    PORT02,
    PORT03,
    PORT04,
    PORT05,
    PORT06,
    PORT07;               // OUT: Output Ports  

  yasac uut (
    .CLK(CLK),            // IN: Clock (Rising Edge)
    .RESET(RESET),        // IN: Reset (Sync, Active High)
    .START(START),        // IN: Start Operation
    .PORT08(PORT08),      // IN: Input Ports
    .PORT09(PORT09),
    .PORT10(PORT10),
    .PORT11(PORT11),
    .PORT12(PORT12),
    .PORT13(PORT13),
    .PORT14(PORT14),
    .PORT15(PORT15),      // IN: Input Ports
    .RDY(RDY),            // OUT: Ready Indicator
    .PORT00(PORT00),      // OUT: Output Ports
    .PORT01(PORT01),
    .PORT02(PORT02),
    .PORT03(PORT03),
    .PORT04(PORT04),
    .PORT05(PORT05),
    .PORT06(PORT06),
    .PORT07(PORT07)       // OUT: Output Ports
  );

  // Clock Generator (T=20ns, f=50MHz)
  always
    #10 CLK = ~CLK;

  // Main simulation process
  //
  // Simple strategy:
  //   - Activate the reset signal for 1 clock cycle
  //   - Wait for the "ready" signal and end the simulation.
  //   - Stop the simulation after 100 cycles if ready not activated first.
  //   - Save all waveforms (will be too much as the design grows)
  initial begin
    // OUT Generation
    $dumpfile("yasac_tb.vcd");
    $dumplimit(10000000);           // Limit 10MB
    $dumpvars(0, test);
    //$dumpvars(0, uut.data_unit.data_mem.mem['hf1]);

    // Simple Debugger
    $display(
      "pc |ir    |port08         |port01         |port02\n",
      "---|------|---------------|---------------|--------------"
    );

    $monitor(
      "%h | %h | %h (%b) | %h (%b) | %h (%b)",
      uut.data_unit.PROGCOUNT,
      uut.data_unit.INSTREG,
      PORT08,
      PORT08,
      PORT01,
      PORT01,
      PORT02,
      PORT02
    );

    // IN Signals
    CLK = 1'b0;
    RESET = 1'b0;
    START = 1'b0;
    
    `include "src/ports_tb.config"

    // Global Reset
    @(posedge CLK)
      #1 RESET = 1'b1;

    @(posedge CLK)
      #1 RESET = 1'b0;

    repeat(3)
      @(posedge CLK)
        #1;

    // Start Program
    START = 1'b1;
    @(posedge CLK)
      #1;

    START = 1'b0;

    // Wait RDY
    wait (RDY)
      $display("Detected RDY - TRUE");

    repeat(3)
      @(posedge CLK)
        #1;

    $display("Simulation - SUCCESS");
    $finish;
  end

  // Force Stop 100 cycles
  initial begin
    #(20 * 1000);
    $display("Detected RDY - FALSE");
    $display("Simulation - FAIL");
    $finish;
  end
endmodule