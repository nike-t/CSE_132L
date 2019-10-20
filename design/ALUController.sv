`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController(
    
    //Inputs
    input logic [1:0] ALUOp,  //from 7-bit opcode field from the instruction
    input logic [6:0] Funct7, // bits 25 to 31 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    input logic [6:0] Opcode, // bits 6 to 0 of the instruction
    
    //Output
    output logic [3:0] Operation //operation selection for ALU
);
	
	always_comb
	begin
		Operation = 4'b0000;
		if (Opcode == 7'b0110111/*LUI*/ || Opcode == 7'b0010111/*AUIPC*/)
			Operation = 4'b0010;
		else
		begin
			case (Funct3)
				3'b000:
				begin
					if (ALUOp == 2'b01)
						Operation = 4'b1001;
					else if (ALUOp == 2'b11)
						Operation = 4'b0010;
					else if (Funct7 == 7'b0100000)
						Operation = 4'b0011;
					else
						Operation = 4'b0010;
				end
				3'b001:
				begin
					if (ALUOp == 2'b01)
						Operation = 4'b1010;
					else if (ALUOp == 2'b00)
						Operation = 4'b0010;
					else
						Operation = 4'b0110;
				end
				3'b010:
				begin
					if (ALUOp == 2'b00)
						Operation = 4'b0010;
					else
						Operation = 4'b0101;
				end
				3'b011:
					Operation = 4'b1101;
				3'b100:
				begin
					if (ALUOp == 2'b01)
						Operation = 4'b1011;
					else if (Opcode == 7'b0000011)
						Operation = 4'b0010;
					else
						Operation = 4'b0100;
				end
				3'b101:
				begin
					if (ALUOp == 2'b01)
						Operation = 4'b1100;
					else if (Opcode == 7'b0000011)
						Operation = 4'b0010;
					else
					if (Funct7 == 7'b0000000)
						Operation = 4'b0111;
					else if (Funct7 == 7'b0100000)
						Operation = 4'b1000;
				end
				3'b110:
				begin
					if (ALUOp == 2'b01)
						Operation = 4'b1110;
					else
						Operation = 4'b0001;
				end
				3'b111:
				begin
					if (ALUOp == 2'b01)
						Operation = 4'b1111;
					else
						Operation = 4'b0000;
				end
				default:
					Operation = 4'b0000;
			endcase
		end
	end
	
 
/* assign Store_Inst[0] = ((MemWrite == 1'b1) && (Funct3 == 3'b001)); //SH
assign Store_Inst[1] = ((MemWrite == 1'b1) && (Funct3 == 3'b000)); //SB
assign Load_Inst[0] = ((MemRead == 1'b1) && (Funct3 == 3'b001)) || ((MemRead == 1'b1) && (Funct3 == 3'b000)); //LH //LB
assign Load_Inst[1] = ((MemRead == 1'b1) && (Funct3 == 3'b101)) || ((MemRead == 1'b1) && (Funct3 == 3'b000));  //LHU //LB
assign Load_Inst[2] = ((MemRead == 1'b1) && (Funct3 == 3'b100)); //LBU 
	
	
	
 assign Operation[0]=    (ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b110) || // R-type OR
 						((ALUOp[0]==1'b1) && (Funct3==3'b110)) || //RTypeI OR
 						((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b000)) || // SUB
 						((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b001)) || //R SLL
 						((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //R SRA
 						((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b011)) || //R SLTU
 						((ALUOp[0]==1'b1) && (Funct3==3'b001)) || //I SLL
 						((ALUOp[0]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //I SRA
 						((ALUOp[0]==1'b1) && (Funct3==3'b011)) || //I SLTU
 						((ALUOp==2'b11) && (Funct3==3'b001)) || //BNE
 						((ALUOp==2'b11) && (Funct3==3'b110)) || //BLTU 						
 						((ALUOp==2'b11) && (Funct3==3'b111)); //BGEU					
 						

 assign Operation[1]= (ALUOp==2'b00) ||   // ADD
 						((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b000)) || //SUB	
 						((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b000)) || //R ADD
 						((ALUOp[0]==1'b1) && (Funct3==3'b000)) || //I ADD
 						((ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b101)) || //R SRL
 						((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //R SRA
 						((ALUOp==2'b01) && (Funct7==7'b0000000) && (Funct3==3'b101)) || //I SRL
 						((ALUOp[0]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //I SRA
 						((ALUOp==2'b11) && (Funct3==3'b000)) || //BEQ
 						((ALUOp==2'b11) && (Funct3==3'b001)); //BNE
 						
                  
 assign Operation[2]= ((ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b100)) || //R XOR
 					((ALUOp==2'b01) && (Funct3==3'b100)) || //I XOR
 					((ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b001)) || //R SLL
 					((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b101)) || //R SRL
 					((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //R SRA
 					((ALUOp[0]==1'b1) && (Funct3==3'b001) && (ALUOp[1]==1'b0)) || //I SLL
 					((ALUOp[0]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b101)) || //I SRL
 					((ALUOp[0]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //I SRA
 					((ALUOp==2'b11) && (Funct3==3'b101)) || //BGE
 					((ALUOp==2'b11) && (Funct3==3'b111)); //BGEU
 					

 assign Operation[3]= ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b010)) || //R SLT
 					((ALUOp[0]==1'b1) && (Funct3==3'b010)) || //I SLT
 					((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b011)) || //R SLTU
 					((ALUOp[0]==1'b1) && (Funct3==3'b011)) || //I SLTU
 					((ALUOp==2'b11) && (Funct3==3'b110)) || //BLTU
 					(ALUOp==2'b11) && (Funct3==3'b100) || //BLT		
 					((ALUOp==2'b11) && (Funct3==3'b000)) || //BEQ
 					((ALUOp==2'b11) && (Funct3==3'b001)) || //BNE
 					((ALUOp==2'b11) && (Funct3==3'b101)) || //BGE
 					((ALUOp==2'b11) && (Funct3==3'b111)); //BGEU			*/		
 	

endmodule
