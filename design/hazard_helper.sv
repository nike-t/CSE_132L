`timescale 1ns / 1ps
module hazard_helper(
		input logic HazardSel, ALUSrc, MemtoReg, RegWrite,
		input logic [1:0] MemWrite, ALUOp,
		input logic [2:0] MemRead,
    
		output logic ALUSrc_Hazard, MemtoReg_Hazard, RegWrite_Hazard,
		output logic [1:0] MemWrite_Hazard, ALUOp_Hazard,
		output logic [2:0] MemRead_Hazard
		);
    
	assign ALUSrc_Hazard = HazardSel ? 0 : ALUSrc;
	assign MemtoReg_Hazard = HazardSel ? 0 : MemtoReg;
	assign RegWrite_Hazard = HazardSel ? 0 : RegWrite;
	assign MemWrite_Hazard = HazardSel ? 2'b11 : MemWrite;
	assign ALUOp_Hazard = HazardSel ? 0 : ALUOp;
	assign MemRead_Hazard = HazardSel ? 3'b101 : MemRead;
endmodule