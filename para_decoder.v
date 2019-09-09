module para_decoder (
  // input wire CLOCK,
  input wire [3:0] PARA_IN,
  output wire [7:0] PARA_OUT
);

assign PARA_OUT = 
  (PARA_IN == 4'b0000) ? {4'b1010, 4'b0001} : // n1
  (PARA_IN == 4'b0001) ? {4'b1010, 4'b0010} : // n2
  (PARA_IN == 4'b0010) ? {4'b1011, 4'b1111} : // b
  (PARA_IN == 4'b0011) ? {4'b1100, 4'b1111} : // c
  (PARA_IN == 4'b0100) ? {4'b1101, 4'b1111} : // d
  (PARA_IN == 4'b0101) ? {4'b1011, 4'b0001} : // b1
  (PARA_IN == 4'b0110) ? {4'b1100, 4'b0001} : // C1
  (PARA_IN == 4'b0111) ? {4'b1011, 4'b0010} : // b2
  (PARA_IN == 4'b1000) ? {4'b1101, 4'b0001} : // d1
  (PARA_IN == 4'b1001) ? {4'b1110, 4'b1111} : // E
  (PARA_IN == 4'b1010) ? {4'b1101, 4'b0010} : // d2
/*(PARA_IN == 4'b0000)*/ {4'b1100, 4'b0010};  // C2

endmodule