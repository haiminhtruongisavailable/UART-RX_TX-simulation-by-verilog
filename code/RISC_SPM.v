module RISC_SPM #(parameter word_size = 8, Sel1_size = 3, Sel2_size = 2)(
input clk, rst);
	wire [Sel1_size - 1:0] Sel_Bus_1_Mux;
	wire [Sel2_size - 1:0] Sel_Bus_2_Mux;
	wire zero;
	wire [word_size - 1:0] instruction, address, Bus_1, mem_word;
	wire Load_R0, Load_R1, Load_R2, Load_R3, Load_PC, Inc_PC, Load_IR,  
		 Load_Add_R, Load_Reg_Y, Load_Reg_Z, write;
	