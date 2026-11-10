`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 10:38:42 AM
// Design Name: 
// Module Name: branchTarget
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


module branchTarget(

    input wire [26:0] offset,
    input wire [31:0] pc,
    
    output wire [31:0] branchTarget

    );
    
 wire [31:0] extend = { {5{offset[26]}}, offset}; //5 copies of bit 26, glued on top of all 27 bits of offset
 wire[31:0] shifted = extend << 2;
 
 assign branchTarget = pc + shifted;

endmodule
