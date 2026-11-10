`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 02:16:18 PM
// Design Name: 
// Module Name: ma_stage
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


module ma_stage(

    input  wire             clk, isLd, isSt,
    input  wire [31:0]      aluResult, op2, 
    output wire [31:0]      ldResult
    );
    
    //Make ram
    reg [31:0] ram [0:31];
    //Ram connections
    wire [4:0] A = aluResult[6:2];
    wire [31:0] D = op2;
    
    always @(posedge clk) begin 
        if (isSt) 
            ram[A] <= D;
    end 
 assign ldResult = isLd ? ram[A] : 32'b0;   
    
endmodule
