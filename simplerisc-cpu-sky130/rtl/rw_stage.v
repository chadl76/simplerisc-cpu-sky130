`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 02:40:04 PM
// Design Name: 
// Module Name: rw_stage
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


module rw_stage(
        
        input  wire [31:0]   aluResult, ldResult, pc,
        input  wire          isCall, isLd,
        input  wire [3:0]    rd,
        output wire [31:0]   wdata,
        output wire [3:0]    waddr
        
    );
     
  wire [31:0] pc_plus_4 = pc + 32'd4; // Adds the pc + 4
  
  assign wdata = isCall ? pc_plus_4 : (isLd ? ldResult : aluResult); // Mux for isCall and isLd
  assign waddr = isCall ? 4'd15 : rd;
 
 
 
endmodule
