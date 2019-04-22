module  score_disp(input         Clk,                // 50 MHz clock
											frame_clk,          // The clock indicating a new frame (~60Hz)
						 input [9:0]   DrawX, DrawY,       // Current pixel coordinates
						 input [11:0]   p1_dec, p2_dec,
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

logic [10:0] off5, off4, off3, off2, off1, off0;
   
	
logic [10:0] font_addr;
logic [7:0]  font_data;
font_rom	(.addr(font_addr), .data(font_data));

always_comb
begin
	unique case(p1_dec[11:8])
	4'd0	:	off5 = 'h000;
	4'd1	:	off5 = 'h310;
	4'd2	:	off5 = 'h320;
	4'd3	:	off5 = 'h330;
	4'd4	:	off5 = 'h340;
	4'd5	:	off5 = 'h350;
	4'd6	:	off5 = 'h360;
	4'd7	:	off5 = 'h370;
	4'd8	:	off5 = 'h380;
	4'd9	:	off5 = 'h390;
	endcase
	unique case(p1_dec[7:4])
	4'd0	:	begin
				if(p1_dec[11:4] == 4'h0)
					off4 = 'h000;
				else
					off4 = 'h300;
				end
	4'd1	:	off4 = 'h310;
	4'd2	:	off4 = 'h320;
	4'd3	:	off4 = 'h330;
	4'd4	:	off4 = 'h340;
	4'd5	:	off4 = 'h350;
	4'd6	:	off4 = 'h360;
	4'd7	:	off4 = 'h370;
	4'd8	:	off4 = 'h380;
	4'd9	:	off4 = 'h390;
	endcase
	unique case(p1_dec[3:0])
	4'd0	:	off3 = 'h300;
	4'd1	:	off3 = 'h310;
	4'd2	:	off3 = 'h320;
	4'd3	:	off3 = 'h330;
	4'd4	:	off3 = 'h340;
	4'd5	:	off3 = 'h350;
	4'd6	:	off3 = 'h360;
	4'd7	:	off3 = 'h370;
	4'd8	:	off3 = 'h380;
	4'd9	:	off3 = 'h390;
	endcase
	unique case(p2_dec[11:8])
	4'd0	:	off2 = 'h000;
	4'd1	:	off2 = 'h310;
	4'd2	:	off2 = 'h320;
	4'd3	:	off2 = 'h330;
	4'd4	:	off2 = 'h340;
	4'd5	:	off2 = 'h350;
	4'd6	:	off2 = 'h360;
	4'd7	:	off2 = 'h370;
	4'd8	:	off2 = 'h380;
	4'd9	:	off2 = 'h390;
	endcase
	unique case(p2_dec[7:4])
	4'd0	:	begin
				if(p2_dec[11:4] == 4'h0)
					off1 = 'h000;
				else
					off1 = 'h300;
				end
	4'd1	:	off1 = 'h310;
	4'd2	:	off1 = 'h320;
	4'd3	:	off1 = 'h330;
	4'd4	:	off1 = 'h340;
	4'd5	:	off1 = 'h350;
	4'd6	:	off1 = 'h360;
	4'd7	:	off1 = 'h370;
	4'd8	:	off1 = 'h380;
	4'd9	:	off1 = 'h390;
	endcase
	unique case(p2_dec[3:0])
	4'd0	:	off0 = 'h300;
	4'd1	:	off0 = 'h310;
	4'd2	:	off0 = 'h320;
	4'd3	:	off0 = 'h330;
	4'd4	:	off0 = 'h340;
	4'd5	:	off0 = 'h350;
	4'd6	:	off0 = 'h360;
	4'd7	:	off0 = 'h370;
	4'd8	:	off0 = 'h380;
	4'd9	:	off0 = 'h390;
	endcase
end

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
					font_addr = (DrawY - y + off5); 
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
					font_addr = (DrawY - y + off4); 
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
					font_addr = (DrawY - y + off3);
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
					font_addr = (DrawY - y + off2);
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
					font_addr = (DrawY - y + off1); 
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
					font_addr = (DrawY - y + off0);
				end
	else		
				begin
					p12 = 1'b0;
					p11 = 1'b0;
					p10 = 1'b0;
					p22 = 1'b0;
					p21 = 1'b0;
					p20 = 1'b0;
					font_addr = 'h0;	  
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
