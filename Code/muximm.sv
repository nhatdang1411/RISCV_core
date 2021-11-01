module muximm(imm, rs2, bsel, out);
	input wire [31:0]imm;
	input wire [31:0]rs2;
	input wire bsel;
	output reg [31:0]out;
	always @* begin
	out=({32{bsel}}&imm)|({32{~bsel}}&rs2);
	end
endmodule
