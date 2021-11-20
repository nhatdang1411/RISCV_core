module Bias_weight_table #(parameter Bias_length = 1023)
(
	output reg [2:1] weight,

	(*anyseq*) input wire [10:1] index, index_update,
	input wire [2:1] weight_update,
	input wire en_1,
	input wire clk
);
	//Internal memory
	reg [2:1] bias_table [Bias_length:0];
	
	//Simulate
	initial begin
		for (int i = 0; i <= Bias_length; i=i+1) begin
			 bias_table [i] <= 0;
		end
	end	

	//Prediction
	always_ff @(posedge clk) begin
		weight <= bias_table [index];

	end
	//Update
	always_ff @(posedge clk) begin
		if (en_1 == 1)
			bias_table [index_update] <= weight_update;
	       	else
			bias_table [index_update] <= bias_table [index_update];	
	end
	`ifdef FORMAL
		logic f_valid = 0;
		always_ff @(posedge clk) begin
			f_valid=1;
		end
		always_ff @ (posedge clk) begin
			if (f_valid)
				assert ( weight == $past(bias_table [(index)]));
		end
		always_ff @ (posedge clk) begin
			if (f_valid) begin
				if ($past(en_1))
					assert ( bias_table[$past(index_update)] == $past(weight_update));
				else
					assert (bias_table[$past(index_update)] == $past(bias_table[(index_update)]));
			end
		end
	`endif

endmodule


module Sr_Bias_weight 
(
	output reg [6:1] weight_update,

	input wire [2:1] weight,
	input wire clk, rst
);
	wire [6:1] weight_update_temp;
	
	assign weight_update_temp = weight_update;
	always_ff @(negedge clk) begin
		if (rst ==1)
			weight_update <= 0;
		else
			weight_update <= {weight , weight_update_temp[6:3]};
		
	end
	`ifdef FORMAL
		logic f_valid = 0;
		always@(negedge clk) begin
			f_valid<=1;
		end
		always@(negedge clk) begin
			if (f_valid) begin
				if ($past(rst))
					assert (weight_update == 0);
				else
					assert (weight_update == {$past(weight),$past(weight_update[6:3])});
			end
		end		
	`endif
endmodule	
	


