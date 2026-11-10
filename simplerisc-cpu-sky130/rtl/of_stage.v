`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 10:52:15 AM
// Design Name: 
// Module Name: of_stage
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


module of_stage(
    input wire          clk, isWb, isRet, isSt,
    input wire [3:0]    waddr,
    input wire [31:0]   inst, pc, wdata,
    
    output wire [31:0]  op1, op2, immx, branchTarget,
    output wire [5:0]   opcode,
    output wire [3:0]   rd,
    output wire [31:0]  r1_out       // r1 passed up from the register file
    );
   
   // Top splitter 
   wire [3:0] rs1 = inst[21:18]; // Top mux 0 input
   wire [3:0] rs2 = inst[17:14]; // Btm mux 0 input
   
   // Middle splitter immx
   wire [17:0] imm = inst[17:0];
   
   //Bottom splitter branchTarger
   wire [26:0] offset = inst[26:0];
   
   assign rd = inst[25:22];
   assign opcode = inst[31:26];
   // Top Mux
   wire [3:0] raddr1 = isRet ? 4'd15 : rs1;
   // Bottom Mux
   wire [3:0] raddr2 = isSt ?  rd : rs2;
   
      // CalcImm box
    immgen ig (
        .imm(imm),            // 18-bit immediate from the middle splitter
        .immx(immx)           // 32-bit result -> OF's immx output
    );

    // shiftBy2 box
    branchTarget bt (
        .offset(offset),      // 27-bit offset from the bottom splitter
        .pc(pc),              // OF's pc input
        .branchTarget(branchTarget)   // -> OF's branchTarget output
    );

    // Register File box
    regFile rf (
        .clk(clk),
        .isWb(isWb),          // write enable (from the control unit)
        .waddr(waddr),        // which register to write (from RW)
        .wdata(wdata),        // value to write (from RW)
        .raddr1(raddr1),      // top MUX output
        .raddr2(raddr2),      // bottom MUX output
        .op1(op1),            // -> OF's op1 output
        .op2(op2),            // -> OF's op2 output
        .r1_out(r1_out)       // -> OF's r1_out output
    );
   
   
    
endmodule
