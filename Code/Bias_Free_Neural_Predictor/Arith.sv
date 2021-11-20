module Perceptron_add 
(
	output wire [9:1] total_weights,

	input wire [48:1] weight_perceptron_conv,
	input wire [144:1] weight_perceptron_rs,
	input wire [2:1] bias
);
	//reg [48:1] weight_perceptron_conv;
	//reg [144:1] weight_perceptron_rs;
	//reg [2:1] bias;
	wire [72:1] weight_perceptron_conv_2;
	wire [36:1] weight_perceptron_conv_3;
	wire [18:1] weight_perceptron_conv_4;
	wire [9:1] weight_perceptron_conv_5;

	wire [9:1] weight_perceptron_total_conv;
	
	wire [216:1] weight_perceptron_rs_2;
	wire [108:1] weight_perceptron_rs_3;
	wire [54:1] weight_perceptron_rs_4;
	wire [27:1] weight_perceptron_rs_5;



	//Calculate total output Wm
	genvar i;
	generate
		for (i=1;i<=8;i=i+1) begin
			Full_adder_9_bit entity_0 ( .a({ {6{weight_perceptron_conv[6*i]}} ,weight_perceptron_conv[6*i:6*i-2]}), 
				 		    .b({ {6{weight_perceptron_conv[6*i-3]}} ,weight_perceptron_conv[6*i-3:6*i-5]}), .c(weight_perceptron_conv_2[i*9:i*9-8]));
		end
	endgenerate

	generate
                for (i=1;i<=4;i=i+1) begin
                        Full_adder_9_bit entity_1 ( .a(weight_perceptron_conv_2[18*i:18*i-8]), 
						    .b(weight_perceptron_conv_2[18*i-9:18*i-17]), .c(weight_perceptron_conv_3[9*i:9*i-8]) );
                end
        endgenerate

	generate
                for (i=1;i<=2;i=i+1) begin
                        Full_adder_9_bit entity_2 ( .a(weight_perceptron_conv_3[18*i:18*i-8]),
                                                    .b(weight_perceptron_conv_3[18*i-9:18*i-17]), .c(weight_perceptron_conv_4[9*i:9*i-8]) );
	        end
        endgenerate

	//Calculate total output Wm and bias
	Full_adder_9_bit entity_3 ( .a(weight_perceptron_conv_4[9:1]), .b(weight_perceptron_conv_4[18:10]), .c(weight_perceptron_conv_5));
	Full_adder_9_bit entity_4 ( .a(weight_perceptron_conv_5), .b({ {8{bias[2]}} ,bias[1]}), .c(weight_perceptron_total_conv));

	//Calculate total output Wrs
	generate
                for (i=1;i<=24;i=i+1) begin
                        Full_adder_9_bit entity_5 ( .a({ {6{weight_perceptron_rs[6*i]}}, weight_perceptron_rs[6*i:6*i-2]}), 
                                                    .b({ {6{weight_perceptron_rs[6*i-3]}}, weight_perceptron_rs[6*i-3:6*i-5]}), .c(weight_perceptron_rs_2[i*9:i*9-8]));
                end
        endgenerate

	generate
                for (i=1;i<=12;i=i+1) begin
                        Full_adder_9_bit entity_6 ( .a(weight_perceptron_rs_2[18*i:18*i-8]), 
                                                    .b(weight_perceptron_rs_2[18*i-9:18*i-17]), .c(weight_perceptron_rs_3[9*i:9*i-8]) );
                end 
        endgenerate

	generate
                for (i=1;i<=6;i=i+1) begin
                        Full_adder_9_bit entity_7 ( .a(weight_perceptron_rs_3[18*i:18*i-8]),
                                                    .b(weight_perceptron_rs_3[18*i-9:18*i-17]), .c(weight_perceptron_rs_4[9*i:9*i-8]) );
                end
        endgenerate

	generate
                for (i=1;i<=3;i=i+1) begin
                        Full_adder_9_bit entity_8 ( .a(weight_perceptron_rs_4[18*i:18*i-8]),
                                                    .b(weight_perceptron_rs_4[18*i-9:18*i-17]), .c(weight_perceptron_rs_5[9*i:9*i-8]) );
                end
        endgenerate

	wire [9:1] weight_perceptron_rs_6, weight_perceptron_rs_7;
	Full_adder_9_bit entity_9 ( .a(weight_perceptron_rs_5[9:1]), .b(weight_perceptron_rs_5[18:10]), .c(weight_perceptron_rs_6) );
	Full_adder_9_bit entity_10 ( .a(weight_perceptron_rs_5[27:19]), .b(weight_perceptron_rs_6), .c(weight_perceptron_rs_7) );

	//Final Output
	Full_adder_9_bit entity_11 ( .a(weight_perceptron_total_conv), .b(weight_perceptron_rs_7), .c(total_weights) );
	`ifdef FORMAL	
		always_comb begin
			
		end
	`endif
	//initial begin
	//	weight_perceptron_conv = 0;
	//	weight_perceptron_rs = 0;
	//	bias = 0;
	//	#20
	//	weight_perceptron_conv = 1;
	//	weight_perceptron_rs = 2;
	//	bias = 3;
	//end

