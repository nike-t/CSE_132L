`timescale 1ns / 1ps
module forwardA(
		input logic [1:0] ForwardA,
		input logic [31:0] Reg1_IDEX, ALUResult_EXMEM, WB_Data,
		output logic [31:0] SrcA
		);

	always_comb 
	begin
		case (ForwardA)
			2'b00:
				SrcA = Reg1_IDEX;
			2'b10:
				SrcA = ALUResult_EXMEM;
			2'b01:
				SrcA = WB_Data;
			default:
				SrcA = Reg1_IDEX;
		endcase
	end
endmodule
