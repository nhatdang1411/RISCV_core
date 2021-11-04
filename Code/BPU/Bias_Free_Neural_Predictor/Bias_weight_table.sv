module Bias_weigth_table #(parameter Bias_length = 1024)
(
	output reg [2:1] weight,

	input wire [10:1] index, index_update,
	input wire [2:1] weight_update,
	input wire en_1,
	input wire clk
);
	//Internal memory
	reg [2:1] bias_table [Bias_length:1];
	
	//Prediction
	always_ff @(posedge clk) begin
		weight <= bias_table [index];

	end
	//Update
	always_ff @(negedge clk) begin
		if (en_1 == 1)
			bias_table [index_update] <= weight_update;
	       	else
			;	
	end

endmodule


module Sr_Bias_weight 
(
	output reg [6:1] weight_update,

	input wire [2:1] weight,
	input wire clk, 
);
	wire [6:1] weight_update_temp;
	
	assign weight_update_temp = weight_update;
	always_ff @(negedge clk) begin
		weight_update <= {weight , weight_update[6:2]};
		
	end
endmodule	
	


