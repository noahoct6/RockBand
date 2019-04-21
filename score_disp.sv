module  score_disp(input         Clk,                // 50 MHz clock
											frame_clk,          // The clock indicating a new frame (~60Hz)
						 input [9:0]   DrawX, DrawY,       // Current pixel coordinates
						 output logic  is_num              // Whether current pixel belongs to ball or background
						 );
					 
logic [10:0] p1_2x = 10;
logic [10:0] p1_1x = 18;
logic [10:0] p1_0x = 26;
logic [10:0] p2_2x = 606;
logic [10:0] p2_1x = 614;
logic [10:0] p2_0x = 622;
logic [10:0] 	  y = 10;
logic p12, p11, p10, p22, p21, p20;
   
	
logic [10:0] font_addr;
logic [7:0]  font_data;
font_rom	(.addr(font_addr), .data(font_data));

// For test -> Player 1: 161, Player 2:20 
always_comb
begin	:	Drawing
	if		  (DrawX >= p1_2x && DrawX < (p1_2x + 'd8) && 
			   DrawY >= y		&& DrawY < (y + 'd16))
				begin
					p12 = 1'b1;
					p11 = 1'b0;
					p10 = 1'b0;
					p22 = 1'b0;
					p21 = 1'b0;
					p20 = 1'b0;
					font_addr = (DrawY - y + 'h310); // "1"
				end
	else if (DrawX >= p1_1x && DrawX < (p1_1x + 'd8) && 
			   DrawY >= y		&& DrawY < (y + 'd16))
				begin
					p12 = 1'b0;
					p11 = 1'b1;
					p10 = 1'b0;
					p22 = 1'b0;
					p21 = 1'b0;
					p20 = 1'b0;
					font_addr = (DrawY - y + 'h360); // "6"
				end
	else if (DrawX >= p1_0x && DrawX < (p1_0x + 'd8) && 
			   DrawY >= y		&& DrawY < (y + 'd16))
				begin
					p12 = 1'b0;
					p11 = 1'b0;
					p10 = 1'b1;
					p22 = 1'b0;
					p21 = 1'b0;
					p20 = 1'b0;
					font_addr = (DrawY - y + 'h310); // "1"
				end
	else if (DrawX >= p2_2x && DrawX < (p2_2x + 'd8) && 
			   DrawY >= y		&& DrawY < (y + 'd16))
				begin
					p12 = 1'b0;
					p11 = 1'b0;
					p10 = 1'b0;
					p22 = 1'b1;
					p21 = 1'b0;
					p20 = 1'b0;
					font_addr = (DrawY - y + 'h00); // ""
				end
	else if (DrawX >= p2_1x && DrawX < (p2_1x + 'd8) && 
			   DrawY >= y		&& DrawY < (y + 'd16))
				begin
					p12 = 1'b0;
					p11 = 1'b0;
					p10 = 1'b0;
					p22 = 1'b0;
					p21 = 1'b1;
					p20 = 1'b0;
					font_addr = (DrawY - y + 'h320); // "2"
				end
	else if (DrawX >= p2_0x && DrawX < (p2_0x + 'd8) && 
			   DrawY >= y		&& DrawY < (y + 'd16))
				begin
					p12 = 1'b0;
					p11 = 1'b0;
					p10 = 1'b0;
					p22 = 1'b0;
					p21 = 1'b0;
					p20 = 1'b1;
					font_addr = (DrawY - y + 'h300); // "0"
				end
	else		
				begin
					p12 = 1'b0;
					p11 = 1'b0;
					p10 = 1'b0;
					p22 = 1'b0;
					p21 = 1'b0;
					p20 = 1'b0;
					font_addr = 'h0; // ""	  
				end
end

always_comb
begin
	if(p12 && font_data['h7-(DrawX-p1_2x)])
		is_num = 1'b1;
	else if(p11 && font_data['h7-(DrawX-p1_1x)])
		is_num = 1'b1;
	else if(p10 && font_data['h7-(DrawX-p1_0x)])
		is_num = 1'b1;
	else if(p22 && font_data['h7-(DrawX-p2_2x)])
		is_num = 1'b1;
	else if(p21 && font_data['h7-(DrawX-p2_1x)])
		is_num = 1'b1;
	else if(p20 && font_data['h7-(DrawX-p2_0x)])
		is_num = 1'b1;
	else
		is_num = 1'b0;
end

endmodule
