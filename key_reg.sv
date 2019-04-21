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
