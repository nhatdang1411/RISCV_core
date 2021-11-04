module Perceptron_add 
(
	output wire [9:1] total_weights,

	input wire [48:1] weight_perceptron_conv,
	input wire [144:1] weight_perceptron_rs,
	input wire [2:1] bias
);
	
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
	FUll_adder_9_bit entity_4 ( .a(weight_perceptron_conv_5), .b({ {8{bias[2]}} ,bias[1]}), .c(weight_perceptron_total_conv));

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

	Full_adder_9_bit entity_9 ( .a(weight_perceptron_rs_5[9:1]), .b(weight_perceptron_rs_5[18:10]), .c(weight_perceptron_rs_6) );
	Full_adder_9_bit entity_10 ( .a(weight_perceptron_rs_5[27:19]), .b(weight_perceptron_rs_6), .c(weight_perceptron_rs_7) );

	//Final Output
	Full_adder_9_bit entity_11 ( .a(weight_perceptron_total_conv), .b(weight_perceptron_rs_7), .c(total_weights) );
	`ifdef FORMAL
		always_comb begin
			assert (weight_perceptron_total_conv == {8{bias[2],bias[1]}+{7{weight_perceptron_conv[3]},weight_perceptron_conv[2:1]}+{7{weight_perceptron_conv[6]},weight_perceptron_conv[5:4]}+
				{7{weight_perceptron_conv[9]},weight_perceptron_conv[8:7]}+{7{weight_perceptron_conv[12]},weight_perceptron_conv[11:10]}+
				{7{weight_perceptron_conv[15]},weight_perceptron_conv[14:13]}+{7{weight_perceptron_conv[18]},weight_perceptron_conv[17:16]}
				+{7{weight_perceptron_conv[21]},weight_perceptron_conv[20:19]}+{7{weight_perceptron_conv[24]},weight_perceptron_conv[23:22]}+{7{weight_perceptron_conv[27]},
				weight_perceptron_conv[26:25]}+{7{weight_perceptron_conv[30]},weight_perceptron_conv[29:28]}+{7{weight_perceptron_conv[33]},weight_perceptron_conv[32:31]}
				+{7{weight_perceptron_conv[36]},weight_perceptron_conv[35:34]}+{7{weight_perceptron_conv[39]},weight_perceptron_conv[38:37]}
				+{7{weight_perceptron_conv[42]},weight_perceptron_conv[40:41]}+{7{weight_perceptron_conv[45]},
                                weight_perceptron_conv[44:43]}+{7{weight_perceptron_conv[48]},weight_perceptron_conv[47:46]} );
		end
	`endif


endmodule : Perceptron_add

module Full_adder_9_bit 
(	
	output wire [9:1] c,

	input wire [9:1] a,
	input wire [9:1] b
);
	assign c=a+b;
endmodule
