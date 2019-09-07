module clock_divider (
  input CLOCK_50MHZ,
  output reg CLOCK_SWEEP
);

reg [15:0] DVSR;

always @ (posedge CLOCK_50MHZ)
  if (DVSR <= 62_499) DVSR <= DVSR + 1;
  else
    begin
      DVSR <= 0;
      CLOCK_SWEEP <= ~CLOCK_SWEEP;
    end

endmodule