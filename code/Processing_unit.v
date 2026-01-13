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

//do for each block first
	wire ...;
	wire ...;
	wire ...;
	wire ...;
	Register_Unit R0 (R0_out, Bus_2, Load_R0, clk, rst);
	Register_Unit R1 (R1_out, Bus_2, Load_R1, clk, rst);
	Register_Unit R2 (R2_out, Bus_2, Load_R2, clk, rst);
	Register_Unit R3 (R3_out, Bus_2, Load_R3, clk, rst);
	Register_Unit Reg_Y (Y_value, Bus_2, Load_Reg_Y, clk, rst);
	D_flop 		  Reg_Z (Z_flag, alu_zero_flag, Load_Reg_Z, clk, rst);
	
	
	
	
endmodule
	
	//Register_Unit 
	module Register_Unit #(parameter word_size = 8)(
		output reg [word_size - 1: 0] data_out,
		input [word_size - 1: 0] data_in,
		input 					 load, clk, rst
	);
	//consider load as clock signal (controlled by CU)
		always@(posedge clk, negedge rst)begin
			if(rst == 1'b0) data_out <= 0;
			else if(load) data_out <= data_in;
		end
	endmodule
	
	// D_flop 
	module D_flop (
	output reg data_out,
	input data_in,
	input load, clk, rst
	);
		always@(posedge clk, negedge rst)begin
			if(rst == 1'b0) data_out <= 0;
			else if(load == 1'b1) data_out <= data_in;
		end
	
	
