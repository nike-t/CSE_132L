`timescale 1ns / 1ps
module RegIDEX #(
		parameter PC_W = 9, // Program Counter
		parameter INS_W = 32, // Instruction Width
		parameter RF_ADDRESS_W = 5, // Register File Address
		parameter DATA_W = 32 // Data WriteData
		)(
		input logic clk,
		input logic ALUSrc, MemtoReg, RegWrite,
		input logic [1:0] MemWrite, ALUOp,
		input logic [2:0] MemRead,
		input logic [PC_W-1:0] IFID_PC, IFID_PCPlus4,
		input logic [DATA_W-1:0] Reg1, Reg2, ExtImm,
		input logic [2:0] Funct3_IFID,
		input logic [RF_ADDRESS_W-1:0] RD_IFID, RS1_IFID, RS2_IFID,
		input logic [6:0] opcode, Funct7,
    
		output logic ALUSrc_Out, MemtoReg_Out, RegWrite_Out,
		output logic [1:0] MemWrite_Out, ALUOp_Out,
		output logic [2:0] MemRead_Out,
		output logic [PC_W-1:0] PC_IDEX_Out, PCPlus4_IDEX_Out,
		output logic [DATA_W-1:0] Reg1_Out, Reg2_Out, ExtImm_Out,
		output logic [2:0] Funct3_IDEX_Out,
		output logic [RF_ADDRESS_W-1:0] RD_IDEX_Out, RS1_IDEX_Out, RS2_IDEX_Out,
		output logic [6:0] opcode_IDEX_Out, Funct7_IDEX_Out
		);

	always @(posedge clk) begin
		ALUSrc_Out <= ALUSrc;
		MemtoReg_Out <= MemtoReg;
		RegWrite_Out <= RegWrite;
		MemWrite_Out <= MemWrite; 
		ALUOp_Out <= ALUOp;
		MemRead_Out <= MemRead;
		PC_IDEX_Out <= IFID_PC;
		PCPlus4_IDEX_Out <= IFID_PCPlus4;
		Reg1_Out <= Reg1;
		Reg2_Out <= Reg2;
		ExtImm_Out <= ExtImm;
		Funct3_IDEX_Out <= Funct3_IFID;
		RD_IDEX_Out <= RD_IFID;
		RS1_IDEX_Out <= RS1_IFID;
		RS2_IDEX_Out <= RS2_IFID;
		opcode_IDEX_Out <= opcode;
		Funct7_IDEX_Out <= Funct7;
	end


endmodule