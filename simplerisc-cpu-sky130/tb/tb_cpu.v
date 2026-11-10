`timescale 1ns / 1ps
// Runs the factorial program in program.mem and checks the answer.

module tb_cpu;

    reg clk = 0;
    reg rst = 1;

    reg        prog_we   = 0;
    reg [4:0]  prog_addr = 0;
    reg [31:0] prog_data = 0;

    cpu dut (.clk(clk), .rst(rst),
             .prog_we(prog_we), .prog_addr(prog_addr), .prog_data(prog_data),
             .r1_out());

    always #5 clk = ~clk;          // 10 ns clock

    integer errors = 0;
    task check(input [255:0] name, input [31:0] got, input [31:0] expected);
        begin
            if (got === expected) $display("PASS  %0s = %h", name, got);
            else begin
                $display("FAIL  %0s = %h  (expected %h)", name, got, expected);
                errors = errors + 1;
            end
        end
    endtask

    // write one instruction into the instruction memory
    task load(input [4:0] addr, input [31:0] data);
        begin
            @(negedge clk);              // change inputs between rising edges
            prog_we   = 1;
            prog_addr = addr;
            prog_data = data;
        end
    endtask

    initial begin
        // ---- load the program (values from program.mem) while rst = 1 ----
        load(0, 32'h4C00000A);   // mov r0, 10
        load(1, 32'h4C400001);   // mov r1, 1
        load(2, 32'h48800000);   // mov r2, r0
        load(3, 32'h10448000);   // mul r1, r1, r2
        load(4, 32'h0C880001);   // sub r2, r2, 1
        load(5, 32'h2C080001);   // cmp r2, 1
        load(6, 32'h8FFFFFFD);   // bgt -3
        load(7, 32'h7C480005);   // st r1, 5[r2]
        load(8, 32'h90000000);   // b 0 (halt)
        @(negedge clk) prog_we = 0;   // done loading
        @(negedge clk) rst = 0;       // release reset -> CPU runs

        #600;                    // ~60 clocks: plenty for 10! (~41 instructions)

        check("r0 (n)",        dut.u_of.rf.r[0], 32'd10);
        check("r1 (10!)",      dut.u_of.rf.r[1], 32'h00375F00);   // 3,628,800
        check("r2 (counter)",  dut.u_of.rf.r[2], 32'd1);
        check("RAM slot 1",    dut.u_ma.ram[1],  32'h00375F00);   // st r1, 5[r2] -> address 6 -> slot 1
        check("PC (halted)",   dut.pc,           32'h00000020);   // stuck on 'b 0' at slot 8

        if (errors == 0) $display("=== FACTORIAL PASSED: 10! = %0d ===", dut.u_of.rf.r[1]);
        else             $display("=== %0d CHECK(S) FAILED ===", errors);
        $finish;
    end

endmodule
