module	BCD(input logic [9:0] bin,
				 output logic [11:0] dec);

logic [3:0] hun, ten, one;				 
				 
integer i;
always @ (bin)
begin
	hun = 4'h0;
	ten = 4'h0;
	one = 4'h0;
	for(i=9;i>=0;i=i-1)
	begin
		if(hun>=5)
			hun = hun + 3;
		if(ten>=5)
			ten = ten + 3;
		if(one>=5)
			one = one + 3;
			
		hun = hun << 1;
		hun[0] = ten[3];
		ten = ten << 1;
		ten[0] = one[3];
		one = one << 1;
		one[0] = bin[i];
	end
end

assign dec = {hun, ten, one};
				 
endmodule
