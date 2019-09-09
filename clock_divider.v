module clock_divider (
  input CLOCK_50MHZ,
  output reg CLOCK_500HZ,
  output reg CLOCK_1MHZ
);

reg [15:0] COUNTER_500HZ;
reg [7:0] COUNTER_1MHZ;

always @ (posedge CLOCK_50MHZ)
  if (COUNTER_500HZ <= 49_999) 
    COUNTER_500HZ <= COUNTER_500HZ + 1;
  else
    begin COUNTER_500HZ <= 0; CLOCK_500HZ <= ~CLOCK_500HZ; 
  end
  
always @ (posedge CLOCK_50MHZ)
  if (COUNTER_1MHZ <= 24) 
    COUNTER_1MHZ <= COUNTER_1MHZ + 1;
  else
    begin COUNTER_1MHZ <= 0; COUNTER_1MHZ <= ~COUNTER_1MHZ; 
  end
endmodule
