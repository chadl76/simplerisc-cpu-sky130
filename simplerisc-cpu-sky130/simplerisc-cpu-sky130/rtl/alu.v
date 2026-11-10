`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 12:17:39 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input wire isAdd, isSub, isCmp, isMul, isDiv, isMod, isLsl, isLsr, isAsr, isOr, isNot, isMov,isAnd,
    input wire [31:0] A, B,
    
    output wire GT, E, // Flags
    output reg [31:0] aluResult
    );

// Comparator

assign E = (A == B);
assign GT = ($signed(A) > $signed(B));
// Math units

wire [31:0] add = A + B;
wire [31:0] sub = A - B;
wire [31:0] mul = A * B;
wire [31:0] lsl = A << B[4:0];
wire [31:0] lsr = A >> B[4:0];
wire [31:0] asr = ($signed(A) >>> B[4:0]);//

wire [31:0] or_alu = A | B;
wire [31:0] and_alu = A & B;
wire [31:0] not_alu = ~B; 

wire [31:0] mov = B;//

// Priority encoder selects which operation goes through 
always @(*) begin
    if      (isAdd) aluResult = add;
    else if (isSub) aluResult = sub;
    else if (isCmp) aluResult = sub;
    else if (isMul) aluResult = mul;
    else if (isLsl) aluResult = lsl;
    else if (isLsr) aluResult = lsr;
    else if (isAsr) aluResult = asr;
    else if (isOr)  aluResult = or_alu;
    else if (isAnd) aluResult = and_alu;
    else if (isNot) aluResult = not_alu;
    else if (isMov) aluResult = mov;
    else            aluResult = 32'b0;
end
endmodule









