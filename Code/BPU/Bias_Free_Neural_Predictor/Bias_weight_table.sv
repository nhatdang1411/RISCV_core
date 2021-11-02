module Bias_weigth_table #(parameter Bias_length = 1024);
(
	output wire [2:1] weight,

	input [10:1] index, index_update,
	input [2:1] weight_update,
	input en_1, en_2,
	input clk
);
	//Internal memory
	reg [2:1] bias_table [Bias_length:1];
	
	//Prediction
	always_ff @(posedge clk) begin
		if (en_1 == 1)
			weight <= bias_table [index];
		else
			weight <= 0;
	end
	//Update
	always_ff @(negedge clk) begin
		if (en_2 == 1)
			bias_table [index_update] <= weight_update;
	       	else
			;	
	end

endmodule

module Sr_Bias_index 
(
	output reg [40:1] index_update, 

	input [10:1] index,
	input clk, en
);
	wire [40:1] index_update_temp;

	assign index_update_temp = index_update;

	always_ff @(posedge clk) begin
		if (en==1)
			index_update <= {index, index_update_temp[40:11]};
		else 
			;
	end
	
endmodule

module Sr_Bias_weight 
(
	output reg [6:1] weight_update,

	input [2:1] weight,
	input clk, en
);
	wire [6:1] weight_update_temp;
	
	assign weight_update_temp = weight_update;
	always_ff @(negedge clk) begin
		if (en==1)
			weight_update <= {weight , weight_update[6:2]};
		else 
			;
endmodule	
	


