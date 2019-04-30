//this module is a parallel load 8-bit shift register 

module key_reg(input logic Clk, Reset, press,
				   input logic [7:0] keyData,
				   output logic [7:0] keyTrack
				   );
	
logic [7:0] ld;
logic a,s,d,f,j,k,l,semi;

always_comb
begin
	unique case(keyData)
	8'h4c	:	ld = 8'h01;	// ";" was pressed
	8'h4b :  ld = 8'h02; // "L" was pressed
	8'h42 :  ld = 8'h04; // "K" was pressed
	8'h3b	:	ld = 8'h08;	// "J" was pressed
	8'h2b	:	ld = 8'h10;	// "F" was pressed
	8'h23	:	ld = 8'h20;	// "D" was pressed
	8'h1b	:	ld = 8'h40; // "S" was pressed
	8'h1c	:	ld = 8'h80;	// "A" was pressed
	default : ld = 8'h00;
	endcase
//	if(keyData == 8'h4c | keyData == 8'h66 | keyData == 8'h67 | keyData == 8'h26)
//		ld = 8'h01;
//	else if(keyData == 8'h4b | keyData == 8'h45 | keyData == 8'h65 | keyData == 8'h49 | keyData == 8'ha5)
//		ld = 8'h02;
//	else if(keyData == 8'h42 | keyData == 8'ha1 | keyData == 8'h61 | keyData == 8'h41 | keyData == 8'h43)
//		ld = 8'h04;
//	else if(keyData == 8'h3b | keyData == 8'h39 | keyData == 8'h1d | keyData == 8'h3d)
//		ld = 8'h08;
//	else if(keyData == 8'h2b | keyData == 8'h95 | keyData == 8'h25 | keyData == 8'h35 | keyData == 8'h15)
//		ld = 8'h10;
//	else if(keyData == 8'h23 | keyData == 8'h31 | keyData == 8'h11)
//		ld = 8'h20;
//	else if(keyData == 8'h1b | keyData == 8'h8d)
//		ld = 8'h40;
//	else if(keyData == 8'h1c | keyData == 8'h0e)
//		ld = 8'h80;
//	else
//		ld = 8'h00;
end

fflop		a_ff(.Clk(Clk), .Reset(Reset), .Ld(ld[7]), .D(press), .Q(a));
fflop		s_ff(.Clk(Clk), .Reset(Reset), .Ld(ld[6]), .D(press), .Q(s));
fflop		d_ff(.Clk(Clk), .Reset(Reset), .Ld(ld[5]), .D(press), .Q(d));
fflop		f_ff(.Clk(Clk), .Reset(Reset), .Ld(ld[4]), .D(press), .Q(f));
fflop		j_ff(.Clk(Clk), .Reset(Reset), .Ld(ld[3]), .D(press), .Q(j));
fflop		k_ff(.Clk(Clk), .Reset(Reset), .Ld(ld[2]), .D(press), .Q(k));
fflop		l_ff(.Clk(Clk), .Reset(Reset), .Ld(ld[1]), .D(press), .Q(l));
fflop		semi_ff(.Clk(Clk), .Reset(Reset), .Ld(ld[0]), .D(press), .Q(semi));

assign keyTrack = {a,s,d,f,j,k,l,semi};
	
endmodule
