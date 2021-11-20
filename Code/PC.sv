module PC (clk,oldPC, newPC);
input clk;
input [31:0] oldPC;
output reg [31:0] newPC;
always @(negedge clk) 
	begin
			newPC<=oldPC;
	end
endmodule
