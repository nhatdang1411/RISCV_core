module Perceptron_table_BF #(parameter Perceptron_table_length = 65535)
(
	output reg [144:1] perceptron_weights,

	input wire [768:1] index, index_update,
	input wire [144:1] perceptron_weights_update,
	input wire clk, en_1
);
	reg [144:1] perceptron_table_BF [Perceptron_table_length:0];

	//Initialize
        initial begin
                for (int i=0; i<=Perceptron_table_length; i=i+1) begin
                        perceptron_table_BF[i]<=0;
                end
        end

	//Prediction	
	always_ff @(posedge clk) begin
                for (int i=1; i<=48; i=i+1) begin
                        perceptron_weights [3*(i-1)+1 +: 3] <= perceptron_table_BF [index[16*(i-1)+1+:16]] [3*(i-1)+1+:3];
                end
        end

	//Update
	
	always_ff @(posedge clk) begin
                if (en_1==1)
                        for (int i=1; i<=48; i=i+1) begin
                                perceptron_table_BF [index_update[16*(i-1)+1+:16]] [3*(i-1)+1+:3] <= perceptron_weights_update [3*(i-1)+1+:3];
                        end
                else
                        for (int i=1; i<=48; i=i+1) begin
                                perceptron_table_BF [index_update[16*(i-1)+1+:16]] [3*(i-1)+1+:3] <= perceptron_table_BF [index_update[16*(i-1)+1+:16]] [3*(i-1)+1+:3];
                        end;
        end
	`ifdef FORMAL
		logic f_valid = 1'b0;
		always_ff @(posedge clk) begin
			f_valid <= 1;
		end
		logic [6:1] j = $anyseq;
		logic [6:1] k = $anyseq;
		logic [768:1] index_1 = $anyseq;
		logic [768:1] index_update_1 = $anyseq;
		logic [144:1] perceptron_weights_update_1 = $anyseq;

		always begin
			assume (index_1 == index);
			assume (index_update_1 == index_update);
			assume (perceptron_weights_update_1 == perceptron_weights_update);
			assume ((j>=1)&&(j<=48)) ;
			assume ((k>=1)&&(k<=48)) ;
		end
		always_ff @(posedge clk) begin
			if (f_valid == 1) begin
                        	assert (perceptron_weights [3*(j-1)+1 +: 3] == $past ( perceptron_table_BF [index_1[16*(j-1)+1+:16]] [3*(j-1)+1+:3]) );
				if ($past(en_1))
					assert (perceptron_table_BF [ $past (index_update_1[16*(k-1)+1+:16]) ] [3*(k-1)+1+:3] == $past ( perceptron_weights_update_1 [3*(k-1)+1+:3] ) );
				else
					assert (perceptron_table_BF [ $past (index_update_1[16*(k-1)+1+:16]) ] [3*(k-1)+1+:3] == $past ( perceptron_table_BF [index_update_1[16*(k-1)+1+:16]] [3*(k-1)+1+:3] ) );
				
			end
		end
	`endif

endmodule

module Sr_perceptron_address_BF
(
        output reg [2304:1] perceptron_address_update,

        input wire [768:1] perceptron_address,
        input wire clk, rst
);
        wire [2304:1] perceptron_address_update_temp;

        assign perceptron_address_update_temp = perceptron_address_update;

        always_ff @(negedge clk) begin
		if (rst == 1)
			perceptron_address_update <= 0;
		else
                	perceptron_address_update <= {perceptron_address, perceptron_address_update_temp [2304:769]};
        end
endmodule

module Sr_perceptron_weight_BF
(
        output reg [432:1] perceptron_weight_update,

        input wire [144:1] perceptron_weight,
        input wire clk, rst
);
        wire [432:1] perceptron_weight_update_temp;

        assign perceptron_weight_update_temp=perceptron_weight_update;

        always_ff @(negedge clk) begin
		if (rst == 1) 
			perceptron_weight_update <= 0;
		else
               		perceptron_weight_update <= {perceptron_weight, perceptron_weight_update [432:145]};
             
        end
endmodule


