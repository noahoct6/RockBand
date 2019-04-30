// A shift register that keeps the upper left corners of the falling blocks.
// Shifts down on frame_clk and synchronizes the frame clock with the 44100 Hz audio clock.
module	note_reg(input logic frame_clk,
						input logic [3:0] notes_in,
						input logic nah,
						output logic [3:0][359:0] n_reg
						);
			
logic n3,n2,n1,n0;
logic [3:0] notes;
assign notes = notes_in & {4{nah}};
			
always_ff @ (posedge frame_clk, posedge notes[3]) //synchronizes two clocks
begin
	if(notes[3])
		n3 <= 1'b1;
	else
		n3 <= 1'b0;
end

always_ff @ (posedge frame_clk, posedge notes[2]) //synchronizes two clocks
begin
	if(notes[2])
		n2 <= 1'b1;
	else
		n2 <= 1'b0;
end

always_ff @ (posedge frame_clk, posedge notes[1]) //synchronizes two clocks
begin
	if(notes[1])
		n1 <= 1'b1;
	else
		n1 <= 1'b0;
end

always_ff @ (posedge frame_clk, posedge notes[0]) //synchronizes two clocks
begin
	if(notes[0])
		n0 <= 1'b1;
	else
		n0 <= 1'b0;
end

// 4x360 shift register triggered on frame_clk posedge
integer i;
always_ff @ (posedge frame_clk)
begin
	for(i=359;i>=0;i=i-1)
	begin
		if(i==0)
			begin
			n_reg[3][0] <= n3;
			n_reg[2][0] <= n2;
			n_reg[1][0] <= n1;
			n_reg[0][0] <= n0;
			end
		else
			begin
			n_reg[3][i] <= n_reg[3][i-1];
			n_reg[2][i] <= n_reg[2][i-1];
			n_reg[1][i] <= n_reg[1][i-1];
			n_reg[0][i] <= n_reg[0][i-1];
			end
	end
end
							 
endmodule
