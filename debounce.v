`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2019 09:50:23 AM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk,  // clk 1mhz
    input btn_n,
    output reg db_btn_n
    );
    
    reg [31:0] counter;
    
    always@(posedge clk)
    begin
        if(btn_n) counter <= 0;
        else counter <= counter + 1;
        
        if(counter > 1000000) db_btn_n <= 1; else db_btn_n <= 0;   // btn is stable in 200ms
    end
endmodule