endmodule : Perceptron_add


module Mul_perceptron_GHR

(
	output reg [48:1] weights,

	input wire [16:1] GHR_reg,
	input wire [48:1] perceptron_weights
);
	wire [48:1] perceptron_weights_temp;
	genvar i;
        generate
                for (i=1; i<=16; i=i+1) begin
                        Full_adder_3_bit Full_adder_3_bit ( .c(perceptron_weights_temp [(i-1)*3+1+:3]), .a(3'd1), .b(~perceptron_weights [(i-1)*3+1+:3]));
                end
        endgenerate

	
	always_comb begin
		for (int i=1; i<=16; i=i+1) begin
			if (GHR_reg [i]==1)
				weights [(i-1)*3+1+:3] = perceptron_weights [(i-1)*3+1+:3];
			else 
				weights [(i-1)*3+1+:3] =  perceptron_weights_temp [(i-1)*3+1+:3];
		end
	end

	`ifdef FORMAL
		logic [5:1] j =$anyseq;
		initial begin
		       	assume (j>=1);
			assume (j<=16);
		end
		logic [3:1] temp;
                always_comb begin
                        temp = ~perceptron_weights [(j-1)*3+1+:3]+1;
                        assert (temp == perceptron_weights_temp [(j-1)*3+1+:3]);
	                if (GHR_reg [j]==1)
        	               assert ( weights [(j-1)*3+1+:3] ==  perceptron_weights [(j-1)*3+1+:3]);
                	else
                       	       assert ( weights [(j-1)*3+1+:3] ==  perceptron_weights_temp [(j-1)*3+1+:3]);

		end
	`endif

endmodule

module Mul_perceptron_RS_H
(
	output reg [144:1] weights,

	input wire [48:1] RS_H,
	input wire [144:1] RS_weights
);
	wire [144:1] RS_weights_temp;
	
	genvar i;
	generate
		for (i=1; i<=48; i=i+1) begin
			Full_adder_3_bit Full_adder_3_bit ( .c(RS_weights_temp [(i-1)*3+1+:3]), .a(3'd1), .b(~RS_weights [(i-1)*3+1+:3]));
		end
	endgenerate

	always_comb begin
		for (int i=1; i<=48; i=i+1) begin
			if (RS_H[i] == 1)
				weights [(i-1)*3+1+:3] = RS_weights [(i-1)*3+1+:3];
                        else
                                weights [(i-1)*3+1+:3] = RS_weights_temp [(i-1)*3+1+:3];
		end
	end
	`ifdef FORMAL
		logic [6:1] j = $anyseq;
		initial begin
			assume (j>=1);
			assume (j<=48);
		end
		logic [3:1] temp;
		always_comb begin
			temp = ~RS_weights [(j-1)*3+1+:3]+1;
			assert (temp == RS_weights_temp [(j-1)*3+1+:3]);
			if (RS_H[j] == 1)
                               assert ( weights [(j-1)*3+1+:3] == RS_weights [(j-1)*3+1+:3]);
                        else
                               assert ( weights [(j-1)*3+1+:3] == RS_weights_temp [(j-1)*3+1+:3]);
		end

	`endif
endmodule

module Full_adder_3_bit
(
        output wire [3:1] c,

        input wire [3:1] a,
        input wire [3:1] b
);
        assign c=a+b;
endmodule

module Full_adder_9_bit 
(	
	output wire [9:1] c,

	input wire [9:1] a,
	input wire [9:1] b
);
	assign c=a+b;
endmodule

module Mux_prediction
(
	output reg prediction,

	input wire total_weights_sign_bit,
	input wire [1:0] bst_status
);
	//BST Status decide outcome of prediction 00 = not found, 01 == taken,
	//10 == not taken, 11 == non-bias
	always_comb begin
		if (bst_status == 0) begin
			prediction = 0;
		end
		else if (bst_status == 3) begin
			prediction = ~total_weights_sign_bit;
		end
		else 
			prediction = bst_status [0];
	end
endmodule

module Sr_total_weights 
(
	output reg [27:1] total_weights_update,

	input wire [9:1] total_weights,
	input clk, rst
);
	wire [27:1] total_weights_temp;

	assign total_weights_temp = total_weights_update;

	always_ff @(negedge clk) begin 
		if (rst == 1)
			total_weights_update <= 0;
		else
			total_weights_update <= {total_weights, total_weights_temp[27:10]};
	end
	`ifdef FORMAL
		logic f_valid = 0;
		always_ff @(negedge clk) begin
			f_valid = 1;
		end
		always_ff @(negedge clk) begin
			if (f_valid) begin
				if (($past(rst)))
					assert (total_weights_update == 0);
				else
					assert (total_weights_update == {$past(total_weights), $past(total_weights_update[27:10])} );
			end
		end
	`endif

endmodule

module Sr_prediction 
(
	output reg [3:1] prediction_update,

	input wire prediction,
	input wire clk, rst
);
	wire [3:1] prediction_temp;

	assign prediction_temp = prediction_update;

	always_ff @(negedge clk) begin
		if (rst == 1)
			prediction_update <= 0;
		else
			prediction_update <= {prediction , prediction_temp[3:2]};
	end
	`ifdef FORMAL
		logic f_valid = 0;
		always_ff @(negedge clk) begin
                        f_valid = 1;
                end

		always_ff @(negedge clk) begin
			if (f_valid) begin
				if ($past(rst))
					assert (prediction_update == 0);
				else
					assert (prediction_update == {$past(prediction), $past(prediction_update[3:2])});
			end
		end
	`endif

endmodule

module Sr_GHR_reg 
(
	output reg [48:1] GHR_reg_update,

	input wire [16:1] GHR_reg,
	input clk, rst
);
	wire [48:1] GHR_reg_temp;

	assign GHR_reg_temp = GHR_reg_update;

	always_ff @(negedge clk) begin 
		if (rst == 1)
			GHR_reg_update <= 0;
		else
			GHR_reg_update <= {GHR_reg, GHR_reg_temp[48:17]};
	end
	`ifdef FORMAL
                logic f_valid = 0;
                always_ff @(negedge clk) begin
                        f_valid = 1;
                end

                always_ff @(negedge clk) begin
			if (f_valid) begin
				if ($past(rst))
                                	assert (GHR_reg_update == 0);
                        	else
                                	assert (GHR_reg_update == {$past(GHR_reg), $past(GHR_reg_update[48:17])});
                	end
		end
        `endif


endmodule

module Sr_RS_H
(
	output reg [144:1] RS_H_update,

	input wire [48:1] RS_H,
	input clk, rst
);
	wire [144:1] RS_H_temp;

	assign RS_H_temp = RS_H_update;

	always_ff @(negedge clk) begin 
		if (rst == 1)
			RS_H_update <= 0;
		else
			RS_H_update <= {RS_H, RS_H_temp[144:49]};
	end
	`ifdef FORMAL
                logic f_valid = 0;
                always_ff @(negedge clk) begin
                        f_valid = 1;
                end

                always_ff @(negedge clk) begin
			if (f_valid) begin
				if ($past(rst))
                                	assert (RS_H_update == 0);
                        	else
                                	assert (RS_H_update == {$past(RS_H), $past(RS_H_update[144:49])});
                	end
		end
        `endif
endmodule
