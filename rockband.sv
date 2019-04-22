module rockband(input logic CLOCK_50,
					 input logic PS2_CLK, PS2_DAT, 
					 input logic [3:0] KEY,
					 input logic [17:0] SW,
					 output logic [6:0]  HEX0,
					 output logic [6:0]  HEX1,
					 output logic [6:0]  HEX2,
					 output logic [6:0]  HEX3,
					 output logic [6:0]  HEX4,
					 output logic [6:0]  HEX5,
					 output logic [6:0]  HEX6,
					 output logic [6:0]  HEX7,
					 output logic [8:0]	LEDG,
					 output logic [7:0]  VGA_R,        //VGA Red
												VGA_G,        //VGA Green
												VGA_B,        //VGA Blue
					 output logic       	VGA_CLK,      //VGA Clock
												VGA_SYNC_N,   //VGA Sync signal
												VGA_BLANK_N,  //VGA Blank signal
												VGA_VS,       //VGA virtical sync signal
												VGA_HS,       //VGA horizontal sync signal
					 output logic [12:0] DRAM_ADDR,
					 output logic [1:0]  DRAM_BA,
					 output logic        DRAM_CAS_N,
					 output logic        DRAM_CKE,
					 output logic        DRAM_CS_N,
					 inout  wire  [31:0] DRAM_DQ,
					 output logic [3:0]  DRAM_DQM,
					 output logic        DRAM_RAS_N,
					 output logic        DRAM_WE_N,
					 output logic        DRAM_CLK,
					 output logic 			AUD_XCK,
					 input  logic			AUD_BCLK,
					 input  logic			AUD_ADCDAT,
					 output logic			AUD_DACDAT,
					 input  logic			AUD_DACLRCK,
					 input  logic			AUD_ADCLRCK,
					 output logic			I2C_SDAT,
					 output logic 			I2C_SCLK
					 );

logic press, Reset, INIT, INIT_FINISH, tl_r, tl_w, tl_rdv, data_over, done, waiting;
logic [31:0] tl_a, tl_wd, tl_rd, sample;
logic [7:0] keyData, keyTrack;
logic [9:0] drawx, drawy, p1_sc, p2_sc;
logic is_num;
logic [7:0] is_sr, is_fb;
logic [11:0] p1_d, p2_d;
logic [7:0] inc2, inc1;
logic ld_sc2, ld_sc1;

logic [3:0][359:0] n_reg;
		
assign Reset = ~KEY[0];
assign LEDG[8] = tl_rdv;

//logic p1_delayed, p1_re, p2_delayed, p2_re;
//always_ff @ (posedge CLOCK_50) begin
//	p1_delayed <= ~KEY[2];
//   p1_re <= (~KEY[2] == 1'b1) && (p1_delayed == 1'b0);
//	p2_delayed <= ~KEY[1];
//   p2_re <= (~KEY[1] == 1'b1) && (p2_delayed == 1'b0);
//end

finalproject_soc 	 fpinst(.clk_clk(CLOCK_50),   				// SDRAM control signals from top level
								  .reset_reset_n(~Reset),
								  .sdram_wire_addr(DRAM_ADDR),		
								  .sdram_wire_ba(DRAM_BA),
								  .sdram_wire_cas_n(DRAM_CAS_N),
								  .sdram_wire_cke(DRAM_CKE),
								  .sdram_wire_cs_n(DRAM_CS_N),
								  .sdram_wire_dq(DRAM_DQ),
								  .sdram_wire_dqm(DRAM_DQM),
								  .sdram_wire_ras_n(DRAM_RAS_N),
								  .sdram_wire_we_n(DRAM_WE_N),
								  .sdram_clk_clk(DRAM_CLK),
								  .outside_data_tl_read(tl_r),
								  .outside_data_tl_addr(tl_a),
								  .outside_data_tl_write(tl_w),
								  .outside_data_tl_writedata(tl_wd),
								  .outside_data_tl_readdata(tl_rd),
								  .outside_data_tl_rdv(tl_rdv)
								  );
								  
game_controller   gc_inst(.Clk(CLOCK_50),
								  .Reset(Reset),
								  .Start(~KEY[3]),
								  .INIT_FINISH(INIT_FINISH),
								  .INIT(INIT),
								  .data_over(data_over),
								  .tl_read(tl_r),
								  .tl_write(tl_w),
								  .tl_addr(tl_a),
								  .sample(sample),
								  .tl_rdv(tl_rdv),
								  .aud_clk(AUD_XCK), // or XCK
								  .done(done),
								  .waiting(waiting)
								  );
		
keyboard 			kb_inst(.Clk(CLOCK_50),			// master clock
								  .psClk(PS2_CLK),		// PS2 clock
								  .psData(PS2_DAT),     // PS2 data signal (1 bit)
								  .reset(Reset),	      // master reset
							     .keyCode(keyData), 	// key that was pressed or released
							     .press(press)    		// press=0 -> released, press=1 -> pressed
							     );
									  
key_reg				kr_inst(.Clk(CLOCK_50),			// master clock
								  .Reset(Reset),			// master reset
								  .press(press),			// whether the key was pressed or released
								  .keyData(keyData),		// most recent key pressed
								  .keyTrack(keyTrack)	// decoder of the which keys are pressed, put keyTrack in
								  );

		
