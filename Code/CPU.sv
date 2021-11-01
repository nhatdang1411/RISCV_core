module CPU;
reg clk;
always begin
clk=0;
forever #20 clk=~clk;
end
wire [31:0] pc,pcnew,pcinc,pc0;
wire [31:0] inst,wb,rs1,rs2,imm,out,rs1new1,alu,DataR,DataR1,rs1branch,rs2imm;
wire [31:0] inst1,inst2,inst3,inst4,pc1,pc2,pc3,pc3new,pc4,rs1new,rs2new,rs2new1,alu1,alu2,Addr;
wire [2:0]  ImmSel,whb;
wire BrUn,BrEq,BrLT,BSel,ASel,MemRW,PCSel,RegWEn,hit,RST,check;
wire [1:0]  WBsel,cont1,cont2;
wire [3:0]  alusel;
wire en;
//Stage 1
Branchbuffer Branchbuffer(.pc(pc),.pc2(pc2),.inst2(inst2),.PCSel(PCSel),.pcnew(alu),.hit(hit),.Addr(Addr),.RST(RST),.clk(clk),.check(check));
PC PC (.clk(clk),.oldPC(pcnew),.newPC(pc));	
IMEM IMEM (.PC(pc),.inst(inst),.en(en),.clk(clk),.PCnew(pcnew),.rst(RST));
AdderPC AdderPC (.oldPC(pc), .newPC(pcinc),.en(en));
muxpc muxpc (.alu(alu),.pcold(pcinc),.PCSel(PCSel),.pcnew(pcnew),.brb(Addr),.hit(hit),.check(check));
Regpipelinestage0 Regpipelinestage0(.clk(clk),.newpc(pc),.pc(pc0),.rst(RST));
Regpipelinestage1 Regpipelinestage1 (.clk(clk),.newinst(inst),.newpc(pc0),.inst(inst1),.pc(pc1),.rst(RST));
controlstage1 controlstage1 (.inst(inst2),.BrEq(BrEq),.BrLT(BrLT),.PCSel(PCSel));
//Stage 2
Register Register (.clk(clk),.AddrD(inst4[11:7]),.AddrA(inst1[19:15]),.AddrB(inst1[24:20]),.DataD(wb),.rs1(rs1new),.rs2(rs2new),.RegWEn(RegWEn));
Regpipelinestage2 Regpipelinestage2 (.clk(clk),.rst(RST),.newrs1(rs1new),.newrs2(rs2new),.newpc(pc1),.newinst(inst1),.inst(inst2),.pc(pc2),.rs1(rs1),.rs2(rs2));
//Stage 3
ImmGeneration ImmGeneration (.inst(inst2[31:7]),.ImmSel(ImmSel),.imm(imm[31:0]));
BranchComparator BranchComparator (.rs1(rs1branch),.rs2(rs2imm),.BrUn(BrUn),.BrEq(BrEq),.BrLT(BrLT));
muxdtfwrs1 muxdtfwrs1 ( .in1(rs1), .in2(alu1), .in3(wb), .sel(cont1),.out(rs1branch) );
muxdtfwrs2 muxdtfwrs2 ( .in1(rs2), .in2(alu1), .in3(wb), .sel(cont2),.out(rs2imm) );
dataforwarding dataforwarding (.inst2(inst2),.inst3(inst3),.inst4(inst4),.cont1(cont1),.cont2(cont2));
muximm muximm (.imm(imm), .rs2(rs2imm), .bsel(BSel), .out(out));
muxbranch muxbranch (.rs1(rs1branch),.pc(pc2),.ASel(ASel),.rs1new(rs1new1));
ALU ALU (.rs1(rs1new1),.rs2(out),.alusel(alusel),.rd(alu));
Regpipelinestage3 Regpipelinestage3(.clk(clk),.rst(RST),.newalu(alu),.newrs2(rs2imm),.newpc(pc2),.newinst(inst2),.inst(inst3),.pc(pc3),.alu(alu1),.rs2(rs2new1));
controlstage3 controlstage3 (.inst(inst2),.BrEq(BrEq),.BrLT(BrLT),.BrUn(BrUn),.alusel(alusel),.ImmSel(ImmSel),.BSel(BSel),.ASel(ASel));
//Stage 4
dmem dmem (.clk(clk),.Addr(alu1),.MemRW(MemRW),.DataW(rs2new1),.DataR(DataR),.whb(whb));
Adderstage4 Adderstage4 (.oldPC(pc3), .newPC(pc3new));
Regpipelinestage4 Regpipelinestage4(.clk(clk),.newDataR(DataR),.newinst(inst3),.newalu(alu1),.newpc(pc3new),.pc(pc4),.alu(alu2),.inst(inst4),.DataR(DataR1));
controlstage4 controlstage4 (.inst(inst3),.MemRW(MemRW),.whb(whb));
//Stage 5
muxdmem muxdmem (.ALU(alu2),.mem(DataR1),.pc(pc4),.WBsel(WBsel),.wb(wb));
controlstage5 controlstage5 (.inst(inst4),.WBsel(WBsel),.RegWEn(RegWEn));
endmodule
