`timescale 1ns / 1ps
// Top level: the Verilog version of the Logisim "main" circuit.
// Places all 5 stages + the control unit and wires them together.

module cpu (
    input  wire clk,
    input  wire rst,
    input  wire        prog_we,      // write enable: load an instruction
    input  wire [4:0]  prog_addr,    // which slot (0-31)
    input  wire [31:0] prog_data,    // the instruction to load
    output wire [31:0] r1_out      // the factorial answer, for the LEDs
);

    // ---------------- wires between the boxes (the Logisim tunnels) ----------------
    // IF -> OF
    wire [31:0] pc, inst;
    // OF -> EX / MA / RW / control
    wire [31:0] op1, op2, immx, branchTarget;
    wire [5:0]  opcode;
    wire [3:0]  rd;
    // EX -> IF / MA / RW
    wire [31:0] aluResult, branchPC;
    wire        isBranchTaken;
    // MA -> RW
    wire [31:0] ldResult;
    // RW -> OF (register file write port)
    wire [31:0] wdata;
    wire [3:0]  waddr;
    // control unit -> everything
    wire isImmediate, isSt, isLd, isBeq, isBgt, isRet, isWb, isUBranch, isCall;
    wire isAdd, isSub, isCmp, isMul, isDiv, isMod;
    wire isLsl, isLsr, isAsr, isOr, isAnd, isNot, isMov;

    // ---------------- IF ----------------
    if_stage u_if (
        .clk(clk),
        .rst(rst),
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC),
        .prog_we(prog_we),
        .prog_addr(prog_addr),
        .prog_data(prog_data),
        .pc(pc),
        .inst(inst)
    );

    // ---------------- OF ----------------
    of_stage u_of (
        .clk(clk),
        .isWb(isWb),
        .isRet(isRet),
        .isSt(isSt),
        .waddr(waddr),
        .inst(inst),
        .pc(pc),
        .wdata(wdata),
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .branchTarget(branchTarget),
        .opcode(opcode),
        .rd(rd),
        .r1_out(r1_out)    // r1 passed up from OF
    );

    // ---------------- control unit ----------------
    control_unit u_cu (
        .opcode(opcode),
        .isImmediate(isImmediate),
        .isSt(isSt), .isLd(isLd), .isBeq(isBeq), .isBgt(isBgt),
        .isRet(isRet), .isWb(isWb), .isUBranch(isUBranch), .isCall(isCall),
        .isAdd(isAdd), .isSub(isSub), .isCmp(isCmp), .isMul(isMul),
        .isDiv(isDiv), .isMod(isMod), .isLsl(isLsl), .isLsr(isLsr),
        .isAsr(isAsr), .isOr(isOr), .isAnd(isAnd), .isNot(isNot), .isMov(isMov)
    );

    // ---------------- EX ----------------
    ex_stage u_ex (
        .clk(clk),
        .branchTarget(branchTarget),
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .isImmediate(isImmediate),
        .isRet(isRet), .isUBranch(isUBranch), .isBeq(isBeq), .isBgt(isBgt),
        .isAdd(isAdd), .isSub(isSub), .isCmp(isCmp), .isMul(isMul),
        .isDiv(isDiv), .isMod(isMod), .isLsl(isLsl), .isLsr(isLsr),
        .isAsr(isAsr), .isOr(isOr), .isAnd(isAnd), .isNot(isNot), .isMov(isMov),
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC),
        .aluResult(aluResult)
    );

    // ---------------- MA ----------------
    ma_stage u_ma (
        .clk(clk),
        .isLd(isLd),
        .isSt(isSt),
        .aluResult(aluResult),
        .op2(op2),
        .ldResult(ldResult)
    );

    // ---------------- RW ----------------
    rw_stage u_rw (
        .aluResult(aluResult),
        .ldResult(ldResult),
        .pc(pc),
        .isCall(isCall),
        .isLd(isLd),
        .rd(rd),
        .wdata(wdata),
        .waddr(waddr)
    );

endmodule
