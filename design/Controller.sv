`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Controller
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

module Controller(
    
    //Input
    input logic [6:0] Opcode, //7-bit opcode field from the instruction
    input logic [2:0] Funct3,
    //Outputs
    output logic ALUSrc,//0: The second ALU operand comes from the second register file output (Read data 2); 
                  //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg, //0: The value fed to the register Write data input comes from the ALU.
                     //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic [2:0] MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic [1:0] MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    //output logic Branch,  //0: branch is not taken; 1: branch is taken
    //output logic JAL_signal,
    //output logic JALR_signal,
    //output logic LUI_signal,
    output logic [1:0] ALUOp
);

//    localparam R_TYPE = 7'b0110011;
//    localparam LW     = 7'b0000011;
//    localparam SW     = 7'b0100011;
//    localparam BR     = 7'b1100011;
//    localparam RTypeI = 7'b0010011; //addi,ori,andi
    
    logic [6:0] R_TYPE, LW, SW, RTypeI, LUI, AUIPC; // BR, JAL, JALR;
    
    assign  R_TYPE = 7'b0110011;
    assign  LW     = 7'b0000011;
    assign  SW     = 7'b0100011;
    assign  RTypeI = 7'b0010011; //addi,ori,andi
	//assign  BR     = 7'b1100011;
	assign  LUI    = 7'b0110111;
	assign	AUIPC  = 7'b0010111;
	//assign	JAL	   = 7'b1101111;
	//assign	JALR	   = 7'b1100111;
	



always_comb
begin
	ALUSrc  <= (Opcode==LW || Opcode==SW || Opcode == RTypeI || Opcode==LUI || Opcode == AUIPC); // || Opcode ==JALR);
  	MemtoReg <= (Opcode==LW); //|| Opcode==JALR|| Opcode==JAL);
  //assign MemtoReg[1] = (Opcode==AUIPC|| Opcode==JALR|| Opcode==JAL);
   RegWrite <= (Opcode==R_TYPE || Opcode==LW || Opcode == RTypeI || Opcode==LUI || Opcode == AUIPC); //|| Opcode==JALR);
  
   /*MemRead[0] <= ((Opcode==LW) && (Funct3 == 3'b001)) || ((Opcode==LW) && (Funct3 == 3'b000)); //LH //LB;
   MemRead[1] <= ((Opcode==LW) && (Funct3 == 3'b101)) || ((Opcode==LW) && (Funct3 == 3'b000));  //LHU //LB
   MemRead[2] <= ((Opcode==LW) && (Funct3 == 3'b100)); //LBU  
  
   MemWrite[0] <= ((Opcode==SW) && (Funct3 == 3'b001)); //SH
   MemWrite[1] <= ((Opcode==SW) && (Funct3 == 3'b000)); //SB  */
  
  
  
  /*assign Branch   = (Opcode==BR);
  assign JAL_signal = (Opcode==JAL || Opcode==AUIPC);
  assign JALR_signal = (Opcode==JALR);
  assign LUI_signal = (Opcode==LUI);  */
  
   ALUOp[0] <= 0;   //(Opcode==BR ||
   ALUOp[1] <= (Opcode==R_TYPE) ||  ((Funct3==3'b010 || Funct3==3'b001) && Opcode==RTypeI) ; // || Opcode==BR);
   if (Opcode==LW && Funct3==3'b000)
   	MemRead <= 3'b011;
   else if (Opcode==LW && Funct3==3'b001)
   	MemRead <= 3'b001;
   else if (Opcode==LW && Funct3==3'b010)
   	MemRead <= 3'b000; 
   else if (Opcode==LW && Funct3==3'b100)
   	MemRead <= 3'b100;
   else if (Opcode==LW && Funct3==3'b101)
   	MemRead <= 3'b010;
   else
   	MemRead <= 3'b101;
        
   if (Opcode==SW && Funct3==3'b000)
   	MemWrite <= 2'b10;
   else if (Opcode==SW && Funct3==3'b001)
   	MemWrite <= 2'b01;
   else if (Opcode==SW && Funct3==3'b010)
   	MemWrite <= 2'b00;
   else 
   	MemWrite <= 2'b11;   
   
   
end  

endmodule
