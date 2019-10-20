`timescale 1ns / 1ps

module datamemory#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_W = 32
    )(
    input logic clk,
	input logic [2:0] MemRead , // comes from control unit
	input logic [1:0] MemWrite , // Comes from control unit
    input logic [ DM_ADDRESS -1:0] a , // Read / Write address - 9 LSB bits of the ALU output
    input logic [ DATA_W -1:0] wd , // Write Data
    output logic [ DATA_W -1:0] rd // Read Data
    );
    
    logic [DATA_W-1:0] mem [(2**DM_ADDRESS)-1:0];
    
    always_comb 
    begin
    	rd=rd;
       case(MemRead)
       	3'b000: 			// Full word
            rd = mem[a];
        3'b001:   //Half Word
        		rd = {mem[a][DATA_W-1]? 16'hffff : 16'h0 , mem[a][15:0]};
        	3'b010:    //Half Word Unsigned
        		rd = {16'b0, mem[a][15:0]};
        	3'b011:  //Load Byte
        		rd = {mem[a][DATA_W-1]? 24'hffffff : 24'h0 , mem[a][7:0]};
        	3'b100:  //Load Byte Unsigned
        		rd = {24'b0, mem[a][7:0]};
        	default:
        		rd=0;
       endcase
	end
    
    always @(posedge clk) begin
    	mem[a]=mem[a];
       case (MemWrite)
       	2'b00:		//Full Word
            mem[a] = wd;
        2'b01:		//Half Word
            mem[a] =  {wd[15]? 16'hffff : 16'h0 , wd[15:0]};
        2'b10:		//Byte
            mem[a] = {wd[7]? 24'hffffff : 24'h0, wd[7:0]};  
        default:
        		mem[a]= mem[a];
       endcase
    end
    
endmodule

