module Regpipelinestage0 (clk,newpc,pc,rst);
input wire [31:0]newpc;
input wire clk,rst;
output reg [31:0]pc;
always@(negedge clk) begin
	pc=newpc;
if (rst==1) pc=0;
end
endmodule