audio_interface  	 	 AUD(.clk(CLOCK_50),    		   	// master clock
							     .Reset(Reset), 						// master reset
								  .AUD_MCLK(AUD_XCK),
								  .AUD_BCLK(AUD_BCLK),
								  .AUD_ADCDAT(AUD_ADCDAT),
								  .AUD_DACDAT(AUD_DACDAT),
								  .AUD_DACLRCK(AUD_DACLRCK),
								  .AUD_ADCLRCK(AUD_ADCLRCK),
							     .LDATA(sample[15:0]),				// data to be written to left channel (16-bit 2's complement)
								  .RDATA(sample[15:0]),				// data to be written to right channel (16-bit 2's complement)
								  .INIT(INIT),							// needs to be raised high to begin driver initialization
								  .INIT_FINISH(INIT_FINISH),		// raised high by driver when initialization is complete
								  .data_over(data_over),			// raised high when a sample has been into DAC, lowered when sample is being read out
							     .I2C_SDAT(I2C_SDAT),
								  .I2C_SCLK(I2C_SCLK)
								  );
								  
reg_32 			sample_reg(.Clk(CLOCK_50),
								  .Reset(done || (data_over)),
								  .LD(tl_rdv),
								  .byte_en(4'b1111),
								  .Din(tl_rd),
								  .Dout(sample)
								  );
								  
vga_clk 			vga_clk_instance(.inclk0(CLOCK_50), .c0(VGA_CLK));

VGA_controller vga_controller_instance(.Clk(CLOCK_50),
													.Reset(Reset_h),
													.VGA_HS(VGA_HS),
													.VGA_VS(VGA_VS),
													.VGA_CLK(VGA_CLK),
													.VGA_SYNC_N(VGA_SYNC_N),
													.VGA_BLANK_N(VGA_BLANK_N),
													.DrawX(drawx),
													.DrawY(drawy)
													);
													
score_disp 		score_inst(.Clk(CLOCK_50),
								  .frame_clk(VGA_VS),
								  .DrawX(drawx),
								  .DrawY(drawy),
								  .is_num(is_num),
								  .p1_dec(p2_d),
								  .p2_dec(p1_d)
								  );
								 
stat_rects        sr_inst(.Clk(CLOCK_50),
								  .DrawX(drawx),
								  .DrawY(drawy),
								  .keyTrack(keyTrack),
								  .is_sr(is_sr)
								  );
								  
fb_mapper		  fbm_inst(.Clk(CLOCK_50),
								  .DrawX(drawx),
								  .DrawY(drawy),
								  .n_reg(n_reg),
								  .is_fb(is_fb)
								  );
								  
color_mapper 		cm_inst(.DrawX(drawx),
								  .DrawY(drawy),
								  .is_num(is_num),
								  .is_sr(is_sr),
								  .is_fb(is_fb),
								  .VGA_R(VGA_R),
								  .VGA_G(VGA_G),
								  .VGA_B(VGA_B),
								  .keyTrack(keyTrack)
								  );
								  
note_reg 			nr_inst(.frame_clk(VGA_VS),
								  .notes({sample[28],sample[24],sample[20],sample[16]}),
								  .n_reg(n_reg)
								  );
		
scorer 		  scorer_inst(.Clk(CLOCK_50), 
								  .keyTrack(keyTrack), 
								  .n_reg(n_reg), 
								  .inc1(inc1), 
								  .inc2(inc2), 
								  .ld_sc1(ld_sc1),
								  .ld_sc2(ld_sc2)
								  );		
		
inc_10			  p1_score(.Clk(CLOCK_50), .ld(ld_sc1), .Reset(Reset), .inc(inc1), .Dout(p1_sc));
inc_10			  p2_score(.Clk(CLOCK_50), .ld(ld_sc2), .Reset(Reset), .inc(inc2), .Dout(p2_sc));

BCD					 p1_dec(.bin(p1_sc), .dec(p1_d));
BCD					 p2_dec(.bin(p2_sc), .dec(p2_d));
		
hexdriver		  HEX_0(.In({3'b0,keyTrack[0]}), .Out(HEX0));
hexdriver		  HEX_1(.In({3'b0,keyTrack[1]}), .Out(HEX1));							
hexdriver		  HEX_2(.In({3'b0,keyTrack[2]}), .Out(HEX2));
hexdriver		  HEX_3(.In({3'b0,keyTrack[3]}), .Out(HEX3));
hexdriver		  HEX_4(.In({3'b0,keyTrack[4]}), .Out(HEX4));
hexdriver		  HEX_5(.In({3'b0,keyTrack[5]}), .Out(HEX5));
hexdriver		  HEX_6(.In({3'b0,keyTrack[6]}), .Out(HEX6));
hexdriver		  HEX_7(.In({3'b0,keyTrack[7]}), .Out(HEX7));	

//hexdriver		  HEX_0(.In(keyData[3:0]), .Out(HEX0));
//hexdriver		  HEX_1(.In(keyData[7:4]), .Out(HEX1));							
//hexdriver		  HEX_2(.In({3'b0,press}), .Out(HEX2));
//hexdriver		  HEX_3(.In(4'b0), .Out(HEX3));
//hexdriver		  HEX_4(.In(4'b0), .Out(HEX4));
//hexdriver		  HEX_5(.In(4'b0), .Out(HEX5));
//hexdriver		  HEX_6(.In(4'b0), .Out(HEX6));
//hexdriver		  HEX_7(.In(4'b0), .Out(HEX7));		

endmodule
