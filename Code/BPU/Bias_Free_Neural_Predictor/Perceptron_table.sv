module Perceptron_table #(parameter Perceptron_table_length = 1024);
(
	output wire [48:1] perceptron_weights,

	input wire [160:1] index, index_update,
	input wire [48:1] perceptron_weights_update,
	input clk, en_1, en_2
);
	reg [48:1] perceptron_table [Perceptron_table_length:1];
        integer i;
	//Prediction
	always_ff @(posedge clk) begin
		if (en_1==1) 
			for (i=1; i<=16; i=i+1) begin
				perceptron_weights [3*i:3*(i-1)+1] <= perceptron_table [index[10*i:10*(i-1)+1]] [3*i:3*(i-1)+1];
			end
		else
			perceptron_weights <= 0;

	end	
	//Update
	always_ff @(negedge clk) begin
		if (en_2==1)
			for (i=1; i<=16; i=i+1) begin
				perceptron_table [index_update[10*i:10*(i-1)+1]] [3*i:3*(i-1)+1] <= perceptron_weights_update [3*i:3*(i-1)+1]
			end
		else
			;
	end
	//Initialize
	initial begin
		for (i=1; i<=Perceptron_table_length; i=i+1) begin
			perceptron_table[i]<=0;
		end	
	end


endmodule

module Sr_perceptron_address
(
	output reg [640:1] perceptron_address_update,

	input wire [160:1] perceptron_address,
	input clk, en_1
);
	wire [640:1] perceptron_address_update_temp;

	assign perceptron_address_update_temp = perceptron_address_update;

	always_ff @(posedge clk) begin
		if (en_1==1)
			perceptron_address_update <= {perceptron_address, perceptron_address_update_temp [640:161]};
		else
			perceptron_address_update <= perceptron_address_update;
	end
endmodule

module Sr_perceptron_weight
(
	output reg [144:1] perceptron_weight_update;
		
	input wire [48:1] perceptron_weight,
	input clk, en_1
);
	wire [144:1] perceptron_weight_update_temp;

	assign perceptron_weight_update_temp=perceptron_weight_update;

	always_ff @(posedge clk) begin
		if (en_1==1)
			perceptron_weight_update <= {perceptron_weight, perceptron_weight_update [144:49]};
		else
			perceptron_weight_update <= perceptron_weight_update;
endmodule


