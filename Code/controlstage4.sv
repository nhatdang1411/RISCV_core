module controlstage4 (inst,MemRW,whb);
input wire [31:0]inst;
output reg [2:0] whb;
output reg MemRW;
wire [9:0]contr;
assign contr={inst[31:25],inst[14:12]};
initial begin
MemRW=1'b0;whb=3'd0;
end
always@*
	begin
	case(inst[6:0])
	7'b0110011:	case(contr)
				10'h000: begin MemRW=1'b0;whb=3'd0; end
				10'h100: begin MemRW=1'b0;whb=3'd0; end
				10'h001: begin MemRW=1'b0;whb=3'd0; end
				10'h002: begin MemRW=1'b0;whb=3'd0; end
				10'h003: begin MemRW=1'b0;whb=3'd0; end
				10'h004: begin MemRW=1'b0;whb=3'd0; end
				10'h005: begin MemRW=1'b0;whb=3'd0; end
				10'h105: begin MemRW=1'b0;whb=3'd0; end
				10'h006: begin MemRW=1'b0;whb=3'd0; end
				10'h007: begin MemRW=1'b0;whb=3'd0; end
				default:; 
			endcase
	7'b0010011:	case(inst[14:12])
				3'b000: begin MemRW=1'b0;whb=3'd0; end
				3'b010: begin MemRW=1'b0;whb=3'd0; end
				3'b011: begin MemRW=1'b0;whb=3'd0; end
				3'b100: begin MemRW=1'b0;whb=3'd0; end
				3'b110: begin MemRW=1'b0;whb=3'd0; end
				3'b111: begin MemRW=1'b0;whb=3'd0; end
				3'b001: begin MemRW=1'b0;whb=3'd0; end
				3'b101:case(inst[30])
					1'b0: begin MemRW=1'b0;whb=3'd0; end
					1'b1: begin MemRW=1'b0;whb=3'd0; end
					endcase
			endcase
	7'b0000011:	case(inst[14:12])
				3'b000: begin MemRW=1'b0;whb=3'b000; end
				3'b001: begin MemRW=1'b0;whb=3'b001; end
				3'b010: begin MemRW=1'b0;whb=3'b010; end
				3'b100: begin MemRW=1'b0;whb=3'b011; end
				3'b101: begin MemRW=1'b0;whb=3'b100; end
			endcase
	7'b0100011:	case(inst[14:12])
				3'b000: begin  MemRW=1'b1;whb=3'd0; end
				3'b001: begin  MemRW=1'b1;whb=3'd1; end
				3'b010: begin  MemRW=1'b1;whb=3'd2; end
				default:;	
			endcase
	7'b1100011: MemRW=1'b0;
	7'b0110111: begin MemRW=1'b0;whb=3'd0; end
	7'b0010111: begin MemRW=1'b0;whb=3'd0; end
	7'b1101111: begin MemRW=1'b0;whb=3'd0; end
	7'b1100111: begin MemRW=1'b0;whb=3'd0; end
	default:;

	endcase	
	end
endmodule
