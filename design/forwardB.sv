`timescale 1ns / 1ps
module forwardB(
		input logic [1:0] ForwardB,
		input logic [31:0] Reg2_IDEX, ALUResult_EXMEM, WB_Data,
		output logic [31:0] SrcB
		);

	always_comb
	begin
		case (ForwardB)
			2'b00:
				SrcB = Reg2_IDEX;
			2'b10:
				SrcB = ALUResult_EXMEM;
			2'b01:
				SrcB = WB_Data;
			default:
				SrcB = Reg2_IDEX;
		endcase
	end
endmodule
