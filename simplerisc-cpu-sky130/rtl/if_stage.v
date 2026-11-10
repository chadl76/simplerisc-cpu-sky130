`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 01:44:45 PM
// Design Name: 
// Module Name: if_stage
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


module if_stage(
    
    input wire          clk,
    input wire          rst,
    input wire          isBranchTaken,
    input wire [31:0]   branchPC,
    input wire          prog_we, 
    input wire [4:0]    prog_addr, 
    input wire [31:0]   prog_data,
    output reg [31:0]   pc,
    output wire [31:0]  inst
    );
    
//adder for the PC counter going into the mux.     
wire [31:0]      pc_plus_4;
assign pc_plus_4 = pc + 32'd4;

//The mux must be inside the always block so it gets updated every clock cycle.
always @(posedge clk) begin
    if (rst)
        pc <= 32'd0;
    else
        pc <= isBranchTaken ? branchPC : pc_plus_4;
end

//The rom that has the instructions
reg [31:0] imem[31:0];

always @(posedge clk) begin 
    if (prog_we)
        imem[prog_addr] <= prog_data;
end 

assign inst = imem[pc[6:2]];


endmodule
