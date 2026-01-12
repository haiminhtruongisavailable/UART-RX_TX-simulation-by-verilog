module Processing_Unit #(parameter 
word_size = 8, op_size = 4, Sel1_size = 3, Sel2_size = 2)(
	output [word_size - 1:0] instruction, address, Bus_1,
	output 					 Zflag,
	input [word_size - 1: 0] mem_word,
	input 					 Load_R0, Load_R1, Load_R2, Load_R3, Load_PC,
							 Inc_PC,
	input [Sel1_size - 1: 0] Sel_Bus_1_Mux,
	input [Sel2_size - 1: 0] Sel_Bus_2_Mux,
	input 					 Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z,
	input 					 clk, rst

);