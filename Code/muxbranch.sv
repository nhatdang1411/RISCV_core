module muxbranch(rs1,pc,ASel,rs1new);
input wire [31:0]rs1;
input wire [31:0]pc;
input wire ASel;
output reg [31:0]rs1new;
always @* begin
	rs1new=(rs1&{32{~ASel}})|(pc&{32{ASel}});
end
endmodule
