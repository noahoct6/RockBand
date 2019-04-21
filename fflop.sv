module fflop(input logic Clk, Ld, D, Reset, 
				 output logic Q);
	
	always_ff @ (posedge Clk)
		begin
			if(Ld)
				Q <= D;
			else if(Reset)
				Q <= 1'b0;
			else
				Q <= Q;
		end
		 
endmodule
