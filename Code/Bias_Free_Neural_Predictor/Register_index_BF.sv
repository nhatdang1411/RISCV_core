module Branch_address_folded_hist_reg_pos_BF
( 
	//Branch_address
	output wire [16:1] Stack_branch_iterative [48:1] ,

	input wire [16:1] Branch_address_update_iterative,
	input wire [16:1] Branch_address_update,
	//Common signal
	input wire clk, rst,
	input wire  en_1, en_2,
	//Folded Hist
	output wire [48:1] Folded_hist_iterative,
	
	input wire  Folded_hist_update_iterative,
	input wire Folded_hist_update,

	//Position
	output wire [6:1] Pos_iterative [48:1],

	input wire [6:1] Pos_update_iterative,
	input wire [6:1] Pos_update	

);	
	//Internal signal for Branch address reg
	wire [16:1] Stack_branch_true [48:1];	
	wire [48:1] signal_clk, signal_clk_2;	//output of PC comparator
	
//	reg rst,clk,en_1,en_2;
//	reg [16:1] Branch_address_update_iterative;
//	reg [16:1] Branch_address_update;
//	reg Folded_hist_update_iterative;
//	reg Folded_hist_update;
//	reg [6:1] Pos_update_iterative;
//	reg [6:1] Pos_update;
	
	//Common signal
	wire clk_iterative, clk_true; //two clock for two different kind of register

	assign clk_iterative = ((en_1 ==1) | (en_2 == 1)) & clk;
	assign clk_true = (en_2==1) & clk;

	PC_comparator PC_comparator_1 ( .Branch_address_iterative(Stack_branch_iterative), .Branch_address_update(Branch_address_update_iterative), .signal(signal_clk) );
	PC_comparator PC_comparator_2 ( .Branch_address_iterative(Stack_branch_true), .Branch_address_update(Branch_address_update), .signal(signal_clk_2) );

	//Branch address
	genvar i;
	Recency_stack_branch Recency_stack_branch_1 ( .D_stack(Branch_address_update_iterative), .signal_2(Stack_branch_true[48]), .signal(signal_clk[48]), .clk(clk_iterative), .en(en_2), .Stack_out(Stack_branch_iterative[48]), .rst(rst) );
	generate
		for (i=47; i>=1; i=i-1) begin
			Recency_stack_branch Recency_stack_branch_1 ( .D_stack(Stack_branch_iterative[i+1]), .signal_2(Stack_branch_true[i]), .signal(signal_clk[i]), .clk(clk_iterative), .en(en_2), .Stack_out(Stack_branch_iterative[i]), .rst(rst) );
		end
	endgenerate
	
	Recency_stack_branch Recency_stack_branch_2 ( .D_stack(Branch_address_update), .signal_2(Stack_branch_true[48]), .signal(signal_clk_2[48]), .clk(clk_true), .en(1'b0), .Stack_out(Stack_branch_true[48]), .rst(rst) );
	generate
		for (i=47; i>=1; i=i-1) begin
			Recency_stack_branch Recency_stack_branch_1 ( .D_stack(Stack_branch_true[i+1]), .signal_2(Stack_branch_true[i]), .signal(signal_clk_2[i]), .clk(clk_true), .en(1'b0), .Stack_out(Stack_branch_true[i]), .rst(rst) );
		end
	endgenerate




//		for (i=1; i<=16; i=i+1) begin
//			Recency_stack entity_0 ( .D_stack (Branch_address_update_iterative[i]), .signal(signal_clk), .clk(clk_iterative), .Stack(Branch_address_iterative [48:1][i]), .en(en_2), .signal_2(Branch_address_true[48:1][i]));   		
//		end
//	endgenerate
//	generate
//                for (i=1; i<=16; i=i+1) begin
//                        Recency_stack entity_1 ( .D_stack (Branch_address_update[i]), .signal(signal_clk_2), .clk(clk_true), .Stack(Branch_address_true [48:1][i]), .en(0), .signal_2(Branch_address_true[48:1][i]) );
//               end
//        endgenerate

	//Folded_hist
	wire [48:1] Folded_hist_true;
	Recency_stack_hist Recency_stack_hist ( .D_stack(Folded_hist_update_iterative), .signal_2(Folded_hist_true[48]), .signal(signal_clk[48]), .clk(clk_iterative), .en(en_2), .Stack_out(Folded_hist_iterative[48]), .rst(rst));
	generate 
		for (i=47; i>=1; i=i-1) begin
			Recency_stack_hist Recency_stack_hist_iterative ( .D_stack(Folded_hist_iterative[i+1]), .signal_2(Folded_hist_true[i]), .signal(signal_clk[i]), .clk(clk_iterative), .en(en_2), .Stack_out(Folded_hist_iterative[i]), .rst(rst));
		end	
	endgenerate

	Recency_stack_hist Recency_stack_hist_2 ( .D_stack(Folded_hist_update), .signal_2(Folded_hist_true[48]), .signal(signal_clk_2[48]), .clk(clk_true), .en(1'b0), .Stack_out(Folded_hist_true[48]), .rst(rst));
	generate 
		for (i=47; i>=1; i=i-1) begin
			Recency_stack_hist Recency_stack_hist_true ( .D_stack(Folded_hist_true[i+1]), .signal_2(Folded_hist_true[i]), .signal(signal_clk_2[i]), .clk(clk_true), .en(1'b0), .Stack_out(Folded_hist_true[i]), .rst(rst));
		end	
	endgenerate
	//Position
	wire [6:1] Stack_true [48:1];

	Recency_stack_pos entity_4 ( .D_stack(6'd0), .signal_2(Stack_true[48]), .signal(signal_clk[48]), .clk(clk_iterative), .en(en_2), .Stack_out(Pos_iterative [48]), .rst(rst));
	generate 
		for (i=47; i>=1; i=i-1) begin
			Recency_stack_pos entity_5 ( .D_stack(Pos_iterative[i+1]), .signal_2(Stack_true[i]), .signal(signal_clk[i]), .clk(clk_iterative), .en(en_2), .Stack_out(Pos_iterative [i]), .rst(rst));
		end
	endgenerate

	Recency_stack_pos entity_6 ( .D_stack(6'd0), .signal_2(Stack_true[48]), .signal(signal_clk_2[48]), .clk(clk_true), .en(1'b0), .Stack_out(Stack_true [48]), .rst(rst));
	generate 
		for (i=47; i>=1; i=i-1) begin
			Recency_stack_pos entity_7 ( .D_stack(Stack_true[i+1]), .signal_2(Stack_true[i]), .signal(signal_clk_2[i]), .clk(clk_true), .en(1'b0), .Stack_out(Stack_true [i]), .rst(rst));
		end
	endgenerate
	
	//Simulate test
	//always begin
	//	clk=0;
	//	forever #20 clk=~clk;
	//end

	//initial begin
	//	en_1=0;
	//	en_2=0;
	//	rst = 1;
	//	#60
	//	Branch_address_update = 16'h00ff;
//		Branch_address_update_iterative = 16'hffff;
//		Folded_hist_update = 1; 
//		Folded_hist_update_iterative = 0;
//		Pos_update_iterative = 15;
//		Pos_update = 2;
//		rst = 0;
//		en_1= 1;
//		en_2= 0;
//		#40
//		Branch_address_update = 16'h00ff;
//		Branch_address_update_iterative = 16'h0fff;
//		Folded_hist_update = 1; 
//		Folded_hist_update_iterative = 1;
//		Pos_update_iterative = 15;
//		Pos_update = 2;
//		en_1 = 1;
//		en_2 = 0;
//		#40
//		Branch_address_update = 16'h01ff;
//		Branch_address_update_iterative = 16'hffff;
//		Folded_hist_update = 0; 
//		Folded_hist_update_iterative = 1;
//		Pos_update_iterative = 7;
//		Pos_update = 2;
//		en_1 = 1;
//		en_2 = 0;
//		#40
//		Branch_address_update = 16'h01ff;
//		Branch_address_update_iterative = 16'h0fff;
//		Folded_hist_update = 0; 
//		Folded_hist_update_iterative = 1;
//		Pos_update_iterative = 3;
//		Pos_update = 2;
//		en_2 = 1;
//		en_1 = 0;
//		#40
//		Branch_address_update = 16'h00ff;
//		Branch_address_update_iterative = 16'hffff;
//		Folded_hist_update = 1; 
//		Folded_hist_update_iterative = 0;
//		Pos_update_iterative = 15;
//		Pos_update = 2;
//		en_1 = 1;
//		en_2 = 1;
//		#40
//		Branch_address_update = 16'h0000;
//		Branch_address_update_iterative = 16'h000f;
//		Folded_hist_update = 0; 
//		Folded_hist_update_iterative = 0;
//		Pos_update_iterative = 1;
//		Pos_update = 1;
//		en_1 = 0;
//		en_2 = 0;
//	end

endmodule
module Recency_stack_hist
( 
	output reg Stack_out,

	input wire D_stack,
	input wire  signal_2,
	input wire signal,
	input wire clk, en, rst
);
	reg  Stack_reg;
	wire  Stack;
	
	//Simulate


	assign Stack =Stack_reg;

	always_ff @(negedge clk) begin
		if (rst == 1)
			Stack_reg <= 0;
		else begin
			if ((signal == 0) && (en == 0)) 
				Stack_reg <= D_stack;
			else if (en == 1)
				Stack_reg <= signal_2;
			else
				Stack_reg <= Stack_reg;
		end
	end
	
	always_comb begin
		if (rst == 1) 
			Stack_out = 0;
		else begin
			Stack_out = Stack_reg;
		end
	end
	
endmodule
module Recency_stack_branch
( 
	output reg [16:1] Stack_out,

	input wire [16:1] D_stack,
	input wire [16:1] signal_2,
	input wire signal,
	input wire clk, en, rst
);
	reg [16:1] Stack_reg;
	wire [16:1] Stack;
	
	//Simulate


	assign Stack =Stack_reg;

	always_ff @(negedge clk) begin
		if (rst == 1)
			Stack_reg <= 0;
		else begin
			if ((signal == 0) && (en == 0))
				Stack_reg <= D_stack;
			else if (en == 1)
				Stack_reg <= signal_2;
			else
				Stack_reg <= Stack_reg;
		end
	end
	
	always_comb begin
		if (rst == 1) 
			Stack_out = 0;
		else begin
			Stack_out = Stack_reg;
		end
	end
	
endmodule
module Recency_stack_pos
(
	output reg [6:1] Stack_out,

	input wire [6:1] D_stack,
	input wire [6:1] signal_2, //From true reg if necessary
	input wire signal,	   // Enable update if it 's branch
	input wire clk, en, rst	   // en is for misprediction
);
	reg [6:1] Stack_reg, Stack_add;
	wire [6:1]  Stack;	

	//Simulate

	assign Stack = Stack_reg;

	always_ff @(negedge clk) begin
		if (rst == 1) 
			Stack_reg <= 0;
		else begin
			if ((signal == 0) && (en == 0))
				Stack_reg <= D_stack;
			else if (en == 1)
				Stack_reg <= signal_2;
			else
				Stack_reg <= Stack_reg;
		end
	end

	always_comb begin
		if (Stack == 63)
			Stack_add = Stack;
		else
			Stack_add = Stack+1;
	end

	always_comb begin
		if (rst == 1) 
			Stack_out = 0;
		else if (en == 0)
			Stack_out = Stack_add;
		else
			Stack_out = Stack_reg;
	end
	

endmodule

module Recency_stack
(
	output wire [48:1] Stack ,

	input D_stack,
	input wire [48:1] signal_2, // From the true reg
	input wire [48:1] signal, // From PC comparator
	input wire clk, en, rst
);
	wire [48:1] signal_clk;
	
	assign rst = 0;
	assign signal_clk = ~signal & {48{clk}};

	D_flip_flop D_flip_flop_48 ( .out(Stack[48]), .D(D_stack), .clk(signal_clk[48]), .rst(rst), .sel(en), .signal(signal[48]));
	genvar i;
	generate
		for (i=47 ; i>=1; i=i-1) begin
			D_flip_flop entity_0  ( .out(Stack[i]), .D(Stack[i+1]), .clk(signal_clk[i]), .rst(rst), .sel(en), .signal(signal[i]));
		end	
	endgenerate

endmodule
	

module PC_comparator 
(
	output reg [48:1] signal,

	input wire [16:1] Branch_address_iterative [48:1],
	input wire [16:1] Branch_address_update
);

	always_comb begin
		signal[48] = 0;
		signal[47] = ( Branch_address_update == Branch_address_iterative [48] );	
		for (int i=46; i>=1; i=i-1) begin
			if (Branch_address_update == Branch_address_iterative [i+1])
				signal [i] = signal [i+1] | 1;
			else
				signal [i] = signal [i+1];
		end
	end
	
endmodule
	

module D_flip_flop
(
	output reg out,

	input wire signal,
	input wire sel,
	input wire D,
	input wire clk,
	input wire rst
);
	reg Q;
	//Simulate 

	always_ff @(negedge clk) begin
		if (rst == 1)
			Q <= 0;
		else 
			Q <= D;
	end
	always_comb begin
		if (rst == 1)
			out = 0;
		else begin
			if (sel == 1)
				out = signal;
			else
				out = Q;
		end
	end
	

endmodule

	
