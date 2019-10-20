`timescale 1ns / 1ps

module ForwardingUnit(
		input logic [4:0] RS1_IDEX, RS2_IDEX, RD_EXMEM, RD_MEMWB,
		input logic RegWrite_EXMEM, RegWrite_MEMWB,
		output logic [1:0] ForwardA, ForwardB
		);

	always_comb begin
		// ForwardA
		if (RegWrite_EXMEM && (RD_EXMEM != 0) && (RD_EXMEM == RS1_IDEX))		// EX Hazard		
			ForwardA <= 2'b10;
		else if (RegWrite_MEMWB && (RD_MEMWB != 0) && (RD_MEMWB == RS1_IDEX))		// MEM Hazard
			ForwardA <= 2'b01;
		else
			ForwardA <= 2'b00;

		// ForwardB
		if (RegWrite_EXMEM && (RD_EXMEM != 0) && (RD_EXMEM == RS2_IDEX)) 		// EX Hazard
		
			ForwardB <= 2'b10;
		else if (RegWrite_MEMWB && (RD_MEMWB != 0) && (RD_MEMWB == RS2_IDEX))		// MEM Hazard
			ForwardB <= 2'b01;
		else
			ForwardB <= 2'b00;
	end
endmodule