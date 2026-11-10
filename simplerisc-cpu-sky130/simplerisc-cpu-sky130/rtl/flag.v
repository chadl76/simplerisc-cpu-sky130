`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 12:54:11 PM
// Design Name: 
// Module Name: flag
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


module flag(
     input wire E_in, isCmp, GT_in, clk,
     output reg flags_E, flags_GT
    );
    
 always @(posedge clk) begin 
     if (isCmp) begin
         flags_E <= E_in;
         flags_GT <= GT_in;
     end
    end 
    
endmodule
