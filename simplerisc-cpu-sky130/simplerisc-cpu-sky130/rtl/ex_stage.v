`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 01:09:45 PM
// Design Name: 
// Module Name: branch_unit
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


module ex_stage(
    
        input wire [31:0]   branchTarget, op1, op2, immx,
        input wire          clk, isAdd, isImmediate, isRet, isUBranch, isBeq, isBgt, isCmp, isSub, isMul,
        input wire          isLsl, isLsr, isAsr, isOr, isAnd, isNot, isMov, isMod, isDiv,
        
        output wire         isBranchTaken,
        output wire [31:0]   branchPC,
        output wire [31:0]   aluResult  

    );
  
  // brancPC and op2 and immx Muxes   
  assign branchPC = isRet ? op1 : branchTarget;
  wire [31:0] B = isImmediate ? immx : op2;
  
  // connections to the ALU first call the alu script
  wire E, GT;
  
 alu u_alu (
    .A(op1),              // ALU's A pin  ← op1
    .B(B),                // ALU's B pin  ← your B MUX wire
    .isAdd(isAdd), .isSub(isSub), .isCmp(isCmp), .isMul(isMul),
    .isDiv(isDiv), .isMod(isMod), .isLsl(isLsl), .isLsr(isLsr),
    .isAsr(isAsr), .isOr(isOr),   .isAnd(isAnd), .isNot(isNot),
    .isMov(isMov),
    .aluResult(aluResult),   // → EX's aluResult output pin
    .E(E),                   // → the E wire (goes to flags)
    .GT(GT)                  // → the GT wire (goes to flags)
); 

wire flags_E, flags_GT;
  
 flag u_flag (
    .flags_E(flags_E),
    .flags_GT(flags_GT),
    .GT_in(GT),
    .E_in(E),
    .clk(clk),
    .isCmp(isCmp)
 );
 
 assign isBranchTaken = isUBranch | (isBeq & flags_E) | (isBgt & flags_GT);
  
   
     
endmodule
