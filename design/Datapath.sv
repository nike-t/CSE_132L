`timescale 1ns / 1ps
//import my_112l_pkg::*;
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
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

module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS_W = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite , MemtoReg ,     // Register file writing enable   // Memory or ALU MUX
    input logic [2:0] MemRead ,  		// Memory Reading Enable
    input logic [1:0] MemWrite,	// Memory Writing Enable
    input logic ALUsrc ,       // Register file or Immediate MUX selector
    input logic [1:0] ALUOp, 
    
    //input logic Branch, JAL_signal, JALR_signal, LUI_signal,   // branch, JAL, JALR and LUI control signals 
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU aka Operation )
    output logic [6:0] IFID_opcode_Out,
    output logic [6:0] opcode_IDEX_Out,
    output logic [6:0] Funct7_IDEX_Out,
    output logic [2:0] IFID_Funct3_Out,    
    output logic [DATA_W-1:0] WB_Data, //ALU_Result
    
    output logic [1:0] ALUOp_Out,
    //output logic [ALU_CC_W-1:0] ALU_CC_Out,
   // output logic [DATA_W-1:0] ALUResult,
    output logic [2:0] Funct3_IDEX_Out
    //output logic [RF_ADDRESS_W-1:0] RD_MEMWB_Out,
   // output logic [DATA_W-1:0] Result,
  //  output logic [DATA_W-1:0] ALUResult_EXMEM_Out,
  //  output logic [DATA_W-1:0] ALUResult_MEMWB_Out,
  //  output logic [PC_W-1:0] PC_IDEX_Out,
   // output logic [DATA_W-1:0] Reg1_IDEX_Out,
  // output logic [DATA_W-1:0] SrcB    
    );

logic [PC_W-1:0] IFID_PCIn, IFID_PCPlus4In, IFID_PCOut, IFID_PCPlus4Out, PCPlus4, PC_JALR, selectedPC, PC_temp;
logic [INS_W-1:0] Instr, IFID_InstIn, IFID_InstOut;     // remove instr
//logic [DATA_W-1:0] Result;
logic [DATA_W-1:0] Reg1, Reg2;
logic [DATA_W-1:0] ReadData;
logic [DATA_W-1:0] SrcA;
logic [DATA_W-1:0] ExtImm, PC_extended, PCPlusImm;
logic Branch_Taken, Branch_Taken_EXMEM_Out;
logic [DATA_W-1:0] SW, SH, SB, SelectedWriteData, LW, LH, LHU, LB, LBU;
logic [DATA_W-1:0] out1, out2;
logic [2:0] Load_Inst;
logic [1:0] PCSel;
logic [1:0] ALUop;
logic [1:0] Store_Inst;
logic [DATA_W-1:0] AUIPC, JALR_returnPC;
logic [DATA_W-1:0] SelectedReadData, ReadData_MEMWB_Out;
logic [DATA_W-1:0] SrcB;
logic [RF_ADDRESS_W-1:0] RD, RS1, RS2;
logic [6:0] Funct7;
logic ALUSrc_IDEX_Out, RegWrite_IDEX_Out, RegWrite_EXMEM_Out, RegWrite_MEMWB_Out;
logic MemtoReg_IDEX_Out, MemtoReg_EXMEM_Out, MemtoReg_MEMWB_Out;
logic [2:0] MemRead_IDEX_Out, MemRead_EXMEM_Out;
logic [1:0] MemWrite_IDEX_Out, MemWrite_EXMEM_Out;
logic [PC_W-1:0] PC_IDEX_Out, PCPlus4_IDEX_Out, PC_EXMEM_Out, PCPlus4_EXMEM_Out;
logic [DATA_W-1:0] Reg1_IDEX_Out, Reg2_IDEX_Out, ExtImm_IDEX_Out, Reg2_EXMEM_Out, ALUResult_EXMEM_Out;
logic [DATA_W-1:0] ExtImm_EXMEM_Out;
logic [RF_ADDRESS_W-1:0] RD_IDEX_Out, RS1_IDEX_Out, RS2_IDEX_Out, RD_EXMEM_Out, RD_MEMWB_Out;
logic [6:0] opcode_EXMEM_Out;
logic [DATA_W-1:0] Result_temp, ALUResult_j, ALUResult, ALUResult_j_EXMEM_Out, ALUResult_MEMWB_Out, ALUResult_j_MEMWB_Out;
logic [PC_W-1:0] PC_MEMWB_Out;
logic [6:0] opcode_MEMWB_Out;
logic [DATA_W-1:0] ExtImm_MEMWB_Out;



//For Hazard detection
logic PCWrite, IFIDWrite, HazardSel;
logic ALUSrc_Haz, MemtoReg_Haz, RegWrite_Haz;
logic [1:0] MemWrite_Haz, ALUOp_Haz;
logic [2:0] MemRead_Haz;

//For Forwarding
logic [1:0] ForwardA, ForwardB;
logic [DATA_W-1:0] SrcA_Fwd, SrcB_Fwd;

// Hazard Detector
HazardDetector hzdetector(MemRead_IDEX_Out, RD_IDEX_Out, RS1, RS2,
		PCWrite, IFIDWrite, HazardSel);
hazard_helper hz_hhelp (
		HazardSel, ALUsrc, MemtoReg, RegWrite,
		MemWrite, ALUOp,
		MemRead,
    
		ALUSrc_Haz, MemtoReg_Haz, RegWrite_Haz,
		MemWrite_Haz, ALUOp_Haz,
		MemRead_Haz);

// Forwarding Unit
ForwardingUnit fwd (RS1_IDEX_Out, RS2_IDEX_Out, RD_EXMEM_Out, RD_MEMWB_Out, RegWrite_EXMEM_Out, RegWrite_MEMWB_Out,		
		ForwardA, ForwardB);
forwardA fwdA(ForwardA,
		Reg1_IDEX_Out, ALUResult_EXMEM_Out, WB_Data,
		SrcA_Fwd);
forwardB fwdB (ForwardB,
		Reg2_IDEX_Out, ALUResult_EXMEM_Out, WB_Data,
		SrcB_Fwd); 


    
// next PC
    adder #(9) pcadd (IFID_PCIn, 9'b100, IFID_PCPlus4In);
    flopr #(9) pcreg(PCWrite, clk, reset, selectedPC, IFID_PCIn);
    mux2  #(9) pcmux(IFID_PCPlus4In, (PC_EXMEM_Out +(($signed({ExtImm_IDEX_Out[DATA_W-1],ExtImm_IDEX_Out[7:0]})))), ((Branch & Branch_Taken_EXMEM_Out) || opcode_IFID_Out == 7'b1101111), PC_temp);
    mux2  #(9) pcmux2(PC_temp, ({ALUResult_EXMEM_Out[DATA_W-1], ALUResult_EXMEM_Out[7:0]} & ~(9'b1)), (opcode_IFID_Out == 7'b1100111), selectedPC);
    

 //Instruction memory
    instructionmemory instr_mem (IFID_PCIn, IFID_InstIn);
   
    // IF ID Register
    RegIFID ifid(IFIDWrite, clk, IFID_PCIn, IFID_PCPlus4In, IFID_InstIn, IFID_PCOut, IFID_PCPlus4Out, IFID_InstOut);
    assign IFID_opcode_Out = IFID_InstOut[6:0];
    assign Funct7 = IFID_InstOut[31:25];
    assign IFID_Funct3_Out = IFID_InstOut[14:12];
    assign RD  = IFID_InstOut[11:7];
    assign RS1    = IFID_InstOut[19:15];
    assign RS2    = IFID_InstOut[24:20];
    assign ALU_CC_Out = ALU_CC;    
    
    // //Register File
    RegFile rf(clk, reset, RegWrite_MEMWB_Out, RD_MEMWB_Out, RS1, RS2, WB_Data, Reg1, Reg2);
  
           
    //// sign extender and immediate generator
    imm_Gen Ext_Imm (IFID_InstOut,ExtImm);    
    
    //ID EX Register
    RegIDEX idex(clk, ALUSrc_Haz, MemtoReg_Haz, RegWrite_Haz, MemWrite_Haz, ALUOp_Haz, MemRead_Haz, IFID_PCOut, IFID_PCPlus4Out,
    				Reg1, Reg2, ExtImm, IFID_Funct3_Out, RD, RS1, RS2, IFID_opcode_Out, Funct7,
    				
    				ALUSrc_IDEX_Out, MemtoReg_IDEX_Out, RegWrite_IDEX_Out, MemWrite_IDEX_Out, ALUOp_Out, MemRead_IDEX_Out, 
    				PC_IDEX_Out, PCPlus4_IDEX_Out, Reg1_IDEX_Out, Reg2_IDEX_Out, ExtImm_IDEX_Out, Funct3_IDEX_Out,
    				RD_IDEX_Out, RS1_IDEX_Out, RS2_IDEX_Out, opcode_IDEX_Out, Funct7_IDEX_Out);
  
    //// ALU
    //mux2 #(32) scramux(Reg1_IDEX_Out, 32'b0, LUI_signal, SrcA);
    mux2 #(32) srcbmux(SrcB_Fwd, ExtImm_IDEX_Out, ALUSrc_IDEX_Out, SrcB);
    alu alu_module(SrcA_Fwd, SrcB, ALU_CC, ALUResult, Branch_Taken);
    mux2 #(32) aluresultmux(ALUResult, {23'b0,PCPlus4_IDEX_Out}, (opcode_IDEX_Out == 7'b1101111 || opcode_IDEX_Out == 7'b1100111), ALUResult_j); 
    
    
    
    // EX MEM Register
    RegEXMEM exmem( clk, MemtoReg_IDEX_Out, RegWrite_IDEX_Out, MemRead_IDEX_Out, MemWrite_IDEX_Out, Branch_Taken, ALUResult, ALUResult_j,
    					SrcB_Fwd, RD_IDEX_Out, PC_IDEX_Out, PCPlus4_IDEX_Out, opcode_IDEX_Out, ExtImm_IDEX_Out,
    
    					MemtoReg_EXMEM_Out, RegWrite_EXMEM_Out, MemRead_EXMEM_Out, MemWrite_EXMEM_Out, Branch_Taken_EXMEM_Out, 
    					ALUResult_EXMEM_Out, ALUResult_j_EXMEM_Out, Reg2_EXMEM_Out, RD_EXMEM_Out, PC_EXMEM_Out, PCPlus4_EXMEM_Out, opcode_EXMEM_Out, ExtImm_EXMEM_Out);
    
    // Data memory 
    datamemory data_mem (clk, MemRead_EXMEM_Out, MemWrite_EXMEM_Out, ALUResult_j_EXMEM_Out[DM_ADDRESS-1:0], Reg2_EXMEM_Out, ReadData);    
    
    // MEM WB Register
    RegMEMWB memwb(clk, MemtoReg_EXMEM_Out, RegWrite_EXMEM_Out, ReadData, ALUResult_EXMEM_Out, ALUResult_j_EXMEM_Out, RD_EXMEM_Out,
    					PC_EXMEM_Out, opcode_EXMEM_Out, ExtImm_EXMEM_Out,
    		
    					MemtoReg_MEMWB_Out, RegWrite_MEMWB_Out, ReadData_MEMWB_Out, ALUResult_MEMWB_Out, ALUResult_j_MEMWB_Out,
    					RD_MEMWB_Out, PC_MEMWB_Out, opcode_MEMWB_Out, ExtImm_MEMWB_Out);    					


	//Final Result Mux
	mux2 #(32) resmux(ALUResult_j_MEMWB_Out, ReadData_MEMWB_Out, MemtoReg_MEMWB_Out, Result_temp);
	mux2 #(32) resmux2(Result_temp, (ExtImm_MEMWB_Out + PC_MEMWB_Out), (opcode_MEMWB_Out == 7'b0010111), WB_Data);  	
	
	
	
endmodule