module muxpc(alu,pcold,brb,PCSel,hit,check,pcnew);
input wire [31:0]alu;
input wire [31:0]pcold,brb;
input wire PCSel,hit,check;
output reg [31:0]pcnew;
initial begin
pcnew=32'd0;
end
always @* begin
if (hit==1) pcnew=brb;
else
begin	
	if (check==1) pcnew=pcold;
	else begin	if (PCSel==1)
				pcnew=alu;
			else pcnew=pcold;
end
end

end
endmodule
