module game_controller(input logic Clk, // state machine to controll all aspects of the game
							  input logic Reset,
							  input logic INIT_FINISH,
							  input logic data_over,
							  input logic Start,
							  input logic tl_rdv,
							  output logic INIT,
							  output logic done,
							  output logic waiting,
							  input logic aud_clk,
							  
							  // To/from Avalon Master
							  output logic tl_read,
							  output logic tl_write,
							  output logic [31:0] tl_addr,
							  input  logic [31:0] sample
							  
							  //output logic [31:0] counter,
							  //input  logic [17:0] switches
							  ); 
							  
logic [31:0] song_pointer, song_start;
assign song_start = 32'd0; // set SDRAM memory mapped song address, first sample is length							  

enum logic [4:0] {WAIT, LD_START, INITs, FEED, PLAYQ0, PLAYQ1, FIN} State, Next_state;

logic [31:0] counter;

always_ff @ (posedge aud_clk)
begin
	if (Reset) 
		begin
		State <= WAIT;
		counter <= 32'd0;
		end
	else
		begin
		State <= Next_state;
		if (State == LD_START)
			song_pointer <= song_start;
		else if (State == INITs)
			counter <= sample + 1'b1;
		else if (State == FEED)
			begin
			counter <= counter - 1'b1;
			song_pointer <= song_pointer + 3'd4;
			end
		end
end

always_comb
begin
	
	INIT = 1'b0;
	tl_read = 1'b0;
	tl_write = 1'b0;
	tl_addr = 32'd0;
	done = 1'b0;
	waiting = 1'b0;
	
	Next_state = State;
	
	unique case (State)
		WAIT	:	
			begin
			if (Start)
				Next_state = LD_START;
			end
		LD_START :
			begin
			if(tl_rdv)
				Next_state = INITs;
			end
		INITs :
			begin
			if (INIT_FINISH)
				Next_state = FEED;
			end
		FEED	:
			begin
			if (counter <= 32'd0)
				Next_state = FIN;
			else
				if(tl_rdv)
					Next_state = PLAYQ0;
			end
		PLAYQ0 :
			begin
			if (data_over && tl_rdv)
				Next_state = PLAYQ1;
			end
		PLAYQ1 :
			begin
			if (~data_over && tl_rdv)
				Next_state = FEED;
			end
		FIN	:
			Next_state = WAIT;
	endcase
	
	case (State)
		WAIT	: 
			waiting = 1'b1;
		LD_START	:
			begin
			tl_addr = song_pointer;
			tl_read = 1'b1;
			end
		INITs	:
			begin
			INIT = 1'b1;
			end
		FEED	:
			begin
			tl_addr = song_pointer;
			tl_read = 1'b1;
			end
		PLAYQ0	: 
			begin
			tl_addr = song_pointer;
			tl_read = 1'b1;
			end
		PLAYQ1	: 
			begin
			tl_addr = song_pointer;
			tl_read = 1'b1;
			end
		FIN : 
			done = 1'b1;
			
	endcase
end

endmodule
