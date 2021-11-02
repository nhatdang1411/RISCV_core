module Branch_status_table #(parameter BST_length = 16384)
(
	output wire [2:1] status,
	output wire [32:1] PC_predict_o,

	input wire [2:1] status_update,
	input wire [14:1] PC_index, PC_index_update,
	input wire [32:1] PC_predict_update,
	input wire clk,en_1,en_2
);
	//Internal memory
	reg [2:1] status_bits [BST_length:1];
	reg [32:1] PC_predict [BST_length:1];
	//Prediction
	always_ff @(posedge clk) begin
		if (en_1==1)
			status <= status_bits [PC_index];
			PC_predict_o <= PC_predict [PC_index];
		else
			status <= 0;
			PC_predict_o <= 0;
	end
	//Update
	always_ff @(negedge clk) begin
		if (en_2==1)
			status_bits[PC_index_update] <= status_update;
			PC_predict[PC_index_update] <= PC_predict_update;
		else
			;
	//Initialize
	initial begin
		integer i;
		for (i=1; i <= BST_length; i=i+1) begin
			status_bits[i] <= 0;
			PC_predict[i] <= 0;
		end
	end
			
endmodule

module Sr_BST_status_address 
(
	output reg [6:1] status_update,
	output reg [96:1] address_update,

	input wire [2:1] status,
	input wire [32:1] address,
	input wire en
);
	wire [6:1] status_update_temp;
	wire [96:1] address_update_temp;

	assign status_update_temp=status_update;
	assign address_update_temp=status_update
	always_ff @(posedge clk) begin
		if (en==1)
			status_update <= {status, status_update_temp[6:3]};
			address_update <= {address, address_update_temp[96:33]};
		else
			;
	end

endmodule

module Sr_BST_index
(
	output reg [56:1] index_update,

	input wire [14:1] index,
	input wire en
);
	wire [56:1] index_update_temp;

	assign index_update_temp=index_update;
	always_ff @(posedge clk) begin
		if (en==1)
			index_update <= {index, index_update_temp[56:15]};
		else
			;
endmodule
