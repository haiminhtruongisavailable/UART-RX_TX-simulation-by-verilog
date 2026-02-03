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
	wire [word_size-1:0] Bus_2;
	wire [word_size-1:0] R0_out, R1_out, R2_out, R3_out;
	wire [word_size-1:0] PC_count, Y_value, alu_out;
	wire 				 alu_zero_flag;
	wire [op_size-1:0] opcode=instruction[word_size-1:word_size-op_size];
	
	// Register_unit get input from bus_2 into bus_1?
	//load: switch to load data
	Register_Unit R0 (R0_out, Bus_2, Load_R0, clk, rst);
	Register_Unit R1 (R1_out, Bus_2, Load_R1, clk, rst);
	Register_Unit R2 (R2_out, Bus_2, Load_R2, clk, rst);
	Register_Unit R3 (R3_out, Bus_2, Load_R3, clk, rst);
	Register_Unit Reg_Y (Y_value, Bus_2, Load_Reg_Y, clk, rst);
	D_flop 		  Reg_Z (Z_flag, alu_zero_flag, Load_Reg_Z, clk, rst);
	
	Address_Register Add_R (address, Bus_2, Load_Add_R, clk, rst);//Load_AR: tied 'fetch' signal
	Instruction_Register IR (instruction, Bus_2, Load_IR, clk, rst);//Load_IR: fetch finish
	Program_Counter PC (PC_count, Bus_2, Load_PC, Inc_PC, clk, rst);
	Multiplexer_5ch Mux_1 (Bus_1, R0_out, R1_out, R2_out, R3_out, PC_count);
	Multiplexer_3ch Mux_2 (Bus_2, alu_out, Bus_1, mem_word, Sel_Bus_2_Mux);
	Alu_RISC 		ALU   (alu_out, alu_zero, zero_flag, Y
	
	
	
	
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
	module Address_Register #(parameter word_size = 8)( //hold the address that point to the next instruction
		output reg [word_size - 1:0] data_out,
		input [word_size - 1:0] data_in,
		input 					load, clk, rst
	);
	always@(posedge clk, negedge rst) begin
		if(rst == 1'b0) data_out <= 1'b0;
		else if (load == 1'b1) data_out <= data_in;
	end
	endmodule
	
	
	module Instruction_Register #(parameter word_size = 8) ( //hold current instruction
		output reg [word_size - 1 : 0] data_out, 
		input 	   [word_size - 1 : 0] data_in,
		input 						   load, clk, rst
	);
	always@(posedge clk, negedge rst) begin
		if(rst == 1'b0) data_out <= 1'b0;
		else if(load == 1'b1) data_out <= data_in;
	end
	endmodule
	
	module Program_Counter #(parameter word_size = 8)(
		output reg [word_size - 1: 0] count,
		input 	   [word_size - 1: 0] data_in, 
		input 						  Load_PC, Inc_Pc,
		input 						  clk, rst
	);
	always@(posedge clk, negedge rst) begin 
		if(rst == 1'b1) count <= 0;
		else if(Load_PC == 1'b1) count <= data_in;
		else if(Inc_PC == 1'b1) count <= count + 1;
	end
	endmodule
	
	module Multiplexer_5ch #(parameter word_size = 8)(
		output [word_size - 1:0] 	mux_out,
		input  [word_size - 1:0]	data_a, data_b, data_c, data_d, data_e,
		input  [2:0] 				sel
	);
	assign mux_out = (sel == 0)   ?data_a:(sel==1)
								  ?data_b:(sel==2)
								  ?data_c:(sel==3)
								  ?data_d:(sel==4)
								  ?data_e:'bx;
	endmodule
	
	module Multiplexer_3ch #(parameter word_size=8)(
		output 	[word_size-1:0] mux_out,
		input	[word_size-1:0] data_a, data_b, data_c,
		input 	[1:0] sel
	);
	assign mux_out = (sel==0)?data_a:(sel==1)?data_b:(sel==2)?data_c:'bx;
	endmodule
	
	module Alu_RISC #(parameter word_size=8, op_size=4,
		NOP 	= 4'b0000,
		ADD		= 4'b0001,
		SUB 	= 4'b0010,
		AND		= 4'b0011,
		NOT 	= 4'b0100,
		RD 		= 4'b0101,
		WR 		= 4'b0110,
		BR		= 4'b0111,
		BRZ		= 4'b1000
	)(
		output reg [word_size-1:0] alu_out,
		output 					   alu_zero_flag,
		input 	   [word_size-1:0] data_1, data_2,
		input 	   [op_size-1:0]   sel
	);
	assign alu_zero_flag = ~|alu_out;
	always@(sel, data_1, data_2)
		case(sel)
			NOT: alu_out = 0;
			ADD: alu_out = data_1 + data_2;
			SUB: alu_out = data_1 - data_2;
			AND: alu_out = data_1 & data_2;
			NOT: alu_out = ~data_2;
			default: alu_out = 0;
		endcase
	endmodule
		
<<<<<<< HEAD
	
=======
	
>>>>>>> 8655ca9dc5f76c178abcc65bc530a9caf171de86
