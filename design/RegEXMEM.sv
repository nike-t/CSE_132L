`timescale 1ns / 1ps

module RegEXMEM #(
		parameter PC_W = 9, // Program Counter
		parameter RF_ADDRESS_W = 5, // Register File Address
		parameter DATA_W = 32 // Data WriteData
		)(
		input logic clk,
    
		input logic MemtoReg,
		input logic RegWrite,
		input logic [2:0] MemRead,
		input logic [1:0] MemWrite,
		input logic Branch_Taken,
		input logic [DATA_W-1:0] ALUResult, ALUResult_j, Reg2, 
		input logic [RF_ADDRESS_W-1:0] RD,
		input logic [PC_W-1:0] PC, PCPlus4,
		input logic [6:0] opcode,
		input logic [DATA_W-1:0] ExtImm_IDEX,
		
    
		output logic MemtoReg_EXMEM_Out, 
		output logic RegWrite_EXMEM_Out,
		output logic [2:0] MemRead_EXMEM_Out,
		output logic [1:0] MemWrite_EXMEM_Out,
		output logic Branch_Taken_Out,
		output logic [DATA_W-1:0]  ALUResult_EXMEM_Out, ALUResult_j_EXMEM_Out, Reg2_EXMEM_Out, 
		output logic [RF_ADDRESS_W-1:0] RD_EXMEM_Out,
		output logic [PC_W-1:0] PC_EXMEM_Out, PCPlus4_EXMEM_Out,
		output logic [6:0] opcode_EXMEM_Out,
		output logic [DATA_W-1:0] ExtImm_EXMEM_Out
		
		);

	always @(posedge clk) begin
		MemtoReg_EXMEM_Out <= MemtoReg;
		RegWrite_EXMEM_Out <= RegWrite;
		MemRead_EXMEM_Out <= MemRead;
		MemWrite_EXMEM_Out <= MemWrite;
		Branch_Taken_Out <= Branch_Taken;
		ALUResult_EXMEM_Out <= ALUResult;
		ALUResult_j_EXMEM_Out <= ALUResult_j;
		Reg2_EXMEM_Out <= Reg2;
		RD_EXMEM_Out <= RD;
		PC_EXMEM_Out <= PC;
		PCPlus4_EXMEM_Out <= PCPlus4;
		opcode_EXMEM_Out <= opcode;
		ExtImm_EXMEM_Out <= ExtImm_IDEX;
		
	end

endmodule