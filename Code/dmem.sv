module dmem #(parameter PROGRAM_DATA= "") (clk,Addr,MemRW,DataW,whb,DataR);
	input wire clk;
	input wire [2:0]whb;
	input wire [31:0] Addr;
	input wire MemRW;
	input wire [31:0]DataW;
	output reg [31:0] DataR;
	wire [31:0]num;
	wire[31:0]numinc;
	reg [31:0]MEMO[0:4096];
	integer i;
	initial begin
		DataR<=0;
		for(i=0;i<=4096;i=i+1) begin
			MEMO[i]=0;
		end
		$readmemh(PROGRAM_DATA,MEMO);
	end
	assign num=Addr>>2;
	assign numinc=num+1;
	always @* begin
		if (whb==3'b000) 
			case(Addr[1:0])
			2'b00:DataR={{24{MEMO[num][7]}},MEMO[num][7:0]};
			2'b01:DataR={{24{MEMO[num][15]}},MEMO[num][15:8]};
			2'b10:DataR={{24{MEMO[num][23]}},MEMO[num][23:16]};
			2'b11:DataR={{24{MEMO[num][31]}},MEMO[num][31:24]};
			endcase
		else if (whb==3'b001)
			case(Addr[1:0])
		         2'b00:DataR={{16{MEMO[num][15]}},MEMO[num][15:0]};
			 2'b01:DataR={{16{MEMO[num][23]}},MEMO[num][23:8]};
			 2'b10:DataR={{16{MEMO[num][31]}},MEMO[num][31:16]};
			 2'b11:DataR={{16{MEMO[numinc][7]}},MEMO[numinc][7:0],MEMO[num][31:24]};
			endcase
		else if (whb==3'b010) DataR=MEMO[num];	
		else if (whb==3'b011)
			case(Addr[1:0])
			 2'b00:DataR={24'b0,MEMO[num][7:0]};
			 2'b01:DataR={24'b0,MEMO[num][15:8]};
			 2'b10:DataR={24'b0,MEMO[num][23:16]};
			 2'b11:DataR={24'b0,MEMO[num][31:24]};
			endcase
		else if (whb==3'b100)
			 case(Addr[1:0])
			 2'b00:DataR={16'b0,MEMO[num][15:0]};
			 2'b01:DataR={16'b0,MEMO[num][23:8]};
			 2'b10:DataR={16'b0,MEMO[num][31:16]};
			 2'b11:DataR={16'b0,MEMO[numinc][7:0],MEMO[num][31:24]};
			endcase 
	end
	always @(posedge clk) begin
		if ((MemRW==1'b1)&&(whb==3'd0))
			case(Addr[1:0])
			 2'b00:MEMO[num][7:0]=DataW[7:0];
			 2'b01:MEMO[num][15:8]=DataW[7:0];
			 2'b10:MEMO[num][23:16]=DataW[7:0];
			 2'b11:MEMO[num][31:24]=DataW[7:0];
			endcase
		else if ((MemRW==1'b1)&&(whb==3'd1))
			case(Addr[1:0])
			 2'b00:MEMO[num][15:0]=DataW[15:0];
			 2'b01:MEMO[num][23:8]=DataW[15:0];
			 2'b10:MEMO[num][31:16]=DataW[15:0];
			 2'b11:begin MEMO[num][31:24]=DataW[7:0];MEMO[numinc][7:0]=DataW[15:8]; end				 
			endcase
		else if((MemRW==1'b1)&&(whb==3'd2)) 
			 MEMO[num]=DataW;
	
	end
			
	
endmodule
