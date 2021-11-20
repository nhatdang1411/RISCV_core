module dataforwarding(inst2,inst3,inst4,cont1,cont2);
	input wire [31:0] inst2,inst3,inst4;
	output reg [1:0] cont1,cont2;
	reg TH1,TH2,TH3,TH4,TH5,TH6,TH7,TH8,TH9,TH10,TH11,TH12,TH13,TH14,TH15,TH16,TH17;
	reg TT1,TT2,TT3,TT4,TT5,TT6,TT7,TT8,TT9,TT10,TT11,TT12,TT13,TT14,TT15,TT16,TT17,TT18;
	reg CK;
	initial begin
	cont1=2'b00;
	cont2=2'b00;
	end
	always @* begin
		cont1=2'b00;
		cont2=2'b00;
		CK=(inst3[6:0]==7'b0110111)||(inst3[6:0]==7'b0010111)||(inst3[6:0]==7'b1101111)||(inst3[6:0]==7'b1100111); //checking U and J type
		TH1=(inst2[6:0]==7'b0110011) && (inst3[6:0]==7'b0110011) ; //R type and R type
		TH2=(inst2[6:0]==7'b0010011) && (inst3[6:0]==7'b0110011) ; //I type and R type
		TH3=(inst2[6:0]==7'b0010011) && (inst3[6:0]==7'b0010011) ; //I type and I type
		TH4=(inst2[6:0]==7'b0110011) && (inst3[6:0]==7'b0010011) ; //R tyoe and I type
		TH5=(inst2[6:0]==7'b1100011) && (inst3[6:0]==7'b0110011) ; //B type and R type
		TH6=(inst2[6:0]==7'b1100011) && (inst3[6:0]==7'b0010011) ; //B type and I type
		TH7=(inst2[6:0]==7'b0000011) && (inst3[6:0]==7'b0110011) ; //Load I type and R type
		TH8=(inst2[6:0]==7'b0000011) && (inst3[6:0]==7'b0010011) ; // Load I type and I type
		TH11=(inst2[6:0]==7'b0100011) && (inst3[6:0]==7'b0110011) ; //S type and R type
		TH12=(inst2[6:0]==7'b0100011) && (inst3[6:0]==7'b0010011) ; //S type and I type
		TH13= CK && (inst2[6:0]==7'b0110011) ; //R type and U,J type
		TH14= CK && (inst2[6:0]==7'b0010011) ; //I type and U,J type
		TH15= CK && (inst2[6:0]==7'b1100011) ; //B type and U,J type
		TH16= CK && (inst2[6:0]==7'b0000011) ; //Load I type and U,J type
		TH17= CK && (inst2[6:0]==7'b0100011) ; //S type and U,J type

		
		if (TH1||TH4||TH5||TH6||TH11||TH12||TH13||TH15||TH17) begin
			if (inst3[11:7]==inst2[24:20])
				cont2=2'b01;
			if (inst3[11:7]==inst2[19:15])
				cont1=2'b01;
		end
		else if (TH2||TH3||TH7||TH8||TH14||TH16) begin
			if (inst3[11:7]==inst2[19:15])
				cont1=2'b01;
		end
		
		CK=(inst4[6:0]==7'b0110111)||(inst4[6:0]==7'b0010111)||(inst4[6:0]==7'b1101111)||(inst4[6:0]==7'b1100111); //checking U and J type
		TT1=(inst2[6:0]==7'b0110011) && (inst4[6:0]==7'b0110011) ; //R type and R type
		TT2=(inst2[6:0]==7'b0010011) && (inst4[6:0]==7'b0110011) ; //I type and R type
		TT3=(inst2[6:0]==7'b0010011) && (inst4[6:0]==7'b0010011) ; //I type and I type
		TT4=(inst2[6:0]==7'b0110011) && (inst4[6:0]==7'b0010011) ; //R tyoe and I type
		TT5=(inst2[6:0]==7'b1100011) && (inst4[6:0]==7'b0110011) ; //B type and R type
		TT6=(inst2[6:0]==7'b1100011) && (inst4[6:0]==7'b0010011) ; //B type and I type
		TT7=(inst2[6:0]==7'b0000011) && (inst4[6:0]==7'b0110011) ; //Load I type and R type
		TT8=(inst2[6:0]==7'b0000011) && (inst4[6:0]==7'b0010011) ; // Load I type and I type
		TT9=(inst2[6:0]==7'b0110011) && (inst4[6:0]==7'b0000011) ; // R type and Load I type 
		TT10=(inst2[6:0]==7'b0010011) && (inst4[6:0]==7'b0000011) ; //  I type and Load I type 
		TT11=(inst2[6:0]==7'b0100011) && (inst4[6:0]==7'b0110011) ; //S type and R type
		TT12=(inst2[6:0]==7'b0100011) && (inst4[6:0]==7'b0010011) ; //S type and I type
		TT13=(inst2[6:0]==7'b0100011) && (inst4[6:0]==7'b0000011) ; // S type and Load I type
		TT14= CK && (inst2[6:0]==7'b0110011) ; //R type and U,J type
		TT15= CK && (inst2[6:0]==7'b0010011) ; //I type and U,J type
		TT16= CK && (inst2[6:0]==7'b1100011) ; //B type and U,J type
		TT17= CK && (inst2[6:0]==7'b0000011) ; //Load I type and U,J type
		TT18= CK && (inst2[6:0]==7'b0100011) ; //S type and U,J type
		if (TT1||TT4||TT5||TT6||TT9||TT10||TT11||TT12||TT13||TT14||TT16||TT18) begin
			if ((inst4[11:7]==inst2[24:20]) && (cont2==2'b00))
				cont2=2'b10;
			if ((inst4[11:7]==inst2[19:15]) && (cont1==2'b00))
				cont1=2'b10;
		end
		else if (TT2||TT3||TT7||TT8||TT15||TT17) begin
			if ((inst4[11:7]==inst2[19:15])&& (cont1==2'b00))
				cont1=2'b10;
		end
				
	end
endmodule