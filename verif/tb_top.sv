`timescale 1ns / 1ps

module tb_top;

//clock and reset signal declaration
  logic tb_clk, reset;
  logic [31:0] tb_WB_Data; 
  /*, tb_ALU_Result, tb_Reg1, tb_Reg2;
  logic [3:0] tb_ALU_CC;
  logic [8:0] tb_IDEX_PCOut;
  logic [31:0] tb_IDEX_Reg1Out;
  logic [31:0] tb_SrcB;
  logic [31:0] tb_ALUResult;
  logic [4:0] tb_RD_MEMWB_Out;
  logic [31:0] tb_Result;
  logic [31:0] tb_ALUResult_EXMEM_Out;
  logic [31:0] tb_ALUResult_MEMWB_Out;*/

  

  always #5 tb_clk = ~tb_clk; // #10
  
  initial begin
    tb_clk = 0;
    reset = 1;
    #15 reset =0; //#25
  end
  
  
  riscv riscV(
      .clk(tb_clk),
      .reset(reset),
      .WB_Data(tb_WB_Data)
      /*.ALU_CC(tb_ALU_CC),
      .IDEX_PCOut(tb_IDEX_PCOut),
      .IDEX_Reg1Out(tb_IDEX_Reg1Out),
      .SrcB(tb_SrcB),
      .ALUResult(tb_ALUResult),
      .RD_MEMWB_Out(tb_RD_MEMWB_Out),
      .Result(tb_Result),
      .ALUResult_EXMEM_Out(tb_ALUResult_EXMEM_Out),
      .ALUResult_MEMWB_Out(tb_ALUResult_MEMWB_Out)*/
     );

  initial begin
    #1000;
    $finish;
   end
endmodule
