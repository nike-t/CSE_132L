`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:23:43 PM
// Design Name: 
// Module Name: alu
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


module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )(
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult,
        output logic Branch_Taken	// This determines if branch is to be taken. 
        
        );
		always_comb  //SystemVerilog won't allow two assignments under each case in one always_comb block, so i had to implement two always_comb blocks
		begin
		Branch_Taken = 0;
		case(Operation)
			4'b1001:        //BEQ
				Branch_Taken = ($signed(SrcA) == $signed(SrcB)); 
			4'b1010:        //BNE
				Branch_Taken = ($signed(SrcA) != $signed(SrcB)); 
			4'b1011:        //BLT
				Branch_Taken = ($signed(SrcA) < $signed(SrcB)); 
			4'b1100:        //BGE
				Branch_Taken = ($signed(SrcA) >= $signed(SrcB)); 
			4'b1101:        //SLTIU
				Branch_Taken = 0;
			4'b1110:        //BLTU
				Branch_Taken = (SrcA < SrcB);
			4'b1111:        //BGEU
				Branch_Taken = (SrcA >= SrcB);
			default:
				Branch_Taken = 0;
			endcase
		end
		
		always_comb
		begin
		ALUResult = 'd0;
		case(Operation)
			4'b0000:        //AND
				ALUResult = SrcA & SrcB;
			4'b0001:        //OR
				ALUResult = SrcA | SrcB;
			4'b0010:        //ADD
				ALUResult = (SrcA) + (SrcB);
			4'b0011:        //Subtract
				ALUResult = $signed(SrcA) - $signed(SrcB);
			4'b0100:        //XOR
				ALUResult = SrcA ^ SrcB;
			4'b0101:        //SLTI
				ALUResult = ($signed(SrcA) < $signed(SrcB));
			4'b0110:        //SLL
				ALUResult = SrcA << SrcB[4:0];
			4'b0111:        //SRL
				ALUResult = SrcA >> SrcB[4:0];
			4'b1000:        //SRA
				ALUResult = $signed(SrcA) >>> $signed(SrcB[4:0]);
			4'b1001:        //BEQ
				ALUResult = $signed(SrcA) - $signed(SrcB);
			4'b1010:        //BNE
				ALUResult = $signed(SrcA) - $signed(SrcB);
			4'b1011:        //BLT
				ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'h1 : 32'hffffffff;
			4'b1100:        //BGE
				ALUResult = ($signed(SrcA) >= $signed(SrcB)) ? 32'h1 : 32'hffffffff;
			4'b1101:        //SLTIU
				ALUResult = (SrcA < SrcB);
			4'b1110:        //BLTU
				ALUResult = (SrcA < SrcB) ? 32'h1 : 32'hffffffff;
			4'b1111:        //BGEU
				ALUResult = (SrcA >= SrcB) ? 32'h1 : 32'hffffffff;
			default:
				ALUResult = 'b0;
		endcase
		end
			
endmodule

