module Perceptron_table_BF #(parameter Perceptron_table_length = 65536)
(
	output reg [144:1] perceptron_weights,

	input wire [768:1] index, index_update,
	input wire [144:1] perceptron_weights_update,
	input wire clk, en_1
);
	reg [144:1] perceptron_table_BF [Perceptron_table_length:1];

	//Initialize
        initial begin
                for (int i=1; i<=Perceptron_table_length; i=i+1) begin
                        perceptron_table_BF[i]<=0;
                end
        end

	//Prediction	
	always_ff @(posedge clk) begin
                for (int i=1; i<=48; i=i+1) begin
                        perceptron_weights [3*(i-1)+1 +: 2] <= perceptron_table_BF [index[16*(i-1)+1+:15]] [3*(i-1)+1+:2];
                end
        end

	//Update
	
	always_ff @(negedge clk) begin
                if (en_1==1)
                        for (int i=1; i<=48; i=i+1) begin
                                perceptron_table_BF [index_update[16*(i-1)+1+:15]] [3*(i-1)+1+:2] <= perceptron_weights_update [3*(i-1)+1+:2];
                        end
                else
                        ;
        end


endmodule

module Sr_perceptron_address_BF
(
        output reg [3072:1] perceptron_address_update,

        input wire [768:1] perceptron_address,
        input wire clk
);
        wire [3072:1] perceptron_address_update_temp;

        assign perceptron_address_update_temp = perceptron_address_update;

        always_ff @(posedge clk) begin
                perceptron_address_update <= {perceptron_address, perceptron_address_update_temp [3072:769]};
        end
endmodule

module Sr_perceptron_weight_BF
(
        output reg [432:1] perceptron_weight_update,

        input wire [144:1] perceptron_weight,
        input wire clk
);
        wire [432:1] perceptron_weight_update_temp;

        assign perceptron_weight_update_temp=perceptron_weight_update;

        always_ff @(posedge clk) begin
               perceptron_weight_update <= {perceptron_weight, perceptron_weight_update [432:145]};
               
        end
endmodule


