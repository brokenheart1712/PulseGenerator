module sseg_sweeper (
  input wire CLOCK_SWEEP,
  input wire [19:0] GPIO_IN,
  output reg [5:0] SEL,
  output wire [6:0] HEX
);

integer CASE;
reg [3:0] BIN;
wire [7:0] PARA;

always @ (posedge CLOCK_SWEEP)
begin
  case (CASE)
    0 : begin SEL <= 6'b111110; BIN[3:0] <= GPIO_IN[3:0];   CASE <= CASE + 1; end
    1 : begin SEL <= 6'b111101; BIN[3:0] <= GPIO_IN[7:4];   CASE <= CASE + 1; end
    2 : begin SEL <= 6'b111011; BIN[3:0] <= GPIO_IN[11:8];  CASE <= CASE + 1; end
    3 : begin SEL <= 6'b110111; BIN[3:0] <= GPIO_IN[15:12]; CASE <= CASE + 1; end
    4 : begin SEL <= 6'b101111; BIN[3:0] <= PARA[3:0];      CASE <= CASE + 1; end
    5 : begin SEL <= 6'b011111; BIN[3:0] <= PARA[7:4];      CASE <=        0; end
  endcase
end

bin_to_sseg (
  .BIN (BIN),
  .HEX (HEX)
);

para_decoder (
  .PARA_IN (GPIO_IN[19:16]),
  .PARA_OUT (PARA)
);

// para_to_sseg (

endmodule
