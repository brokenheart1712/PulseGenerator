`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2019 10:40:10 AM
// Design Name: 
// Module Name: get_param
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module get_param #(parameter BIT_WIDTH = 10)(
    input clk,
    input [9:0] SW,
    input [3:0] BTN_N,
    output [BIT_WIDTH-1:0] n1,
    output [BIT_WIDTH-1:0] n2,
    output [BIT_WIDTH-1:0] B,
    output [BIT_WIDTH-1:0] B1,
    output [BIT_WIDTH-1:0] B2,
    output [BIT_WIDTH-1:0] C,
    output [BIT_WIDTH-1:0] C1,
    output [BIT_WIDTH-1:0] C2,
    output [BIT_WIDTH-1:0] D,
    output [BIT_WIDTH-1:0] D1,
    output [BIT_WIDTH-1:0] D2,
    output [BIT_WIDTH-1:0] E,
    output reg [9:0] LEDR,
    output reg [6:0] HEX3, HEX2, HEX1, HEX0 // active low
    );
    
    localparam [3:0] RESET = 0, IDLE = 1, ST_B = 2, ST_C = 3, ST_D = 4, ST_B1 = 5,
                     ST_C1 = 6, ST_D1 = 7, ST_B2 = 8, ST_C2 = 9, ST_D2 = 10,
                     ST_E = 11, ST_N1 = 12, ST_N2 = 13;
    reg [3:0] state;
    wire [3:0] db_btn_n;   // debounce button
    reg  [3:0] db_btn_n_reg;
    wire reset, next, save;
    
    reg [BIT_WIDTH-1:0] n1_r;
    reg [BIT_WIDTH-1:0] n2_r;
    reg [BIT_WIDTH-1:0] B_r;
    reg [BIT_WIDTH-1:0] B1_r;
    reg [BIT_WIDTH-1:0] B2_r;
    reg [BIT_WIDTH-1:0] C_r;
    reg [BIT_WIDTH-1:0] C1_r;
    reg [BIT_WIDTH-1:0] C2_r;
    reg [BIT_WIDTH-1:0] D_r;
    reg [BIT_WIDTH-1:0] D1_r;
    reg [BIT_WIDTH-1:0] D2_r;
    reg [BIT_WIDTH-1:0] E_r;

    genvar i;
    generate
      for (i=0; i < 4; i=i+1)
      begin : genpulse
        debounce debounce_i(
          .clk(clk),  // clk 1mhz
          .btn_n(BTN_N[i]),
          .db_btn_n(db_btn_n[i])
          );
      end
    endgenerate
    
    always@(posedge clk) begin
        db_btn_n_reg <= db_btn_n;
    end
    
    // rising edge of button
    assign reset = db_btn_n[3] & ~db_btn_n_reg[3];
    assign next  = db_btn_n[2] & ~db_btn_n_reg[2];
    assign save  = db_btn_n[1] & ~db_btn_n_reg[1];
    
    assign n1   = n1_r;
    assign n2   = n2_r;
    assign B    = B_r;
    assign B1   = B1_r;
    assign B2   = B2_r;
    assign C    = C_r;
    assign C1   = C1_r;
    assign C2   = C2_r;
    assign D    = D_r;
    assign D1   = D1_r;
    assign D2   = D2_r;
    assign E    = E_r;
    
    always@(posedge clk) begin
        if(reset) begin
            n1_r <= 0;
            n2_r <= 0;
            B_r <= 0;
            B1_r <= 0;
            B2_r <= 0;
            C_r <= 0;
            C1_r <= 0;
            C2_r <= 0;
            D_r <= 0;
            D1_r <= 0;
            D2_r <= 0;
            E_r <= 0;
            state <= IDLE;
        end
        else case(state)
            IDLE: if(next) begin
              state <= ST_B;
              LEDR <= 10'd0;
            end
            ST_B: begin
                    if(next) state <= ST_C;
                    if(save) B_r <= SW;
                    LEDR <= B_r;
                  end
            ST_C: begin
                    if(next) state <= ST_D;
                    if(save) C_r <= SW;
                    LEDR <= C_r;
                  end
            ST_D: begin
                     if(next) state <= ST_B1;
                     if(save) D_r <= SW;
                     LEDR <= D_r;
                  end
            ST_B1: begin
                     if(next) state <= ST_C1;
                     if(save) B1_r <= SW;
                     LEDR <= B1_r;
                  end     
            ST_C1: begin
                     if(next) state <= ST_D1;
                     if(save) C1_r <= SW;
                     LEDR <= C1_r;
                  end
            ST_D1: begin
                     if(next) state <= ST_B2;
                     if(save) D1_r <= SW;
                     LEDR <= D1_r;
                  end
            ST_B2: begin
                     if(next) state <= ST_C2;
                     if(save) B2_r <= SW;
                     LEDR <= B2_r;
                  end
            ST_C2: begin
                     if(next) state <= ST_D2;
                     if(save) C2_r <= SW;
                     LEDR <= C2_r;
                  end
            ST_D2: begin
                     if(next) state <= ST_E;
                     if(save) D2_r <= SW;
                     LEDR <= D2_r;
                  end
            ST_E: begin
                     if(next) state <= ST_N1;
                     if(save) E_r <= SW;
                     LEDR <= E_r;
                  end
            ST_N1: begin
                     if(next) state <= ST_N2;
                     if(save) n1_r <= SW;
                     LEDR <= n1_r;
                 end
            ST_N2: begin
                    if(next) state <= IDLE;
                    if(save) n2_r <= SW;
                    LEDR <= n2_r;
                 end                                                                            
            default: state <= IDLE;
         endcase               
    end
    
    always@(posedge clk) begin
        case(state)
            IDLE: begin
                HEX3 <= 7'b1111001; // I
                HEX2 <= 7'b0100001; // d
                HEX1 <= 7'b1000111; // L
                HEX0 <= 7'b0000110; // E  
            end
            ST_B: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0111111; // -
                HEX0 <= 7'b0000011; // B  
            end  
            ST_C: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0111111; // -
                HEX0 <= 7'b1000110; // C  
            end
            ST_D: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0111111; // -
                HEX0 <= 7'b0100001; // d
            end
            ST_B1: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0000011; // B
                HEX0 <= 7'b1111001; // 1 
            end
            ST_C1: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b1000110; // C
                HEX0 <= 7'b1111001; // 1 
            end
            ST_D1: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0100001; // d
                HEX0 <= 7'b1111001; // 1 
            end
            ST_B2: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0000011; // B
                HEX0 <= 7'b0100100; // 2 
            end 
            ST_C2: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b1000110; // C
                HEX0 <= 7'b0100100; // 2 
            end
            ST_D2: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0100001; // d
                HEX0 <= 7'b0100100; // 2 
            end
            ST_E: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0111111; // -
                HEX0 <= 7'b0000110; // E 
            end 
            ST_N1: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0101011; // n
                HEX0 <= 7'b1111001; // 1 
            end
            ST_N2: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0101011; // n
                HEX0 <= 7'b0100100; // 2
            end
            default: begin
                HEX3 <= 7'b0111111; // -
                HEX2 <= 7'b0111111; // -
                HEX1 <= 7'b0111111; // -
                HEX0 <= 7'b0111111; // -
            end
        endcase
    end
endmodule
