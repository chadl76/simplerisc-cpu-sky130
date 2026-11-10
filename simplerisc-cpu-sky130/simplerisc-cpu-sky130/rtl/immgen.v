`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 10:12:29 AM
// Design Name: 
// Module Name: immgen
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


module immgen(

        input wire [17:0] imm ,
        output reg [31:0] immx 
    );
 
 wire [1:0] mod = imm[17:16];
 wire [15:0] number = imm[15:0];
 
 always @(*) begin
    case (mod)
        2'b00: immx = {{16{number[15]}}, number };
        2'b01: immx = {16'b0, number};
        2'b10: immx = {number, 16'b0};
        default: immx = 32'b0;
     endcase
 end
endmodule
