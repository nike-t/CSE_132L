`timescale 1ns / 1ps
//import my_112l_pkg::*;
module RegIFID #(
		parameter PC_W = 9, // Program Counter
		parameter INS_W = 32 // Instruction Width
		)(
		input logic hazard_detected, clk,
		input logic [PC_W-1:0] PC, PCPlus4,
		input logic [INS_W-1:0] inst_code,
		
		output logic [PC_W-1:0] NextPC, NextPCPlus4,
		output logic [INS_W-1:0] inst_next
		);

	always@(posedge clk) 
	begin
		if (hazard_detected == 0) begin	
			NextPC <= PC;
			NextPCPlus4 <= PCPlus4;
			inst_next<=inst_code;
		end
	end
endmodule
