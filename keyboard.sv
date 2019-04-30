//-------------------------------------------------------------------------
//      PS2 Keyboard interface                                           --
//      Sai Ma, Marie Liu                                                           --
//      11-13-2014                                                       --
//                                                                       --
//      For use with ECE 385 Final Project                     --
//      ECE Department @ UIUC                                            --
//-------------------------------------------------------------------------
module keyboard(input logic Clk, psClk, psData, reset,
					 output logic [7:0] keyCode, byte1, byte2,
					 output logic press, check);


	logic Q1, Q2, en, enable, shiftout1, shiftout2, Press;
	logic [4:0] Count;
	logic [10:0] Byte_1, Byte_2, B1s, B2s;
	logic [7:0] Data, Typematic_Keycode;
	logic [9:0] counter;
	logic [4:0] parity;
	assign parity = Byte_2[9]+Byte_2[8]+Byte_2[7]+Byte_2[6]+Byte_2[5]+Byte_2[4]+Byte_2[3]+Byte_2[2]+Byte_2[1];
	assign byte1 = Byte_1[9:2];
	assign byte2 = Byte_2[9:2];
	
	
	always_comb
	begin
		if(Count == 5'd11)
			check = 1'b1;
		else 
			check = 1'b0;
	end

	//Counter to sync ps2 clock and system clock
	always@(posedge Clk or posedge reset)
	begin
		if(reset)
		begin
			counter = 10'b0000000000;
			enable = 1'b1;
		end
		else if (counter == 10'b0111111111)//used to be 0111111111
		begin
			counter = 10'b0000000000;
			enable = 1'b1;
		end
		else
		begin
			counter = counter + 1'b1;
			enable = 1'b0;
		end
	end

	//edge detector of PS2 clock
	always@(posedge Clk) //Clk, not always_ff
	begin
		if(enable==1)
		begin
			if((reset)|| (Count==5'b01011))
				Count <= 5'b00000;
		else if(Q1==0 && Q2==1)
			begin
				Count = Count + 1'b1;
				en = 1'b1;
			end
		end
	end

	always@(posedge Clk)
	begin
		if(Count == 5'd11)
		begin
			// An extended key code will be recieved. This driver does not fully support extended key codes, so these are ignored.
			if (Byte_2[9:2] == 8'hE0)
			begin
				// Do nothing
			end

			// An as-of-yet unknown key will be released.
			else if (Byte_2[9:6] == 4'hF)
			begin
				// Do nothing
			end

			// A key has been released.
			else if (Byte_1[9:6] == 4'hF)
			begin
				Data = Byte_2[9:2];
				Press = 1'b0;

				if (Byte_2[9:2] == Typematic_Keycode) //used to be data
					Typematic_Keycode = 8'h00;
			end

			// This make code is a repeat.
			else if (Byte_2[9:2] == Typematic_Keycode)
			begin
				// Do nothing
			end

			// A key has been pressed.
			else if (Byte_1[9:6] != 4'hF)
			begin
				Data = Byte_2[9:2];
				Press = 1'b1;
				Typematic_Keycode = Byte_2[9:2];//Data;
			end
		end
	end

	Dreg Dreg_instance1 ( .*,
								 .Load(enable),
								 .Reset(reset),
								 .D(psClk),
								 .Q(Q1) );
   Dreg Dreg_instance2 ( .*,
								 .Load(enable),
								 .Reset(reset),
								 .D(Q1),
								 .Q(Q2) );

	reg_11 reg_B(
					.Clk(psClk), //psClk
					.Reset(reset),
					.Shift_In(psData),
					.Load(1'b0),
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftout2),
					.Data_Out(Byte_2)
					);

	reg_11 reg_A(
					.Clk(psClk), //psClk
					.Reset(reset),
					.Shift_In(shiftout2),
					.Load(1'b0),
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftout1),
					.Data_Out(Byte_1)
					);

	//sync	 b2[10:0](Clk,Byte_2,B2s);
	//sync   b1[10:0](Clk,Byte_1,B1s);
	sync	ks[7:0](Clk, Data, keyCode);
	sync  ps(Clk, Press, press);
//	assign keyCode=Data;
//	assign press=Press;

endmodule