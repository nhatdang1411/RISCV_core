module AdderPC (oldPC, en ,newPC);
input wire [31:0] oldPC;
input wire en;
output reg [31:0] newPC;
always @* begin
	if (en==1)
	 	newPC=oldPC+4;
	else
		newPC=oldPC;
end
endmodule
