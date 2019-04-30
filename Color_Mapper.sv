module  color_mapper (input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							 input				  is_num,
							 input        [7:0] is_sr, is_fb,
							 input 		  [7:0] keyTrack,
                      output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                      );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
	 logic [0:639] slice;
	 frame_rom(.addr(DrawY),.data(slice));
	 logic pick;
	 assign pick = slice[DrawX];
	 
    always_comb
    begin
        if (is_num == 1'b1) 
        begin
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
		  else if(is_sr != 8'd0)
		  begin
		  if (is_sr[7] == 1'b1)
		  begin
				if (keyTrack[7] == 1'b1)
					begin
						Red = 8'hff;
						Green = 8'h00;
						Blue = 8'h00;
					end
				else
					begin
						Red = 8'haf;
						Green = 8'h00;
						Blue = 8'h00;
					end
		  end
		  else if (is_sr[6] == 1'b1)
		  begin
				if (keyTrack[6] == 1'b1)
					begin
						Red = 8'hff;
						Green = 8'hff;
						Blue = 8'h00;
					end
				else
					begin
						Red = 8'hf2;
						Green = 8'hf2;
						Blue = 8'h00;
					end
		  end
		  else if (is_sr[5] == 1'b1)
		  begin
				if (keyTrack[5] == 1'b1)
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'hff;
					end
				else
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'hc9;
					end
		  end
		  else if (is_sr[4] == 1'b1)
		  begin
				if (keyTrack[4] == 1'b1)
					begin
						Red = 8'h00;
						Green = 8'hfd;
						Blue = 8'h00;
					end
				else
					begin
						Red = 8'h00;
						Green = 8'hd6;
						Blue = 8'h00;
					end
		  end
		  else if (is_sr[3] == 1'b1)
		  begin
				if (keyTrack[3] == 1'b1)
					begin
						Red = 8'hff;
						Green = 8'h00;
						Blue = 8'h00;
					end
				else
					begin
						Red = 8'haf;
						Green = 8'h00;
						Blue = 8'h00;
					end
		  end
		  else if (is_sr[2] == 1'b1)
		  begin
				if (keyTrack[2] == 1'b1)
					begin
						Red = 8'hff;
						Green = 8'hff;
						Blue = 8'h00;
					end
				else
					begin
						Red = 8'hf2;
						Green = 8'hf2;
						Blue = 8'h00;
					end
		  end
		  else if (is_sr[1] == 1'b1)
		  begin
				if (keyTrack[1] == 1'b1)
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'hff;
					end
				else
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'hc9;
					end
		  end
		  else if (is_sr[0] == 1'b1)
		  begin
				if (keyTrack[0] == 1'b1)
					begin
						Red = 8'h00;
						Green = 8'hfd;
						Blue = 8'h00;
					end
				else
					begin
						Red = 8'h00;
						Green = 8'hd6;
						Blue = 8'h00;
					end
		  end
		  else
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  end
		  else if( is_fb != 8'd0)
		  begin
		  if (is_fb[7] == 1'b1)
		  begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  else if (is_fb[6] == 1'b1)
		  begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
		  end
		  else if (is_fb[5] == 1'b1)
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff;
		  end
		  else if (is_fb[4] == 1'b1)
		  begin
				Red = 8'h00;
				Green = 8'hfd;
				Blue = 8'h00;
		  end
		  
		  else if (is_fb[3] == 1'b1)
		  begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  else if (is_fb[2] == 1'b1)
		  begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
		  end
		  else if (is_fb[1] == 1'b1)
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff;
		  end
		  else if (is_fb[0] == 1'b1)
		  begin
				Red = 8'h00;
				Green = 8'hfd;
				Blue = 8'h00;
		  end
		  else
		  begin
			   Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  end
        else 
        begin
            // Background with nice color gradient, black right now
            Red = {{4{pick}},4'd0};
				Green = {{4{pick}},4'd0};
            //Green = 8'h88 + {1'b0,DrawY[9:3]};
            Blue = {{4{pick}},4'd0};
        end
    end 
    
endmodule
