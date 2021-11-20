module Perceptron_table #(parameter Perceptron_table_length = 1023)
(
	output reg [48:1] perceptron_weights,

	(* anyseq *)input wire [160:1] index, index_update,
	(* anyseq *)input wire [48:1] perceptron_weights_update,
	input clk, en_1
);
	reg [48:1] perceptron_table [Perceptron_table_length:0];
      

	//Initialize
	initial begin
		for (int i=0; i<=Perceptron_table_length; i=i+1) begin
			perceptron_table[i]<=0;
		end	
	end

	//Prediction
	always_ff @(posedge clk) begin
		for (int i=1; i<=16; i=i+1) begin
			perceptron_weights [3*(i-1)+1+:3] <= perceptron_table [index[10*(i-1)+1+:10]] [3*(i-1)+1+:3];
		end
	end	
	//Update
	always_ff @(posedge clk) begin
		if (en_1==1)
			for (int i=1; i<=16; i=i+1) begin
				perceptron_table [index_update[10*(i-1)+1+:10]] [3*(i-1)+1+:3] <= perceptron_weights_update [3*(i-1)+1+:3];
			end
		else
			for (int i=1; i<=16; i=i+1) begin
                                perceptron_table [index_update[10*(i-1)+1+:10]] [3*(i-1)+1+:3] <= perceptron_table [index_update[10*(i-1)+1+:10]] [3*(i-1)+1+:3] ;
                        end
	end
	
	`ifdef FORMAL
		logic f_valid = 0;
		logic [5:1] j = 10;

		always begin
			assume ( (j>=1) && (j<=16) ) ;
		end
		always_ff @(posedge clk) begin
			f_valid =1;
		end
		always_ff @(posedge clk) begin
			if (f_valid)
				assert	(perceptron_weights [3*(j-1)+1+:3] == $past (perceptron_table [index[10*(j-1)+1+:10]] [3*(j-1)+1+:3]) ) ;
		end
		always_ff @(posedge clk) begin
			if (f_valid) begin
				if ($past(en_1)) 
                         		       assert (perceptron_table [$past(index_update[10*(10-1)+1+:10])] [3*(10-1)+1+:3] == $past(perceptron_weights_update [3*(10-1)+1+:3]));
               
				else 
                		               assert ( perceptron_table [$past(index_update[10*(10-1)+1+:10])] [3*(10-1)+1+:3] == $past(perceptron_table [index_update[10*(10-1)+1+:10]] [3*(10-1)+1+:3])) ;

			end
				
		end
	`endif



endmodule

module Sr_perceptron_address
(
	output reg [480:1] perceptron_address_update,

	input wire [160:1] perceptron_address,
	input wire clk, rst
);
	wire [480:1] perceptron_address_update_temp;

	assign perceptron_address_update_temp = perceptron_address_update;

	always_ff @(negedge clk) begin
		if (rst == 1) 
			perceptron_address_update <= 0;
		else
			perceptron_address_update <= {perceptron_address, perceptron_address_update_temp [480:161]};
	end
endmodule

module Sr_perceptron_weight
(
	output reg [144:1] perceptron_weights_update,
		
	input wire [48:1] perceptron_weights,
	input wire clk, rst
);
	wire [144:1] perceptron_weight_update_temp;

	assign perceptron_weight_update_temp=perceptron_weights_update;

	always_ff @(negedge clk) begin
		if (rst == 1) 
			perceptron_weights_update <= 0;
		else
			perceptron_weights_update <= {perceptron_weights, perceptron_weight_update_temp [144:49]};
	end
endmodule


