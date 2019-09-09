module direct_transceiver_tester (
  input wire CLOCK_50MHZ,
  input wire [19:0] GPIO_IN,
  output [6:0] DIG,
  output [5:0] SEL
);

wire CLOCK_SWEEP;

clock_divider CLK_DIV_BLOCK (
  .CLOCK_50MHZ (CLOCK_50MHZ),
  .CLOCK_500HZ (CLOCK_SWEEP)
);

sseg_sweeper SSEG_SWPR (
  .CLOCK_SWEEP (CLOCK_SWEEP),
  .GPIO_IN (GPIO_IN),
  .SEL (SEL),
  .HEX (DIG)
);

/* pulse_generator (
  
 );
*/

endmodule
