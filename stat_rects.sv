module 	stat_rects(input logic Clk,
						  input logic [9:0] DrawX, DrawY,
						  input logic [7:0] keyTrack,
						  output logic [7:0] is_sr
						  );
						  
logic [10:0] b7x = 64; // left most rect
logic [10:0] b6x = 118;
logic [10:0] b5x = 172;
logic [10:0] b4x = 226;
logic [10:0] b3x = 382;
logic [10:0] b2x = 436;
logic [10:0] b1x = 490;
logic [10:0] b0x = 544;	// right most rect
logic [10:0] y   = 359; // y displacement, used to be 360

logic b7,b6,b5,b4,b3,b2,b1,b0;
				  
logic [7:0] rect_addr;
logic [31:0]  rect_data;
block_rom	(.addr(rect_addr), .data(rect_data));

logic [10:0] offset7,offset6,offset5,offset4,offset3,offset2,offset1,offset0;
assign offset7 = 'd18 + ({10{keyTrack[7]}} & 'd18);
assign offset6 = 'd18 + ({10{keyTrack[6]}} & 'd18);
assign offset5 = 'd18 + ({10{keyTrack[5]}} & 'd18);
assign offset4 = 'd18 + ({10{keyTrack[4]}} & 'd18);
assign offset3 = 'd18 + ({10{keyTrack[3]}} & 'd18);
assign offset2 = 'd18 + ({10{keyTrack[2]}} & 'd18);
assign offset1 = 'd18 + ({10{keyTrack[1]}} & 'd18);
assign offset0 = 'd18 + ({10{keyTrack[0]}} & 'd18);

always_comb
begin : get_Y
	if		  (DrawX >= b7x && DrawX < (b7x + 'd32) && 
			   DrawY >= y	 && DrawY < (y + 'd18))
				begin
					b7 = 1'b1;
					b6 = 1'b0;
					b5 = 1'b0;
					b4 = 1'b0;
					b3 = 1'b0;
					b2 = 1'b0;
					b1 = 1'b0;
					b0 = 1'b0;
					rect_addr = (DrawY - y + offset7);
				end
	else if (DrawX >= b6x && DrawX < (b6x + 'd32) && 
			   DrawY >= y	 && DrawY < (y + 'd18))
				begin
					b7 = 1'b0;
					b6 = 1'b1;
					b5 = 1'b0;
					b4 = 1'b0;
					b3 = 1'b0;
					b2 = 1'b0;
					b1 = 1'b0;
					b0 = 1'b0;
					rect_addr = (DrawY - y + offset6);
				end
	else if (DrawX >= b5x && DrawX < (b5x + 'd32) && 
			   DrawY >= y	 && DrawY < (y + 'd18))
				begin
					b7 = 1'b0;
					b6 = 1'b0;
					b5 = 1'b1;
					b4 = 1'b0;
					b3 = 1'b0;
					b2 = 1'b0;
					b1 = 1'b0;
					b0 = 1'b0;
					rect_addr = (DrawY - y + offset5);
				end
	else if (DrawX >= b4x && DrawX < (b4x + 'd32) && 
			   DrawY >= y	 && DrawY < (y + 'd18))
				begin
					b7 = 1'b0;
					b6 = 1'b0;
					b5 = 1'b0;
					b4 = 1'b1;
					b3 = 1'b0;
					b2 = 1'b0;
					b1 = 1'b0;
					b0 = 1'b0;
					rect_addr = (DrawY - y + offset4);
				end
	else if (DrawX >= b3x && DrawX < (b3x + 'd32) && 
			   DrawY >= y	 && DrawY < (y + 'd18))
				begin
					b7 = 1'b0;
					b6 = 1'b0;
					b5 = 1'b0;
					b4 = 1'b0;
					b3 = 1'b1;
					b2 = 1'b0;
					b1 = 1'b0;
					b0 = 1'b0;
					rect_addr = (DrawY - y + offset3);
				end
	else if (DrawX >= b2x && DrawX < (b2x + 'd32) && 
			   DrawY >= y	 && DrawY < (y + 'd18))
				begin
					b7 = 1'b0;
					b6 = 1'b0;
					b5 = 1'b0;
					b4 = 1'b0;
					b3 = 1'b0;
					b2 = 1'b1;
					b1 = 1'b0;
					b0 = 1'b0;
					rect_addr = (DrawY - y + offset2);
				end
	else if (DrawX >= b1x && DrawX < (b1x + 'd32) && 
			   DrawY >= y	 && DrawY < (y + 'd18))
				begin
					b7 = 1'b0;
					b6 = 1'b0;
					b5 = 1'b0;
					b4 = 1'b0;
					b3 = 1'b0;
					b2 = 1'b0;
					b1 = 1'b1;
					b0 = 1'b0;
					rect_addr = (DrawY - y + offset1);
				end
	else if (DrawX >= b0x && DrawX < (b0x + 'd32) && 
			   DrawY >= y	 && DrawY < (y + 'd18))
				begin
					b7 = 1'b0;
					b6 = 1'b0;
					b5 = 1'b0;
					b4 = 1'b0;
					b3 = 1'b0;
					b2 = 1'b0;
					b1 = 1'b0;
					b0 = 1'b1;
					rect_addr = (DrawY - y + offset0);
				end
	else 			
				begin
					b7 = 1'b0;
					b6 = 1'b0;
					b5 = 1'b0;
					b4 = 1'b0;
					b3 = 1'b0;
					b2 = 1'b0;
					b1 = 1'b0;
					b0 = 1'b0;
					rect_addr = 'h0;
				end
end

always_comb
begin : get_x
	if     (b7 && rect_data['d31-(DrawX-b7x)])
		is_sr = 8'b10000000;
	else if(b6 && rect_data['d31-(DrawX-b6x)])
		is_sr = 8'b01000000;
	else if(b5 && rect_data['d31-(DrawX-b5x)])
		is_sr = 8'b00100000;
	else if(b4 && rect_data['d31-(DrawX-b4x)])
		is_sr = 8'b00010000;
	else if(b3 && rect_data['d31-(DrawX-b3x)])
		is_sr = 8'b00001000;
	else if(b2 && rect_data['d31-(DrawX-b2x)])
		is_sr = 8'b00000100;
	else if(b1 && rect_data['d31-(DrawX-b1x)])
		is_sr = 8'b00000010;
	else if(b0 && rect_data['d31-(DrawX-b0x)])
		is_sr = 8'b00000001;
	else 
		is_sr = 8'b00000000;	
end

endmodule
