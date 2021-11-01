module Regpipelinestage2 (clk,rst,newrs1,newrs2,newpc,newinst,inst,pc,rs1,rs2);
input wire [31:0]newinst,newpc,newrs1,newrs2;
input wire clk,rst;
output reg [31:0]inst,pc,rs1,rs2;
always@(negedge clk) begin
if (rst==1)
begin
	inst=32'h00000033;
	pc=0;
	rs1=0;
	rs2=0;
end	
else begin
	inst=newinst;
	pc=newpc;
	rs1=newrs1;
	rs2=newrs2;
end
end
endmodule