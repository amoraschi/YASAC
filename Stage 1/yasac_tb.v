// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        yasac.v
// Description: Yasac processor. Test bench.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// MODIFIED BY: amoraschi
// Date: 2024-04-29 (initial)

`timescale 1ns / 1ps
`include "yasac.v"

module test ();
  reg clk;             // Clock (Rising Edge)
  reg reset;           // RESET (Sync, Active-High)
  reg start;           // START Operation
  wire ready;          // READY Indicator
  reg [7:0] data_in;   // External Data
  wire [7:0] data_out; // External Datas 


  yasac uut (
    .clk(clk),              // IN: Clock (Rising Edge)
    .reset(reset),          // IN: RESET (Sync, Active-High)
    .start(start),          // IN: START Operation
    .data_in(data_in),      // IN: External Data
    .ready(ready),          // OUT: READY Indicator
    .data_out(data_out)     // OUT: External Data
  );

  // Clock Generator (T = 20ns, f = 50MHz)
  always
    #10 clk = ~clk;

  // Main Simulation
  //
  // - Activate RESET 1 cycle
  // - Wait READY
  // - Stop at 100 cycles if no READY
  // - Save Waveforms

  initial begin
    // OUT Generation
    $dumpfile("yasac_tb.vcd");
    $dumplimit(10000000); // Limit 10MB
    $dumpvars(0, test);

    // IN Signals
    clk = 1'b0;
    reset = 1'b0;
    start = 1'b0;
    data_in = 8'd6;

    // RESET
    @(posedge clk) #1 reset = 1'b1;
    @(posedge clk) #1 reset = 1'b0;

    repeat(3) @(posedge clk) #1;

    // START
    start = 1'b1;
    @(posedge clk) #1;
    start = 1'b0;

    // Wait READY
    wait(ready)
      $display("Detected READY - YES");

    repeat(3) @(posedge clk) #1;

    $display("Simulation: OK");

    // IN and OUT Data
    $display(" - data_in: %h, data_out: %h", data_in, data_out);

    $finish;
  end

  // Stop at 100 cycles
  initial begin
    #(20 * 1000);
    $display("Detected READY - NO");
    $display("Simulation: FAIL");
  end
endmodule
