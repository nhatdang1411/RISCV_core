module muxdtfwrs2( in1, in2, in3, sel,out );
	input wire [31:0] in1,in2,in3;
	input wire [1:0] sel;
	output reg [31:0] out;
	always @* begin	
		if (sel==2'b00)
			out=in1;
		else if (sel==2'b01)
			out=in2;
		else if (sel==2'b10)
			out=in3;
	end
endmodule
