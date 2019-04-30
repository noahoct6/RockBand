module reg_8(input logic Clk, Reset, ld,
				 input logic [7:0] Din,
				 output logic [7:0] Dout);
	
	always_ff @ (posedge Clk)
		begin
			if(Reset)
				Dout <= 8'h0;
			else if(ld)
				Dout <= Din;
		end

endmodule
