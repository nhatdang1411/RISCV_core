module Regpipelinestage1 (clk,rst,newinst,newpc,inst,pc);
input wire [31:0]newinst,newpc;
input wire clk,rst;
output reg [31:0]inst,pc;
always@(negedge clk) begin
if (rst==1) begin
	inst=32'h000033;
	pc=0;
	end
else begin	
	inst=newinst;
	pc=newpc;
end
end
endmodule
