module index_perceptron 
(
	output wire [160:1] index,

	input wire [10:1] PC,
	input wire [160:1] Branch_address_iterative,
	input wire [160:1] Folded_hist_iterative
);
	reg [160:1] Folded_hist_iterative_temp;

	assign Folded_hist_iterative_temp [160:151] = Folded_hist_iterative [160:151];
	for (genvar i=15; i>=1; i=i-1) begin
		assign	Folded_hist_iterative_temp [10*i-9+:10] = Folded_hist_iterative_temp [10*(i+1)-9+:10] ^ Folded_hist_iterative [10*i-9+:10];
	end
	
	
	for (genvar i=1; i<=16; i=i+1) begin
		assign	index [10*i-9+:10] = PC ^ Folded_hist_iterative_temp [10*i-9+:10] ^ Branch_address_iterative [10*i-9+:10];
	end
	
	`ifdef FORMAL
		logic [5:1] j = $anyseq;
		always begin 
			assume (j<=15);
			assume (j>=1);
		end
		always_comb begin
			assert ( Folded_hist_iterative_temp [10*j-9+:10] == Folded_hist_iterative_temp [10*(j+1)-9+:10] ^ Folded_hist_iterative [10*j-9+:10] ); 
		end
		logic [5:1] k = $anyseq;
		always begin
			assume (k<=16);
			assume (k>=1);
		end
		always_comb begin
			assert ( index [10*k-9+:10] == PC ^ Folded_hist_iterative_temp [10*k-9+:10] ^ Branch_address_iterative [10*k-9+:10] );
		end
	`endif	

endmodule

typedef logic [16:1] Branch [48:1];
typedef logic [6:1] Pos [48:1];

module index_perceptron_BF
(
	output reg [768:1] index,

	input wire [16:1] PC,
	input Branch Branch_address_iterative,
	input wire [48:1] Folded_hist_iterative,
	input Pos Pos_iterative
);

	wire [16:1] Folded_hist [48:1];
	wire [48:1] zero;

	assign zero = 48'd0;

	assign Folded_hist[48] = {15'd0,Folded_hist_iterative [48]}; 
	generate
		for (genvar t=47; t>=35; t=t-1) begin
			assign Folded_hist[t] = {14'd0,Folded_hist_iterative [48:t]};
		end	
	endgenerate
	assign Folded_hist[34] = {1'b0,Folded_hist_iterative [48:33]};
	assign Folded_hist[33] = Folded_hist_iterative [48:33];
	assign Folded_hist[32] = Folded_hist_iterative [48:33] ^ {15'd0,Folded_hist_iterative [32]};
	generate
                for (genvar i=31; i>=19; i=i-1) begin
                        assign Folded_hist[i] =Folded_hist_iterative [48:33] ^ {zero[i-1:17],Folded_hist_iterative [32:i]};
                end
        endgenerate
	assign Folded_hist[18] =Folded_hist_iterative [48:33] ^ {1'b0,Folded_hist_iterative [32:16]} ;
	assign Folded_hist[17] =Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ;
 	assign Folded_hist[16] =Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ^ {15'd0,Folded_hist_iterative[16]};
	generate
                for (genvar z=15; z>=3; z=z-1) begin
                       assign Folded_hist[z] =Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ^ {14'd0,Folded_hist_iterative[16:z]};
                end
        endgenerate
	assign Folded_hist[1] =Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ^ Folded_hist_iterative[16:1];
	assign Folded_hist[2] =Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ^ {1'd0,Folded_hist_iterative[16:2]};
	always_comb begin
		for (int m=1; m<=48; m=m+1) begin
			index [16*m-15+:16] = PC ^ Branch_address_iterative [m] ^ Pos_iterative[m] ^ Folded_hist[m];
				
		end			
	end
	`ifdef FORMAL
		logic [6:1] j = $anyseq;
		logic [6:1] j_1;
		always begin
			assume (j<=48) ; 
		       	assume (j>=1) ;
			assume (j_1==j);
		end

		always_comb begin
			if (j==48)
				assert (Folded_hist[j] == {15'd0,Folded_hist_iterative [48]});
			else if ( ( j<=47 ) && (j>=35))
                                assert (Folded_hist[j_1] == {14'd0,Folded_hist_iterative [48:j_1]});
			else if (j==34)
				assert (Folded_hist[j] == {1'b0,Folded_hist_iterative [48:33]});
			else if (j==33)
				assert (Folded_hist[33] == Folded_hist_iterative [48:33]);
			else if (j==32)
				assert (Folded_hist[j] == Folded_hist_iterative [48:33] ^ {15'd0,Folded_hist_iterative [32]});
			else if ( (j>=19) && (j<=31) ) 
				assert (Folded_hist[j] == Folded_hist_iterative [48:33] ^ {zero[j-1:17],Folded_hist_iterative [32:j]});
			else if (j==18)
				assert (Folded_hist[18] == Folded_hist_iterative [48:33] ^ {1'b0,Folded_hist_iterative [32:16]});
			else if (j==17)
				assert (Folded_hist[17] == Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17]);
			else if  (j==16)
				assert (Folded_hist[j] == Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ^ {15'd0,Folded_hist_iterative[16]});
			else if (j==1)
				assert (Folded_hist[j] == Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ^ Folded_hist_iterative[16:1]);
			else if (j==2)
                                assert (Folded_hist[j] == Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ^ {1'd0,Folded_hist_iterative[16:2]});

			for (int j_3 = 3; j_3 <=15; j_3=j_3+1) begin
				assert (Folded_hist[j_3] == Folded_hist_iterative [48:33] ^ Folded_hist_iterative [32:17] ^ {14'd0,Folded_hist_iterative[16:j_3]});
			end
		end
		logic [6:1] k = $anyseq;
		
		always begin
                        assume ( (k<=48) && (k>=1) );
                end

		always_comb begin
			assert ( index [16*k-15+:16] == PC ^ Branch_address_iterative [k] ^ Pos_iterative[k] ^ Folded_hist[k] );
		end

	`endif
endmodule

