module	  inc_10(input logic Clk, Reset,
						input logic inc,
						output logic [9:0] Dout);

always_ff @ (posedge Clk)
begin
	if(Reset)
		Dout <= 10'd0;
	else if(inc)
		Dout <= Dout + 'b1;
end
						
endmodule
