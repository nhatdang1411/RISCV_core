module Regpipelinestage3 (clk,rst,newalu,newrs2,newpc,newinst,inst,pc,alu,rs2);
input wire [31:0]newinst,newpc,newalu,newrs2;
input wire clk,rst;
output reg [31:0]inst,pc,alu,rs2;
always@(negedge clk) begin
if (rst==1) begin
	inst<=32'h00000033;
	pc<=0;
	alu<=0;
	rs2<=0;
end
else	begin
	inst<=newinst;
	pc<=newpc;
	alu<=newalu;
	rs2<=newrs2;
end
end
endmodule
