`include "processor_specific_macros.h"
`timescale 1ps/1ps
module CPU_tb;
	parameter PROGRAM_INST = "/home/nhat/Documents/Reference_core/BRISC-V_Processors/software/applications/binaries/bubblesort.mem";
	parameter PROGRAM_DATA = "/home/nhat/Documents/Reference_core/BRISC-V_Processors/software/applications/binaries/data_bubblesort_new.mem";
	parameter TEST_LENGTH = 200000;
	parameter TEST_NAME = "BUBBLE SORT";
	parameter LOG_FILE = "basic_test_results.txt";
	reg clk, rst_BF;
	
	reg condition;
	integer log_file,x;
	always begin
		clk=0;
		forever #20 clk=~clk;
	end
	initial begin
		rst_BF = 1 ;
		#60 rst_BF = 0;
	end
	initial begin	
	 #TEST_LENGTH

 		log_file = $fopen(LOG_FILE,"a+");
 		if(!log_file) begin
 			$display("Could not open log file... Exiting!");
			$finish();
  		end

		assign condition = (`DATA_MEMORY[378] == 32'h0000014 )&(`DATA_MEMORY[377] == 32'h0000000a )&(`DATA_MEMORY[376] == 32'h00000008 )
		&(`DATA_MEMORY[375] == 32'h00000005 )&(`DATA_MEMORY[374] == 32'h00000004 )&(`DATA_MEMORY[373] == 32'h0000003 )
		&(`DATA_MEMORY[372] == 32'h00000002 )&(`DATA_MEMORY[371] == 32'h00000002 )&(`DATA_MEMORY[370] == 32'h00000001 )
		&(`DATA_MEMORY[369] == 32'hffffffff );
  		if(condition) begin
    			$display("%s: Test Passed!", TEST_NAME);
    			$fdisplay(log_file, "%s: Test Passed!", TEST_NAME);
  		end 
		else begin
    			$display("%s: Test Failed!", TEST_NAME);
    			$display("Dumping mem states:");
    			$display("Reg Index, Value");
    			for( x=368; x<379; x=x+1) begin
      				$display("%d: %h", x, `DATA_MEMORY[x]);
      				$fdisplay(log_file, "%d: %h", x, `DATA_MEMORY[x]);
    			end
    			$display("");
    			$fdisplay(log_file, "");
  		end // pass/fail check

  		$fclose(log_file);
  		$stop();

	end

//	wire [31:0] pc,pcnew,pcinc,pc0,PC_actual;
//	wire [31:0] inst,wb,rs1,rs2,imm,out,rs1new1,alu,DataR,DataR1,rs1branch,rs2imm;
//	wire [31:0] inst1,inst2,inst3,inst4,pc1,pc2,pc3,pc3new,pc4,rs1new,rs2new,rs2new1,alu1,alu2,PC_predict_pre_IF;
//	wire [2:0]  ImmSel,whb;
//	wire BrUn,BrEq,BrLT,BSel,ASel,MemRW,PCSel,RegWEn,hit,RST,check;
//	wire [1:0]  WBsel,cont1,cont2;
//	wire [3:0]  alusel;
//	wire en;

	//Stage 1
	//Branchbuffer Branchbuffer(.pc(pc),.pc2(pc2),.inst2(inst2),.PCSel(PCSel),.pcnew(alu),.hit(hit),.Addr(Addr),.RST(RST),.clk(clk),.check(check));
	wire [2:1] status;
	wire  [32:1] PC_predict_o;

	wire [2:1] status_update;
	wire [32:1] PC_predict_update;
	wire [32:1] PC_predict_IF;
        wire en_1, en_2;
	wire [32:1] PC_in_1;
	wire temp;
	wire [9:1] total_weights;
	

	wire PCSel, RST, hit, check, stall;
	wire [31:0] PC_actual, alu, inst2, PC_predict_pre_IF, PC_in_old, pc;
	BF_neural_predictor BF_neural_predictor ( .status(status), .PC_predict_o(PC_predict_o), .status_update(status_update), .PC_predict_update(PC_predict_update), .PC_predict_IF(PC_predict_IF), .en_1(en_1), .en_2(en_2), .PC_in_1(PC_in_1), .temp(temp), .total_weights(total_weights),
	.Branch_direction(PCSel), .PC_actual(PC_actual), .PC_alu(alu), .inst(inst2), .PC_in(pc), .rst(rst_BF), .clk(clk), .PC_predict_pre_IF(PC_predict_pre_IF), .rst_pipeline(RST), .hit(hit), .check(check), .PC_in_old(PC_in_old), .stall(stall) );
	
	wire [31:0] pc2;
	mux_pc_actual mux_pc_actual ( .alu(alu), .pc(pc2), .PCsel(PCSel), .PC_actual(PC_actual) );
	
	wire [31:0] pcnew;
	PC PC (.clk(clk), .oldPC(pcnew), .newPC(pc), .stall(stall), .signal(check) );	
	
	wire [31:0] inst;
	IMEM #(.PROGRAM_INST(PROGRAM_INST)) IMEM (.PC(pc), .inst(inst), .clk(clk), .rst(RST), .stall(stall));
	
	wire [31:0] pcinc, pc3;
	AdderPC AdderPC (.oldPC(pc), .newPC(pcinc),.en(en));
	muxpc muxpc ( .alu(alu), .pcold(pc2), .pcinc(pcinc), .PCSel(PCSel), .pcnew(pcnew), .brb(PC_predict_pre_IF), .hit(hit), .check(check));
	
	wire [31:0] pc1,pc0,inst1;
	Regpipelinestage0 Regpipelinestage0(.clk(clk), .newpc(pc), .pc(pc0), .rst(RST), .stall(stall));
	Regpipelinestage1 Regpipelinestage1 (.clk(clk), .newinst(inst), .newpc(pc0), .inst(inst1), .pc(pc1), .rst(RST), .stall(stall));
	Stall_component Stall_component (.inst1(inst), .inst2(inst1), .en(en), .stall(stall));
	wire BrEq, BrLT;
	controlstage1 controlstage1 (.inst(inst2),.BrEq(BrEq),.BrLT(BrLT),.PCSel(PCSel));
	//Stage 2
	
	wire [31:0] inst4, rs1new, rs2new, wb;
	wire  RegWEn;
	Register Register (.clk(clk),.AddrD(inst4[11:7]),.AddrA(inst1[19:15]),.AddrB(inst1[24:20]),.DataD(wb),.rs1(rs1new),.rs2(rs2new),.RegWEn(RegWEn));
	
	wire [31:0]  rs1, rs2;
	Regpipelinestage2 Regpipelinestage2 (.clk(clk),.rst(RST),.newrs1(rs1new),.newrs2(rs2new),.newpc(pc1),.newinst(inst1),.inst(inst2),.pc(pc2),.rs1(rs1),.rs2(rs2),.stall(stall));
	//Stage 3
	
	wire [2:0] ImmSel;
	wire [31:0]  imm;
	ImmGeneration ImmGeneration (.inst(inst2[31:7]),.ImmSel(ImmSel),.imm(imm[31:0]));
	
	wire [31:0] rs1branch, rs2imm;
	wire BrUn;
	BranchComparator BranchComparator (.rs1(rs1branch),.rs2(rs2imm),.BrUn(BrUn),.BrEq(BrEq),.BrLT(BrLT));
	
	wire [1:0] cont1, cont2;
	wire [31:0] alu1;
	muxdtfwrs1 muxdtfwrs1 ( .in1(rs1), .in2(alu1), .in3(wb), .sel(cont1),.out(rs1branch) );
	muxdtfwrs2 muxdtfwrs2 ( .in1(rs2), .in2(alu1), .in3(wb), .sel(cont2),.out(rs2imm) );
	
	wire [31:0] inst3;
	dataforwarding dataforwarding (.inst2(inst2),.inst3(inst3),.inst4(inst4),.cont1(cont1),.cont2(cont2));
	
	wire [31:0] out;
	wire BSel;
	muximm muximm (.imm(imm), .rs2(rs2imm), .bsel(BSel), .out(out));

	wire [31:0] rs1new1;
	wire ASel;
	muxbranch muxbranch (.rs1(rs1branch),.pc(pc2),.ASel(ASel),.rs1new(rs1new1));

	wire [3:0] alusel;
	ALU ALU (.rs1(rs1new1),.rs2(out),.alusel(alusel),.rd(alu));

	wire [31:0] rs2new1;
	Regpipelinestage3 Regpipelinestage3(.clk(clk),.rst(RST),.newalu(alu),.newrs2(rs2imm),.newpc(pc2),.newinst(inst2),.inst(inst3),.pc(pc3),.alu(alu1),.rs2(rs2new1));
	controlstage3 controlstage3 (.inst(inst2),.BrEq(BrEq),.BrLT(BrLT),.BrUn(BrUn),.alusel(alusel),.ImmSel(ImmSel),.BSel(BSel),.ASel(ASel));
	//Stage 4
	wire MemRW;
	wire [31:0] DataR;
	wire [2:0] whb;
	dmem #(.PROGRAM_DATA(PROGRAM_DATA)) dmem (.clk(clk),.Addr(alu1),.MemRW(MemRW),.DataW(rs2new1),.DataR(DataR),.whb(whb));
	
	wire [31:0] pc3new;
	Adderstage4 Adderstage4 (.oldPC(pc3), .newPC(pc3new));

	wire [31:0] DataR1, alu2, pc4;
	Regpipelinestage4 Regpipelinestage4(.clk(clk),.newDataR(DataR),.newinst(inst3),.newalu(alu1),.newpc(pc3new),.pc(pc4),.alu(alu2),.inst(inst4),.DataR(DataR1));
	controlstage4 controlstage4 (.inst(inst3),.MemRW(MemRW),.whb(whb));
	
	//Stage 5
	wire [1:0] WBsel;
	muxdmem muxdmem (.ALU(alu2),.mem(DataR1),.pc(pc4),.WBsel(WBsel),.wb(wb));
	controlstage5 controlstage5 (.inst(inst4),.WBsel(WBsel),.RegWEn(RegWEn));
endmodule
