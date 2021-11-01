module muxdmem(ALU,mem,pc,WBsel,wb);
	input wire [31:0]ALU;
	input wire [31:0]mem;
	input wire [31:0] pc;	
	input wire [1:0]WBsel;
	output reg [31:0]wb;
	initial begin
	wb=32'd0;
	end
	always @* begin
		case (WBsel)
			2'b00: wb=mem;
			2'b01: wb=ALU;
			2'b10: wb=pc;	
		endcase
	end
endmodule
