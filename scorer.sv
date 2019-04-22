// Chooses score increments for both players
module	scorer(input logic Clk,
					 input logic [7:0] keyTrack,
					 input logic [3:0][359:0] n_reg,
					 output logic [7:0] inc1, inc2,
					 output logic ld_sc1, ld_sc2);

logic [7:0] k7,k6,k5,k4,k3,k2,k1,k0;					 
					 
logic [7:0] delayed, rose;
always_ff @ (posedge Clk) 
begin
	delayed[7] <= keyTrack[7];
   rose[7] <= (keyTrack[7] == 1'b1) && (delayed[7] == 1'b0);
	delayed[6] <= keyTrack[6];
   rose[6] <= (keyTrack[6] == 1'b1) && (delayed[6] == 1'b0);
	delayed[5] <= keyTrack[5];
   rose[5] <= (keyTrack[5] == 1'b1) && (delayed[5] == 1'b0);
	delayed[4] <= keyTrack[4];
   rose[4] <= (keyTrack[4] == 1'b1) && (delayed[4] == 1'b0);
	delayed[3] <= keyTrack[3];
   rose[3] <= (keyTrack[3] == 1'b1) && (delayed[3] == 1'b0);
	delayed[2] <= keyTrack[2];
   rose[2] <= (keyTrack[2] == 1'b1) && (delayed[2] == 1'b0);
	delayed[1] <= keyTrack[1];
   rose[1] <= (keyTrack[1] == 1'b1) && (delayed[1] == 1'b0);
	delayed[0] <= keyTrack[0];
   rose[0] <= (keyTrack[0] == 1'b1) && (delayed[0] == 1'b0);
end	 
		
assign ld_sc1 = rose[3] | rose[2] | rose[1] | rose[0];
assign ld_sc2 = rose[7] | rose[6] | rose[5] | rose[4];

always_comb
begin
	unique case(n_reg[3][359:346])
	default	:	k3 = 8'd0;
	14'b00000000000001	:	k3 = 8'd1;
	14'b00000000000010	:	k3 = 8'd2;
	14'b00000000000100	:	k3 = 8'd3;
	14'b00000000001000	:	k3 = 8'd4;
	14'b00000000010000	:	k3 = 8'd5;
	14'b00000000100000	:	k3 = 8'd6;
	14'b00000001000000	:	k3 = 8'd7;
	14'b00000010000000	:	k3 = 8'd8;
	14'b00000100000000	:	k3 = 8'd9;
	14'b00001000000000	:	k3 = 8'd10;
	14'b00010000000000	:	k3 = 8'd11;
	14'b00100000000000	:	k3 = 8'd12;
	14'b01000000000000	:	k3 = 8'd13;
	14'b10000000000000	:	k3 = 8'd14;
	endcase
	unique case(n_reg[2][359:346])
	default	:	k2 = 8'd0;
	14'b00000000000001	:	k2 = 8'd1;
	14'b00000000000010	:	k2 = 8'd2;
	14'b00000000000100	:	k2 = 8'd3;
	14'b00000000001000	:	k2 = 8'd4;
	14'b00000000010000	:	k2 = 8'd5;
	14'b00000000100000	:	k2 = 8'd6;
	14'b00000001000000	:	k2 = 8'd7;
	14'b00000010000000	:	k2 = 8'd8;
	14'b00000100000000	:	k2 = 8'd9;
	14'b00001000000000	:	k2 = 8'd10;
	14'b00010000000000	:	k2 = 8'd11;
	14'b00100000000000	:	k2 = 8'd12;
	14'b01000000000000	:	k2 = 8'd13;
	14'b10000000000000	:	k2 = 8'd14;
	endcase
	unique case(n_reg[1][359:346])
	default	:	k1 = 8'd0;
	14'b00000000000001	:	k1 = 8'd1;
	14'b00000000000010	:	k1 = 8'd2;
	14'b00000000000100	:	k1 = 8'd3;
	14'b00000000001000	:	k1 = 8'd4;
	14'b00000000010000	:	k1 = 8'd5;
	14'b00000000100000	:	k1 = 8'd6;
	14'b00000001000000	:	k1 = 8'd7;
	14'b00000010000000	:	k1 = 8'd8;
	14'b00000100000000	:	k1 = 8'd9;
	14'b00001000000000	:	k1 = 8'd10;
	14'b00010000000000	:	k1 = 8'd11;
	14'b00100000000000	:	k1 = 8'd12;
	14'b01000000000000	:	k1 = 8'd13;
	14'b10000000000000	:	k1 = 8'd14;
	endcase
	unique case(n_reg[0][359:346])
	default	:	k0 = 8'd0;
	14'b00000000000001	:	k0 = 8'd1;
	14'b00000000000010	:	k0 = 8'd2;
	14'b00000000000100	:	k0 = 8'd3;
	14'b00000000001000	:	k0 = 8'd4;
	14'b00000000010000	:	k0 = 8'd5;
	14'b00000000100000	:	k0 = 8'd6;
	14'b00000001000000	:	k0 = 8'd7;
	14'b00000010000000	:	k0 = 8'd8;
	14'b00000100000000	:	k0 = 8'd9;
	14'b00001000000000	:	k0 = 8'd10;
	14'b00010000000000	:	k0 = 8'd11;
	14'b00100000000000	:	k0 = 8'd12;
	14'b01000000000000	:	k0 = 8'd13;
	14'b10000000000000	:	k0 = 8'd14;
	endcase
end

assign k7 = k3;
assign k6 = k2;
assign k5 = k1;
assign k4 = k0;

assign inc1 = (k3&{8{rose[3]}})+(k2&{8{rose[2]}})+(k1&{8{rose[1]}})+(k0&{8{rose[0]}});
assign inc2 = (k7&{8{rose[7]}})+(k6&{8{rose[6]}})+(k5&{8{rose[5]}})+(k4&{8{rose[4]}});		
					
endmodule
