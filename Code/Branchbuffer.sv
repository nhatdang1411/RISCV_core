module Branchbuffer(pc,pc2,inst2,PCSel,pcnew,hit,Addr,RST,check,clk);
input wire [31:0] pc2,inst2,pcnew,pc;
input wire  PCSel;
input wire clk;
output reg RST,check;
output reg [31:0] Addr;
output reg  hit;
integer i;
reg c,d,m;

reg [1:0]a;
reg [31:0] PC [0:5];
reg [31:0] Address [0:5];
reg counterbit [0:5];
reg validbit[0:5]   ;
wire CK1,CK2,CK3;
reg lru;
assign CK1= (inst2[6:0]==7'b1100011);
assign CK2= (inst2[6:0]==7'b1101111);
assign CK3= (inst2[6:0]==7'b1100111);
initial begin
a=0;
for (i=0;i<6;i=i+1) begin validbit[i]=0; counterbit[i]=0;PC[i]=32'hffffffff;Address[i]=32'hffffffff;end
RST=0;
lru=1;
end
always @(posedge clk) begin
check=0;
a=0;
RST=0;
hit=0;
lru=1;
for (i=0;i<6;i=i+1) begin
	if (validbit[i]==0) lru=0;
end
if (lru==1) begin
for (i=0;i<6;i=i+1) begin
	validbit[i]=0;
end
end
for (i=0;i<6;i=i+1) begin
	if (pc==PC[i]) begin
		Addr=Address[i];
		hit=counterbit[i];
	end
end
if ((CK1==1)||(CK2==1)||(CK3==1))
	begin
		for (i=0;i<6;i=i+1) begin
			if ((PC[i]==pc2)&&(Address[i]==pcnew) && (counterbit[i] ==PCSel)) begin a=2; check=1;end
			if ((PC[i]==pc2)&&((Address[i]!=pcnew) || (counterbit[i] !=PCSel)))begin
								RST=1;
								Address[i]=pcnew;
								counterbit[i]=PCSel;	
								a=3;
								validbit[i]=1;
								Addr=pc2;
								hit=1;
							end
				
			
		end
		if (a==0) begin
			RST=1;
			for (i=0;i<6;i=i+1) begin
				if (a==0) begin
					if (validbit[i]==0) begin
						PC[i]=pc2;
						Address[i]=pcnew;
						counterbit[i]=PCSel;	
						a=1;
						validbit[i]=1;
						Addr=pc2;
						hit=1;
					end
				end
			end
		end
		
	end

end

endmodule
