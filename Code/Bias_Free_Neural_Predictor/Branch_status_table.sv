module Branch_status_table #(parameter BST_length = 16383)
(
	output reg [2:1] status,
	output reg [32:1] PC_predict_o,
	
	input wire [2:1] status_update,
	(*anyseq*) input wire [32:1] PC_in, PC_update,
	(*anyseq*) input wire [32:1] PC_predict_update,
	input wire clk,en_1
);
	wire [14:1] PC_index, PC_index_update;


	//Internal memory
	reg [2:1] status_bits [BST_length:0];
	reg [32:1] PC_predict [BST_length:0];
	reg [32:1] PC [BST_length:0];


	//Combinational
	
	assign PC_index = PC_in [14:1];
	assign PC_index_update = PC_update [14:1];

	//Initialize
	initial begin
		for ( int i=1; i <= BST_length; i=i+1) begin
			status_bits[i] <= 0;
			PC_predict[i] <= 0;
			PC[i]=0;
		end
	end

	//Prediction
	always_ff @(posedge clk) begin
		
		if ( (PC[PC_index]==PC_in) && (status_bits[PC_index]!=0) ) begin
			status <= status_bits [PC_index];
			PC_predict_o <= PC_predict [PC_index];
		end
		else begin
			status <= 0;
			PC_predict_o <= 0;
		end
	end
	//Update
	always_ff @(posedge clk) begin
		if (en_1==1) begin
			status_bits[PC_index_update] <= status_update;
			PC [PC_index_update] <= PC_update ;
			PC_predict[PC_index_update] <= PC_predict_update;
		end
		else begin
			status_bits[PC_index_update] <= status_bits[PC_index_update] ;
                        PC [PC_index_update] <= PC [PC_index_update] ;
                        PC_predict[PC_index_update] <= PC_predict[PC_index_update] ;
		end
	end
	`ifdef FORMAL
	logic f_valid=0;
	always_ff@(posedge clk) begin
		f_valid <= 1;
	end
	always_ff@(posedge clk) begin
		if (f_valid) begin
			if (($past(PC[(PC_index)])==$past(PC_in)) && ($past(status_bits[(PC_index)])!=0)) begin
				assert (status == $past(status_bits[(PC_index)]));
				assert (PC_predict_o == $past(PC_predict [(PC_index)]));
			end
			else begin
				assert (status == 0);
				assert (PC_predict_o == 0);
			end
		end
	end
	always_ff@(posedge clk) begin
		if (f_valid) begin
			if ($past(en_1)) begin
				assert( status_bits[$past(PC_index_update)] == $past(status_update) );
				assert( PC [$past(PC_index_update)] == $past (PC_update) );
				assert( PC_predict[$past(PC_index_update)] == $past(PC_predict_update) );
			end
			else begin
				assert( status_bits[$past(PC_index_update)] == status_bits[$past(PC_index_update)] );
				assert( PC [$past(PC_index_update)] == PC [$past(PC_index_update)] );
				assert( PC_predict[$past(PC_index_update)] == PC_predict[$past(PC_index_update)] );
			end
		end
	end
	`endif		
endmodule

module Sr_BST_status_address 
(
	output reg [6:1] status_update,		// Status_ from BST
	output reg [96:1] address_update, //PC_predict_o from BST

	input wire [2:1] status,
	input wire [32:1] address, 
	input wire clk,rst
);
	wire [6:1] status_update_temp;
	wire [96:1] address_update_temp;

	assign status_update_temp=status_update;
	assign address_update_temp=address_update;

	always_ff @(negedge clk) begin
		if (rst == 1) begin
			status_update <= 0;
			address_update <= 0;
		end
		else begin
			status_update <= {status, status_update_temp[6:3]};
			address_update <= {address, address_update_temp[96:33]};
		end
	end
	`ifdef FORMAL
	logic f_valid = 1'b0;
	always_ff @(negedge clk) begin
		f_valid <= 1;
	end
	always_ff @(negedge clk) begin
		if (f_valid) begin
			if ($past(rst) == 1) begin
				assert (status_update == 0);
				assert (address_update == 0);
			end
			else begin
				assert (status_update == {$past(status), $past(status_update[6:3])});
				assert (address_update == {$past(address), $past(address_update[96:33])});
			end
		end	
	end
	`endif
endmodule

//For simulation
module Mux_prediction_address 
( 
	output reg [32:1] PC_predict,

	input wire [32:1] PC_nottaken, PC_taken,
	input wire prediction
);
	always_comb begin
		if (prediction ==1) 
			PC_predict = PC_taken;
		else
			PC_predict = PC_nottaken+4;
	end
endmodule
module Sr_PC_in
(
	output reg [96:1] PC_in_update,
	
	input wire [32:1] PC_in,
	input wire clk, rst
);
	wire [96:1] PC_in_temp;

	assign PC_in_temp = PC_in_update;
	
	always_ff @(negedge clk) begin
		if (rst == 1)
			PC_in_update <= 0;
		else
			PC_in_update <= {PC_in , PC_in_temp[96:33]};
	end
endmodule

module Sr_PC_predict
(
	output reg [96:1] PC_in_predict,
	
	input wire [32:1] PC_in,
	input wire clk, rst
);
	wire [96:1] PC_in_temp;

	assign PC_in_temp = PC_in_predict;
	
	always_ff @(negedge clk) begin
		if (rst == 1)
			PC_in_predict <= 0;
		else
			PC_in_predict <= {PC_in , PC_in_temp[96:33]};
	end
endmodule
