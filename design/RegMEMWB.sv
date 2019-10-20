`timescale 1ns / 1ps


module RegMEMWB #(
		parameter PC_W = 9,		
		parameter RF_ADDRESS_W = 5, // Register File Address
		parameter DATA_W = 32 // Data WriteData
		)(
		input logic clk, 
		input logic  MemtoReg, RegWrite,
		input logic [DATA_W-1:0] ReadData, ALUResult_EXMEM, ALUResult_j_EXMEM,
		input logic [RF_ADDRESS_W-1:0] RD,
		input logic [PC_W-1:0] PC_EXMEM,
		input logic [6:0] opcode_EXMEM,
		input logic [DATA_W-1:0] ExtImm_EXMEM,
		
		output logic MemtoReg_MEMWB_Out, RegWrite_MEMWB_Out,
		output logic [DATA_W-1:0] ReadData_MEMWB_Out, ALUResult_MEMWB_Out, ALUResult_j_MEMWB_Out,
		output logic [RF_ADDRESS_W-1:0] RD_MEMWB_Out,
		output logic [PC_W-1:0] PC_MEMWB_Out,
		output logic [6:0] opcode_MEMWB_Out,
		output logic [DATA_W-1:0] ExtImm_MEMWB_Out		
		);
    
	always @(posedge clk)
	begin
		MemtoReg_MEMWB_Out <= MemtoReg;
		RegWrite_MEMWB_Out <= RegWrite;
		ReadData_MEMWB_Out <= ReadData;
		ALUResult_MEMWB_Out <= ALUResult_EXMEM;
		ALUResult_j_MEMWB_Out <= ALUResult_j_EXMEM;
		RD_MEMWB_Out <= RD;
		PC_MEMWB_Out <= PC_EXMEM;
		opcode_MEMWB_Out <= opcode_EXMEM;
		ExtImm_MEMWB_Out <= ExtImm_EXMEM;		
	end

endmodule