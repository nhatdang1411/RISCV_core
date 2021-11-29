`include "processor_specific_macros.h"
`timescale 1ps/1ps
module radixsort_tb;
	parameter PROGRAM_INST = "/home/nhat/Documents/Reference_core/BRISC-V_Processors/software/applications/binaries/radixsort.mem";
	parameter PROGRAM_DATA = "/home/nhat/Documents/Reference_core/BRISC-V_Processors/software/applications/binaries/data_radixsort_new.mem";
	parameter TEST_LENGTH = 2000000;
	parameter TEST_NAME = "RADIX SORT";
	parameter LOG_FILE = "radix_sort_test_results.txt";
	reg clk, rst_BF, rst_out;
	
	CPU #(.PROGRAM_INST(PROGRAM_INST), .PROGRAM_DATA(PROGRAM_DATA)) CPU (.clk(clk), .rst_BF(rst_BF), .rst_out(rst_out));

	reg condition;
	integer log_file,x,misprediction;
	always begin
		clk=0;
		forever #20 clk=~clk;
	end
	always_ff @(posedge clk) begin
		if (rst_BF == 1)
			misprediction = 0;
		else
			if (rst_out)
				misprediction = misprediction + 1;
			else 
				misprediction = misprediction;
	end
	initial begin
		rst_BF = 1 ;
		#60 rst_BF = 0;
	end
	// Display
	initial begin	
	 #TEST_LENGTH

 		log_file = $fopen(LOG_FILE,"a+");
 		if(!log_file) begin
 			$display("Could not open log file... Exiting!");
			$finish();
  		end

		assign condition = (`DATA_MEMORY[378] == 32'd788 )&(`DATA_MEMORY[377] == 32'd564 )&(`DATA_MEMORY[376] == 32'd432 )
		&(`DATA_MEMORY[375] == 32'd200 )&(`DATA_MEMORY[374] == 32'd121 )&(`DATA_MEMORY[373] == 32'd100 )
		&(`DATA_MEMORY[372] == 32'd50 )&(`DATA_MEMORY[371] == 32'd45 )&(`DATA_MEMORY[370] == 32'd23 )
		&(`DATA_MEMORY[369] == 32'd1 );
  		if(condition) begin
    			$display("%s: Test Passed!", TEST_NAME);
    			$fdisplay(log_file, "%s: Test Passed!", TEST_NAME);
			$display(" Number of misprediction in %s : %d instructions ", TEST_NAME, misprediction);
			$fdisplay(log_file," Number of misprediction in %s : %d instructions ", TEST_NAME, misprediction);
			$display("Dumping memory states:");
    			$display("Memory Index, Value");
    			for( x=368; x<379; x=x+1) begin
      				$display("%d: %h", x, `DATA_MEMORY[x]);
      				$fdisplay(log_file, "%d: %h", x, `DATA_MEMORY[x]);
    			end
    			$display("");
    			$fdisplay(log_file, "");
  		end 
		else begin
    			$display("%s: Test Failed!", TEST_NAME);
    			$display("Dumping memory states:");
    			$display("Memory Index, Value");
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
endmodule
