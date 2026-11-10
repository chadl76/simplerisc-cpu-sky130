`timescale 1ns / 1ps
// Control unit: opcode -> every control signal (book Table 8.4)

module control_unit (
    input  wire [5:0] opcode,        // from OF: 5-bit opcode + I bit

    output wire       isImmediate,
    output reg        isSt, isLd, isBeq, isBgt, isRet, isWb, isUBranch, isCall,
    output reg        isAdd, isSub, isCmp, isMul, isDiv, isMod,
    output reg        isLsl, isLsr, isAsr, isOr, isAnd, isNot, isMov
);

    // splitter: bits 5-1 = instruction number, bit 0 = I bit
    wire [4:0] op = opcode[5:1];
    assign isImmediate = opcode[0];

    always @(*) begin
        // ---------- defaults: everything off ----------
        isSt = 0;  isLd = 0;  isBeq = 0; isBgt = 0; isRet = 0;
        isWb = 0;  isUBranch = 0; isCall = 0;
        isAdd = 0; isSub = 0; isCmp = 0; isMul = 0; isDiv = 0; isMod = 0;
        isLsl = 0; isLsr = 0; isAsr = 0; isOr = 0;  isAnd = 0; isNot = 0; isMov = 0;

        // ---------- decoder: turn on what each instruction needs ----------
        case (op)
            5'd0:  begin isAdd = 1; isWb = 1; end                  // add
            5'd1:  begin isSub = 1; isWb = 1; end                  // sub
            5'd2:  begin isMul = 1; isWb = 1; end                  // mul
            5'd3:  begin isDiv = 1; isWb = 1; end                  // div
            5'd4:  begin isMod = 1; isWb = 1; end                  // mod
            5'd5:  begin isCmp = 1;           end                  // cmp  (flags only)
            5'd6:  begin isAnd = 1; isWb = 1; end                  // and
            5'd7:  begin isOr  = 1; isWb = 1; end                  // or
            5'd8:  begin isNot = 1; isWb = 1; end                  // not
            5'd9:  begin isMov = 1; isWb = 1; end                  // mov
            5'd10: begin isLsl = 1; isWb = 1; end                  // lsl
            5'd11: begin isLsr = 1; isWb = 1; end                  // lsr
            5'd12: begin isAsr = 1; isWb = 1; end                  // asr
            5'd13: ;                                               // nop
            5'd14: begin isLd = 1; isAdd = 1; isWb = 1; end        // ld   (address = base + offset)
            5'd15: begin isSt = 1; isAdd = 1;           end        // st   (no register write)
            5'd16: begin isBeq = 1; end                            // beq
            5'd17: begin isBgt = 1; end                            // bgt
            5'd18: begin isUBranch = 1; end                        // b
            5'd19: begin isUBranch = 1; isCall = 1; isWb = 1; end  // call (PC+4 -> r15)
            5'd20: begin isUBranch = 1; isRet = 1;  end            // ret  (jump to r15)
            default: ;                                             // unused opcodes
        endcase
    end

endmodule
