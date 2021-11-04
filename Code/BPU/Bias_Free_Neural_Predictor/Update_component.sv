module BST_update 
(
	output wire [2:1] status_update,
	//output wire [32:1] PC_predict_update, output of alu
	output wire en_2, en_3, 		//en_2 for BST, en_3 for the other

	input wire Branch_direction,
	input wire Branch_prediction,
	input wire [32:1] inst, 			//inst at EX stage
	input wire [32:1] PC_predict, PC_actual, 	//PC comparision
	input wire [32:1] PC_alu,		 // PC comparision in case of both taken (some branch can jump to multiple address) to update PC jump in memory
	input wire [2:1] old_status
);
	
	wire PC_check;
	wire en_2_temp, en_3_temp;

	assign PC_check = (inst[7:1] == 7'b1100011)||(inst[7:1] == 7'b1101111)||(inst[7:1] == 7'b1100111);

	always_comb begin
		if (old_status == 0) begin
			en_2_temp = 1;
			en_3_temp = 0;
		        status_update[0] = Branch_direction;	
			status_update[1] = ~Branch_direction;
		end

		else if ( ((Branch_direction != Branch_prediction)||(PC_predict != PC_actual)) && ( (old_status==1) || (old_status==2) ) ) begin
			en_2_temp = 1;
			en_3_temp = 1;
			status_update = 3;
		end

		else if ( (old_status == 3) && (Branch_direction != Branch_prediction) ) begin
			en_2_temp = 0;
			en_3_temp = 1;
			status_update = 3;
		end
		       		
	end

	assign en_2 = en_2_temp & PC_check;
	assign en_3 = en_3_temp & PC_check;

	
endmodule

module Bias_update 
(
	output wire [2:1] bias_update,

	input wire [2:1] bias,
	input wire branch_direction
);
	wire [2:1] bias_inc_update
	wire [2:1] bias_dec_update

	Bias_inc Bias_inc ( .bias(bias) , .bias_inc(bias_inc_update) );
	Bias_dec Bias_dec ( .bias(bias) , .bias_dec(bias_dec_update) );
	always_comb begin
		if (branch_direction != bias[2])
			bias_update = bias_inc_update;
	       	else 
			bias_update = bias_dec_update;
	end
endmodule

module Bias_inc
(
	output wire [2:1] bias_inc,

	input wire [2:1] bias
);
	always_comb begin
		if (bias == 2'b01) 
			bias_inc = 2'b01;
		else if (bias == 2'b00)
			bias_inc = 2'b01;
		else if (bias == 2'b11)
			bias_inc = 2'b00;
		else
			bias_inc = 2'b11;
endmodule

module Bias_dec
(
        output wire [2:1] bias_dec,

        input wire [2:1] bias
);
        always_comb begin
                if (bias == 2'b01)
                        bias_dec = 2'b00;
                else if (bias == 2'b00)
                        bias_dec = 2'b11;
                else if (bias == 2'b11)
                        bias_dec = 2'b10;
                else
                        bias_dec = 2'b10;
endmodule

module Perceptron_update
(
	output wire [144:1] weight_update,
	
	input wire [144:1] weight,
	input wire branch direction
);
	wire [144:1] weight_inc_update;
	wire [144:1] weight_dec_update;

	genvar i;
	generate
		for (i=1; i<=16; i=i+1) begin
			Weight_inc Weight_inc (weight [3*i : 3*i-2], weight_inc_update [3*i: 3*i-2]);
		        Weight_dec Weight_dec (weight [3*i : 3*i-2], weight_inc_update [3*i: 3*i-2]);
		end
	endgenerate

	always_comb begin
		for (int i; i<=16; i=i+1) begin
			if (branch_direction != weight[i*3])
				weight_update [i*3-2+:2] = weight_inc_update [i*3-2+:2];
			else
				weight_update [i*3-2+:2] = wieght_inc_update [i*3-2+:2];
	end
endmodule

module Perceptron_update_BF
(
        output wire [432:1] weight_update,

        input wire [432:1] weight,
        input wire branch direction
);
        wire [432:1] weight_inc_update;
        wire [432:1] weight_dec_update;

        genvar i;
        generate
                for (i=1; i<=48; i=i+1) begin
                        Weight_inc Weight_inc (weight [3*i : 3*i-2], weight_inc_update [3*i: 3*i-2]);
                        Weight_dec Weight_dec (weight [3*i : 3*i-2], weight_inc_update [3*i: 3*i-2]);
                end
        endgenerate

        always_comb begin
                for (int i; i<=48; i=i+1) begin
                        if (branch_direction != weight[i*3])
                                weight_update [i*3-2+:2] = weight_inc_update [i*3-2+:2];
                        else
                                weight_update [i*3-2+:2] = wieght_inc_update [i*3-2+:2];
        end
endmodule


module Weight_inc
(
	output wire [3:1] weight_inc,

	input wire [3:1] weight
);
	always_comb begin
		case (weight)
			3'b000: weight_inc = 3'b001;
			3'b001: weight_inc = 3'b010;
			3'b010: weight_inc = 3'b011;
			3'b011: weight_inc = 3'b011;
			3'b100: weight_inc = 3'b101;
                        3'b101: weight_inc = 3'b110;
                        3'b110: weight_inc = 3'b111;
                        3'b111: weight_inc = 3'b000;
	end
endmodule

module Weight_dec
(
        output wire [3:1] weight_dec,

        input wire [3:1] weight
);
        always_comb begin
                case (weight)
                        3'b000: weight_dec = 3'b111;
                        3'b001: weight_dec = 3'b000;
                        3'b010: weight_dec = 3'b001;
                        3'b011: weight_dec = 3'b010;
                        3'b100: weight_dec = 3'b100;
                        3'b101: weight_dec = 3'b100;
                        3'b110: weight_dec = 3'b101;
                        3'b111: weight_dec = 3'b110;
        end
endmodule




