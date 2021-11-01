module controlstage1 (inst,BrEq,BrLT,PCSel);
input wire [31:0]inst;
input wire BrEq,BrLT;
output reg PCSel;
wire [9:0]contr;
assign contr={inst[31:25],inst[14:12]};
initial begin
PCSel=1'b0;
end
always@*
	begin
	case(inst[6:0])
	7'b0110011:	PCSel=1'b0;
	7'b0010011:	PCSel=1'b0;
	7'b0000011:	PCSel=1'b0;
	7'b0100011:	PCSel=1'b0;
	7'b1100011:	case(inst[14:12])
				3'b000: 
					if (BrEq==1'b1)
						begin  PCSel=1'b1;end
					else if (BrEq==1'b0)
						begin  PCSel=1'b0;end
					
				3'b001: 
					if (BrEq==1'b0)
						begin  PCSel=1'b1;end
					else if (BrEq==1'b1)
						begin  PCSel=1'b0;end
					
				3'b100:
					if (BrLT==1'b1)
						begin  PCSel=1'b1;end
					else if (BrLT==1'b0)
						begin  PCSel=1'b0;end
					
				3'b101: 
					if (BrLT==1'b0)
						begin  PCSel=1'b1;end
					else if (BrLT==1'b1)
						begin  PCSel=1'b0;end
					
				3'b110: 
					if (BrLT==1'b1)
						begin  PCSel=1'b1;end
					else if (BrLT==1'b0)
						begin  PCSel=1'b0;end
					
				3'b111:
					if (BrLT==1'b0)
						begin  PCSel=1'b1;end
					else if (BrLT==1'b1)
						begin  PCSel=1'b0;end
					
				default:;
				endcase
	7'b0110111: begin PCSel=1'b0; end
	7'b0010111: begin PCSel=1'b0; end
	7'b1101111: begin PCSel=1'b1;end
	7'b1100111: begin PCSel=1'b1; end
	default:;

	endcase	
	end
endmodule