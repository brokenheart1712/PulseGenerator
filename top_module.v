`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2019 10:40:27 AM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,      // clock 1MHz
    input reset,
    input pulse_in,
    input [9:0] SW,
    input [3:0] BTN_N,  // active low
    output [9:0] LEDR,
    output [6:0] HEX3, HEX2, HEX1, HEX0, // active low    
    output pulse_out_patt_a_1,
    output pulse_out_patt_a_2,
    output pulse_out_patt_b_1,
    output pulse_out_patt_b_2    
    );
   
   localparam BIT_WIDTH = 10; 
   wire [BIT_WIDTH-1:0] n1;
   wire [BIT_WIDTH-1:0] n2;
   wire [BIT_WIDTH-1:0] B;
   wire [BIT_WIDTH-1:0] B1;
   wire [BIT_WIDTH-1:0] B2;
   wire [BIT_WIDTH-1:0] C;
   wire [BIT_WIDTH-1:0] C1;
   wire [BIT_WIDTH-1:0] C2;
   wire [BIT_WIDTH-1:0] D;
   wire [BIT_WIDTH-1:0] D1;
   wire [BIT_WIDTH-1:0] D2;
   wire [BIT_WIDTH-1:0] E;
   
   pulse_gen #(.BIT_WIDTH(BIT_WIDTH)) pulse_gen_i(
        .clk(clk),      // clock 1MHz
        .reset(reset),
        .pulse_in(pulse_in),
        .n1(n1),
        .n2(n2),
        .B(B),
        .B1(B1),
        .B2(B2),
        .C(C),
        .C1(C1),
        .C2(C2),
        .D(D),
        .D1(D1),
        .D2(D2),
        .E(E),
        .pulse_out_patt_a_1(pulse_out_patt_a_1),
        .pulse_out_patt_a_2(pulse_out_patt_a_2),
        .pulse_out_patt_b_1(pulse_out_patt_b_1),
        .pulse_out_patt_b_2(pulse_out_patt_b_2));

    get_param #(.BIT_WIDTH(BIT_WIDTH)) get_param_i(
        .clk(clk),
        .SW(SW),
        .BTN_N(BTN_N),
        .n1(n1),
        .n2(n2),
        .B(B),
        .B1(B1),
        .B2(B2),
        .C(C),
        .C1(C1),
        .C2(C2),
        .D(D),
        .D1(D1),
        .D2(D2),
        .E(E),
        .LEDR(LEDR),
        .HEX3(HEX3), 
        .HEX2(HEX2), 
        .HEX1(HEX1), 
        .HEX0(HEX0) // active low
        );        
endmodule
