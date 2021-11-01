module controlstage5 (inst,WBsel,RegWEn);
input wire [31:0]inst;
output reg [1:0]WBsel;
output reg RegWEn;
wire [9:0]contr;
assign contr={inst[31:25],inst[14:12]};
initial begin
WBsel=2'b01;RegWEn=1'b0;
end
always@*
	begin
	case(inst[6:0])
	7'b0110011:	case(contr)
				10'h000: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h100: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h001: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h002: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h003: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h004: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h005: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h105: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h006: begin WBsel=2'b01;RegWEn=1'b1; end
				10'h007: begin WBsel=2'b01;RegWEn=1'b1; end
				default:; 
			endcase
	7'b0010011:	case(inst[14:12])
				3'b000: begin   WBsel=2'b01;RegWEn=1'b1; end
				3'b010: begin   WBsel=2'b01;RegWEn=1'b1; end
				3'b011: begin   WBsel=2'b01;RegWEn=1'b1; end
				3'b100: begin   WBsel=2'b01;RegWEn=1'b1; end
				3'b110: begin   WBsel=2'b01;RegWEn=1'b1; end
				3'b111: begin   WBsel=2'b01;RegWEn=1'b1; end
				3'b001: begin   WBsel=2'b01;RegWEn=1'b1; end
				3'b101:case(inst[30])
					1'b0: begin   WBsel=2'b01;RegWEn=1'b1; end
					1'b1: begin   WBsel=2'b01;RegWEn=1'b1; end
					endcase
			endcase
	7'b0000011:	case(inst[14:12])
				3'b000: begin   WBsel=2'b00;RegWEn=1'b1; end
				3'b001: begin   WBsel=2'b00;RegWEn=1'b1; end
				3'b010: begin   WBsel=2'b00;RegWEn=1'b1; end
				3'b100: begin   WBsel=2'b00;RegWEn=1'b1; end
				3'b101: begin   WBsel=2'b00;RegWEn=1'b1; end
			endcase
	7'b0100011:	case(inst[14:12])
				3'b000: begin   WBsel=2'b00;RegWEn=1'b0; end
				3'b001: begin   WBsel=2'b00;RegWEn=1'b0; end
				3'b010: begin   WBsel=2'b00;RegWEn=1'b0; end
				default:;	
			endcase
	7'b1100011: begin  WBsel=2'b00;RegWEn=1'b0; end
	7'b0110111: begin  WBsel=2'b01;RegWEn=1'b1; end
	7'b0010111: begin  WBsel=2'b01;RegWEn=1'b1; end
	7'b1101111: begin  WBsel=2'b10;RegWEn=1'b1; end
	7'b1100111: begin  WBsel=2'b10;RegWEn=1'b1; end
	default:;

	endcase	
	end
endmodule
