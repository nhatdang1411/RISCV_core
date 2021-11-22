module Branch_address_reg 
(
	output reg [160:1] Branch_address_iterative,

	input wire [10:1] Branch_address_update_iterative,   // input of PC reg in CPU design at prediction
	input wire [10:1] Branch_address_update,		// input of PC reg in CPU design
	input wire clk, en_1, en_2, rst, en_2_miss
);
						  // reg one always update after a prediction 
	reg [160:1] Branch_address_true;	// reg two update only from result at EX

	always_ff @(negedge clk) begin
		if (rst == 1)
			Branch_address_iterative <= 0;
		else begin
			if ((en_1 ==1) && (en_2 == 0) && (en_2_miss == 0))
				Branch_address_iterative <= {Branch_address_update_iterative,Branch_address_iterative[160:11]};
			else if (en_2_miss == 1)
				Branch_address_iterative <= Branch_address_true;
			else 
				Branch_address_iterative <= Branch_address_iterative ;
		end
	end
	always_ff @(negedge clk) begin
		if (rst ==1)
			Branch_address_true <= 0;
		else begin
			if (en_2 ==1)
				Branch_address_true <= {Branch_address_update, Branch_address_true[160:11]};
			else
				Branch_address_true <= Branch_address_true;
		end
	end
	
endmodule

module Folded_hist_reg
(
        output reg [160:1] Folded_hist_iterative,
	output wire [160:1] Folded_hist_true_1,

        input wire  Folded_hist_update_iterative,   // input of PC reg in CPU design at pred
        input wire  Folded_hist_update,                // input of PC reg in CPU design
        input wire clk, en_1, en_2, rst, en_2_miss
);
                                                  // reg one always update after a prediction
        reg [160:1] Folded_hist_true;        // reg two update only from result at EX
	assign Folded_hist_true_1 = Folded_hist_true;
        always_ff @(negedge clk) begin
		if (rst == 1) 
			Folded_hist_iterative <= 0;
		else begin
                	if ((en_1 ==1) && (en_2 == 0) && (en_2_miss == 0))
                        	Folded_hist_iterative <= {Folded_hist_update_iterative,Folded_hist_iterative[160:2]};
                	else if (en_2_miss == 1)
                        	Folded_hist_iterative <= Folded_hist_true;
        		else 
			 	Folded_hist_iterative <=  Folded_hist_iterative ;
		end
	end
        always_ff @(negedge clk) begin
		if (rst == 1)
			Folded_hist_true <= 0;
		else begin
                	if (en_2 ==1)
                        	Folded_hist_true <= {Folded_hist_update, Folded_hist_true[160:2]};
                	else
                        	Folded_hist_true <= Folded_hist_true;
		end
	end
endmodule


