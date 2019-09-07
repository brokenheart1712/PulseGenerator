`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2019 10:39:53 AM
// Design Name: 
// Module Name: pulse_gen
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


module pulse_gen #(parameter BIT_WIDTH = 16)(
    input clk,      // clock 1MHz
    input reset,
    input pulse_in,
    input [BIT_WIDTH-1:0] n1,
    input [BIT_WIDTH-1:0] n2,
    input [BIT_WIDTH-1:0] B,
    input [BIT_WIDTH-1:0] B1,
    input [BIT_WIDTH-1:0] B2,
    input [BIT_WIDTH-1:0] C,
    input [BIT_WIDTH-1:0] C1,
    input [BIT_WIDTH-1:0] C2,
    input [BIT_WIDTH-1:0] D,
    input [BIT_WIDTH-1:0] D1,
    input [BIT_WIDTH-1:0] D2,
    input [BIT_WIDTH-1:0] E,
    output pulse_out_patt_a_1,
    output pulse_out_patt_a_2,
    output pulse_out_patt_b_1,
    output pulse_out_patt_b_2
    );
    
    localparam [3:0] IDLE = 4'd0, ST_A = 4'd1,
                 ST_B = 4'd2, ST_B1 = 4'd3, ST_B2 = 4'd4,
                 ST_C = 4'd5, ST_C1 = 4'd6, ST_C2 = 4'd7,
                 ST_D = 4'd8, ST_D1 = 4'd9, ST_D2 = 4'd10,
                 ST_E = 4'd11, ST_IDLE_B2 = 4'd12; 
    
    reg pulse_in_reg;
    wire pulse_in_rising_edge, pulse_in_falling_edge;
    
    reg pulse_out_b1b2c1n1_reg;
    wire pulse_out_b1b2c1n1_falling_edge;
    
    reg [BIT_WIDTH-1:0] A, counter_A = 0;
    
    reg [3:0] patt_a1_st, patt_a2_st, patt_b1_st, patt_b2_st; // pattern A1 state, pattern A2 state, pattern B1 state, pattern B2 state
    
    reg [BIT_WIDTH-1:0] patt_a1_counter_B, patt_a1_counter_C;
    reg [BIT_WIDTH-1:0] patt_a1_repeat;
    
    reg [BIT_WIDTH-1:0] patt_a2_counter_D, patt_a2_counter_A, patt_a2_counter_B, patt_a2_counter_C;
    reg [BIT_WIDTH-1:0] patt_a2_repeat;
    
    reg [BIT_WIDTH-1:0] patt_b1_counter_B1, patt_b1_counter_C1, patt_b1_counter_B2;
    reg [BIT_WIDTH-1:0] patt_b1_repeat;
    
    reg [BIT_WIDTH-1:0] patt_b2_counter_D1, patt_b2_counter_E, patt_b2_counter_D2, patt_b2_counter_C2;
    reg [BIT_WIDTH-1:0] patt_b2_repeat;                          
                              
    wire pulse_out_bcn1, pulse_out_b1b2c1n1;
    
    always@(posedge clk) begin
        pulse_in_reg <= pulse_in;
    end
    
    assign pulse_in_rising_edge = pulse_in & ~pulse_in_reg;
    assign pulse_in_falling_edge = ~pulse_in & pulse_in_reg;
    
    // pattern A1 generation
    always@(posedge clk) begin
        if(reset) begin
            patt_a1_st <= IDLE;
            patt_a1_counter_B <= 0;
            patt_a1_counter_C <= 0;
        end
        else
        case(patt_a1_st)
            IDLE: begin
                patt_a1_counter_B <= 0;
                patt_a1_counter_C <= 0;
                patt_a1_repeat <= 0;
                if(pulse_in_falling_edge) patt_a1_st <= ST_B;
            end
            ST_B: begin
                if(patt_a1_counter_B == B-1) patt_a1_st <= ST_C;
                patt_a1_counter_B <= patt_a1_counter_B + 1;
                patt_a1_counter_C <= 0;
            end
            ST_C: begin
                patt_a1_counter_B <= 0;
                patt_a1_counter_C <= patt_a1_counter_C + 1;
                if(patt_a1_counter_C == C-1) begin
                    patt_a1_repeat <= patt_a1_repeat + 1;
                    if(patt_a1_repeat == n1-1) patt_a1_st <= IDLE;
                    else patt_a1_st <= ST_B;
                end
            end
            default: patt_a1_st <= IDLE;
        endcase
    end
    
    assign pulse_out_bcn1 = patt_a1_st==ST_C ? 1 : 0;
    assign pulse_out_patt_a_1 = pulse_in | pulse_out_bcn1;
    
    always@(posedge clk)
    begin
        if(pulse_in_rising_edge) counter_A <= 0;
        else if(pulse_in) counter_A <= counter_A + 1;
        
        if(pulse_in_falling_edge) A <= counter_A;
    end
    
    // pattern A2 generation
    always@(posedge clk) begin
        if(reset) begin
            patt_a2_st <= IDLE;
            patt_a2_counter_A <= 0;
            patt_a2_counter_B <= 0;
            patt_a2_counter_C <= 0;
            patt_a2_counter_D <= 0;
        end
        else
        case(patt_a2_st)
            IDLE: begin
                patt_a2_counter_A <= 0;
                patt_a2_counter_B <= 0;
                patt_a2_counter_C <= 0;
                patt_a2_counter_D <= 0;
                patt_a2_repeat <= 0;
                if(pulse_in_rising_edge) patt_a2_st <= ST_D;
            end
            ST_D: begin
                if(patt_a2_counter_D == D-1) patt_a2_st <= ST_A;
                patt_a2_counter_D <= patt_a2_counter_D + 1;
                patt_a2_counter_A <= 0;
            end
            ST_A: begin
                if(patt_a2_counter_A == counter_A) patt_a2_st <= ST_B;
                patt_a2_counter_A <= patt_a2_counter_A + 1;
                patt_a2_counter_B <= 0;
            end
            ST_B: begin
                if(patt_a2_counter_B == B-1) patt_a2_st <= ST_C;
                patt_a2_counter_B <= patt_a2_counter_B + 1;
                patt_a2_counter_C <= 0;
            end
            ST_C: begin
                patt_a2_counter_B <= 0;
                patt_a2_counter_C <= patt_a2_counter_C + 1;
                if(patt_a2_counter_C == C-1) begin
                    patt_a2_repeat <= patt_a2_repeat + 1;
                    if(patt_a2_repeat == n2-1) patt_a2_st <= IDLE;
                    else patt_a2_st <= ST_B;
                end
            end
            default: patt_a2_st <= IDLE;
        endcase
    end
    
    assign pulse_out_patt_a_2 = ((patt_a2_st == ST_A) || (patt_a2_st == ST_C)) ? 1 : 0;
    
    // pattern B1 generation
    always@(posedge clk) begin
        if(reset) begin
            patt_b1_st <= IDLE;
            patt_b1_counter_B1 <= 0;
            patt_b1_counter_C1 <= 0;
            patt_b1_counter_B2 <= 0;
        end
        else
        case(patt_b1_st)
            IDLE: begin
                patt_b1_counter_B1 <= 0;
                patt_b1_counter_C1 <= 0;
                patt_b1_counter_B2 <= 0;
                patt_b1_repeat <= 0;
                if(pulse_in_falling_edge) patt_b1_st <= ST_B1;
            end
            ST_B1: begin
                if(patt_b1_counter_B1 == B1-1) patt_b1_st <= ST_C1;
                patt_b1_counter_B1 <= patt_b1_counter_B1 + 1;
                patt_b1_counter_C1 <= 0;
            end
            ST_C1: begin
                if(patt_b1_counter_C1 == C1-1) patt_b1_st <= ST_B2;
                patt_b1_counter_C1 <= patt_b1_counter_C1 + 1;
                patt_b1_counter_B2 <= 0;
            end            
            ST_B2: begin
                patt_b1_counter_C1 <= 0;
                patt_b1_counter_B2 <= patt_b1_counter_B2 + 1;
                if(patt_b1_counter_B2 == B2-1) begin
                    patt_b1_repeat <= patt_b1_repeat + 1;
                    if(patt_b1_repeat == n1-1) patt_b1_st <= IDLE;
                    else patt_b1_st <= ST_C1;
                end
            end
            default: patt_b1_st <= IDLE;
        endcase
    end
    
    assign pulse_out_b1b2c1n1 = (patt_b1_st==ST_C1) ? 1 : 0;
    assign pulse_out_patt_b_1 = pulse_in | pulse_out_b1b2c1n1;
    
    always@(posedge clk) begin
        pulse_out_b1b2c1n1_reg <= pulse_out_b1b2c1n1;
    end
    
    assign pulse_out_b1b2c1n1_falling_edge = ~pulse_out_b1b2c1n1 & pulse_out_b1b2c1n1_reg;
    
    // pattern B2 generation
    always@(posedge clk) begin
        if(reset) begin
            patt_b2_st <= IDLE;
            patt_b2_counter_D1 <= 0;
            patt_b2_counter_E <= 0;
            patt_b2_counter_D2 <= 0;
            patt_b2_counter_C2 <= 0;
        end
        else
        case(patt_b2_st)
            IDLE: begin
                patt_b2_counter_D1 <= 0;
                patt_b2_counter_E <= 0;
                patt_b2_counter_D2 <= 0;
                patt_b2_counter_C2 <= 0;
                patt_b2_repeat <= 0;
                if(pulse_in_falling_edge) patt_b2_st <= ST_D1;
            end
            ST_D1: begin
                if(patt_b2_counter_D1 == D1-1) patt_b2_st <= ST_E;
                patt_b2_counter_D1 <= patt_b2_counter_D1 + 1;
                patt_b2_counter_E <= 0;
            end
            ST_E: begin
                if(patt_b2_counter_E == E-1) patt_b2_st <= ST_IDLE_B2;
                patt_b2_counter_E <= patt_b2_counter_E + 1;
            end
            ST_IDLE_B2: begin
                if(pulse_out_b1b2c1n1_falling_edge) patt_b2_st <= ST_D2;
                patt_b2_counter_D2 <= 0;
            end
            ST_D2: begin
                if(patt_b2_counter_D2 == D2-2) patt_b2_st <= ST_C2;
                patt_b2_counter_D2 <= patt_b2_counter_D2 + 1;
                patt_b2_counter_C2 <= 0;
            end
            ST_C2: begin
                if(patt_b2_counter_C2 == C2-1) begin
                    patt_b2_repeat <= patt_b2_repeat + 1;
                    if(patt_b2_repeat == n2-1) patt_b2_st <= IDLE;
                        else patt_b2_st <= ST_IDLE_B2;
                end
                patt_b2_counter_C2 <= patt_b2_counter_C2 + 1;
            end
            default: patt_b2_st <= IDLE;
        endcase
    end
    assign pulse_out_patt_b_2 = ((patt_b2_st==ST_E)||(patt_b2_st==ST_C2)) ? 1 : 0;
endmodule
 