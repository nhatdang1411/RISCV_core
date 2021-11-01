module Regpipelinestage4 (clk,newDataR,newinst,newalu,newpc,alu,inst,DataR,pc);
input wire [31:0]newinst,newDataR,newalu,newpc;
input wire clk;
output reg [31:0]inst,DataR,alu,pc;
always@(negedge clk) begin
	inst<=newinst;
	DataR<=newDataR;
	alu<=newalu;
	pc<=newpc;
end
endmodule
