`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [DATA_W-1:0] WB_Data // The ALU_Result
    
    /*output logic [3:0] ALU_CC,
    output logic [8:0] IDEX_PCOut,
    output logic [DATA_W-1:0] IDEX_Reg1Out,
    output logic [DATA_W-1:0] SrcB,
    output logic [DATA_W-1:0] ALUResult,
    output logic [4:0] RD_MEMWB_Out,
    output logic [DATA_W-1:0] Result,
    output logic [DATA_W-1:0] ALUResult_EXMEM_Out,
    output logic [DATA_W-1:0] ALUResult_MEMWB_Out */   
    );

logic [6:0] opcode_IFID_Out, opcode_IDEX_Out;
logic MemtoReg;
logic ALUSrc, RegWrite;

//logic Branch, JAL_signal, JALR_signal, LUI_signal;

logic [1:0] ALUop, ALUop_IDEX_In, MemWrite;
logic [6:0] Funct7_IDEX_Out;
logic [2:0] Funct3_IFID_Out, Funct3_IDEX_Out, MemRead;
logic [3:0] Operation;

    Controller c(opcode_IFID_Out, Funct3_IFID_Out, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, //Branch, JAL_signal, JALR_signal, LUI_signal,
    				ALUop);
    
    ALUController ac(ALUop_IDEX_In, Funct7_IDEX_Out, Funct3_IDEX_Out, opcode_IDEX_Out, Operation);

    Datapath dp(clk, reset, RegWrite , MemtoReg, MemRead, MemWrite, ALUSrc, ALUop, // Branch, JAL_signal, JALR_signal, LUI_signal,
    			Operation, opcode_IFID_Out, opcode_IDEX_Out, Funct7_IDEX_Out, Funct3_IFID_Out, WB_Data,
    			ALUop_IDEX_In, Funct3_IDEX_Out);
    			
    			
    			
    		//		ALUop_IDEX_In, ALU_CC, ALUResult, Funct3_IDEX_Out, RD_MEMWB_Out, Result, ALUResult_EXMEM_Out,
    		//		ALUResult_MEMWB_Out, IDEX_PCOut, IDEX_Reg1Out, SrcB);
        
endmodule
