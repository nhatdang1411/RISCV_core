module PC_comparator 
(
	output wire en_1;
	output reg en_2;
	
	input wire  [32:1]PC;
);

	always_comb begin
		if (PC[7:1] == 7'b1100011)||(PC[7:1] == 7'b1101111)||(PC[7:1] == 7'b1100111)
			en_1 = 1;
		else 
			en_1 = 0;
	end
	always_ff @(posedge clk) begin
		en_2 <= en_1;
	end
	//Simulate
	initial begin
		en_1 <= 0;
		en_2 <= 0;
	end
endmodule
