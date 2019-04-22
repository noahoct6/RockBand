module	  inc_10(input logic Clk, Reset, ld,
						input logic [7:0] inc,
						output logic [9:0] Dout);

always_ff @ (posedge Clk)
begin
	if(Reset)
		Dout <= 10'd0;
	else if (ld)
		Dout <= Dout + inc;
end
						
endmodule
