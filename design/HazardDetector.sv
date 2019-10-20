`timescale 1ns / 1ps

module HazardDetector(
		input logic [2:0] MemRead_IDEX,
		input logic [4:0] RD_IDEX, RS1_IFID, RS2_IFID,
		output logic PCWrite, IFIDWrite, HazardSelect
		);

	always_comb begin  
		if ((MemRead_IDEX != 3'b101) && ((RD_IDEX == RS1_IFID) || (RD_IDEX == RS2_IFID))) begin
			PCWrite <= 1;
			IFIDWrite <= 1;
			HazardSelect <= 1;
		end
		else begin
			PCWrite <= 0;
			IFIDWrite <= 0;
			HazardSelect <= 0;
		end
	end
endmodule