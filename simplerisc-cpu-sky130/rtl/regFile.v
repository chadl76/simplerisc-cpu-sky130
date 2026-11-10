`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 03:35:03 PM
// Design Name: 
// Module Name: regFile
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


module regFile(

    input wire          clk,
    input wire          isWb,
    input wire [3:0]    waddr,
    input wire [3:0]    raddr1,
    input wire [3:0]    raddr2,
    input wire [31:0]    wdata,
    
    output wire [31:0]   op1,
    output wire [31:0]   op2,
    output wire [31:0]   r1_out       // r1 sent up for the LEDs    
    );
    
   reg [31:0] r [0:15];   // 16 registers that are 32bit width
   
   assign op1 = r[raddr1];
   assign op2 = r[raddr2];
   assign r1_out = r[1];   // debug/display: always shows register 1
   
   always @(posedge clk) begin
    if (isWb == 1)
        r[waddr] <= wdata;
   end
   
   
   
endmodule
