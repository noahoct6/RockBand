// Maps out the falling blocks based on the note register
module	fb_mapper(input logic Clk,						
						 input logic [9:0] DrawX, DrawY,
						 input logic [3:0] [359:0] n_reg,
						 output logic [7:0] is_fb
						 ); 

logic [10:0] b7x = 64; // left most lane
logic [10:0] b6x = 118;
logic [10:0] b5x = 172;
logic [10:0] b4x = 226;
logic [10:0] b3x = 382;
logic [10:0] b2x = 436;
logic [10:0] b1x = 490;
logic [10:0] b0x = 544;	// right most lane
logic [9:0] width = 32;
logic [9:0] height = 18;
logic [10:0] y = 377;

logic [9:0] lower;
assign lower = DrawY-'d17;

logic [10:0] offset;
logic [17:0] possible;
logic [21:0] select;

index 	i_inst(.n_reg(n_reg), .freq(select[21:20]), .to(select[19:10]), .from(select[9:0]), .possible(possible));


always_comb
begin
	unique case (possible)
	18'b000000000000000001	:	offset = 'd17;
	18'b000000000000000010	:	offset = 'd16;
	18'b000000000000000100	:	offset = 'd15;
	18'b000000000000001000	:	offset = 'd14;
	18'b000000000000010000	:	offset = 'd13;
	18'b000000000000100000	:	offset = 'd12;
	18'b000000000001000000	:	offset = 'd11;
	18'b000000000010000000	:	offset = 'd10;
	18'b000000000100000000	:	offset = 'd9;
	18'b000000001000000000	:	offset = 'd8;
	18'b000000010000000000	:	offset = 'd7;
	18'b000000100000000000	:	offset = 'd6;
	18'b000001000000000000	:	offset = 'd5;
	18'b000010000000000000	:	offset = 'd4;
	18'b000100000000000000	:	offset = 'd3;
	18'b001000000000000000	:	offset = 'd2;
	18'b010000000000000000	:	offset = 'd1;
	18'b100000000000000000	:	offset = 'd0;
	endcase
end

logic [7:0] b;
				  
logic [7:0] rect_addr;
logic [31:0]  rect_data;
block_rom	(.addr(rect_addr), .data(rect_data));

always_comb 
begin	: get_y
	if (DrawY > y)
	begin
		b = 8'h00;
		rect_addr = 'd0;
		select = 22'd0;
	end
	else if (DrawX >= b7x && DrawX < (b7x + width))
	begin
		if (DrawY < (height - 'd1))
			select = {2'd3,DrawY,10'd0};//{n_reg[3][DrawY:0],{('d17-DrawY){1'b0}}};
		else
			select = {2'd3,DrawY,lower};//n_reg[3][DrawY:lower];
		case (possible)
		default	: b = 8'h80;
		18'd0		: b = 8'h00;	
		endcase
		case (possible)
		default	: rect_addr = (offset + 'd54);
		18'd0		: rect_addr = 8'd0;
		endcase
	end
	else if (DrawX >= b6x && DrawX < (b6x + width))
	begin
		if (DrawY < (height - 'd1))
			select = {2'd2,DrawY,10'd0};//{n_reg[2][DrawY:0],{('d17-DrawY){1'b0}}};
		else
			select = {2'd2,DrawY,lower};//n_reg[2][DrawY:lower];
		case (possible)
		default	: b = 8'h40;
		18'd0		: b = 8'h00;	
		endcase
		case (possible)
		default	: rect_addr = (offset + 'd54);
		18'd0		: rect_addr = 8'd0;
		endcase
	end
	else if (DrawX >= b5x && DrawX < (b5x + width))
	begin
		if (DrawY < (height - 'd1))
			select = {2'd1,DrawY,10'd0};//{n_reg[1][DrawY:0],{('d17-DrawY){1'b0}}};
		else
			select = {2'd1,DrawY,lower};//n_reg[1][DrawY:lower];
		case (possible)
		default	: b = 8'h20;
		18'd0		: b = 8'h00;	
		endcase
		case (possible)
		default	: rect_addr = (offset + 'd54);
		18'd0		: rect_addr = 8'd0;
		endcase
	end
	else if (DrawX >= b4x && DrawX < (b4x + width))
	begin
		if (DrawY < (height - 'd1))
			select = {2'd0,DrawY,10'd0};//{n_reg[0][DrawY:0],{('d17-DrawY){1'b0}}};
		else
			select = {2'd0,DrawY,lower};//n_reg[0][DrawY:lower];
		case (possible)
		default	: b = 8'h10;
		18'd0		: b = 8'h00;	
		endcase
		case (possible)
		default	: rect_addr = (offset + 'd54);
		18'd0		: rect_addr = 8'd0;
		endcase
	end
	else if (DrawX >= b3x && DrawX < (b3x + width))
	begin
		if (DrawY < (height - 'd1))
			select = {2'd3,DrawY,10'd0};//{n_reg[3][DrawY:0],{('d17-DrawY){1'b0}}};
		else
			select = {2'd3,DrawY,lower};//n_reg[3][DrawY:lower];
		case (possible)
		default	: b = 8'h08;
		18'd0		: b = 8'h00;	
		endcase
		case (possible)
		default	: rect_addr = (offset + 'd54);
		18'd0		: rect_addr = 8'd0;
		endcase
	end
	else if (DrawX >= b2x && DrawX < (b2x + width))
	begin
		if (DrawY < (height - 'd1))
			select = {2'd2,DrawY,10'd0};//{n_reg[2][DrawY:0],{('d17-DrawY){1'b0}}};
		else
			select = {2'd2,DrawY,lower};//n_reg[2][DrawY:lower];
		case (possible)
		default	: b = 8'h04;
		18'd0		: b = 8'h00;	
		endcase
		case (possible)
		default	: rect_addr = (offset + 'd54);
		18'd0		: rect_addr = 8'd0;
		endcase
	end
	else if (DrawX >= b1x && DrawX < (b1x + width))
	begin
		if (DrawY < (height - 'd1))
			select = {2'd1,DrawY,10'd0};//{n_reg[1][DrawY:0],{('d17-DrawY){1'b0}}};
		else
			select = {2'd1,DrawY,lower};//n_reg[1][DrawY:lower];
		case (possible)
		default	: b = 8'h02;
		18'd0		: b = 8'h00;	
		endcase
		case (possible)
		default	: rect_addr = (offset + 'd54);
		18'd0		: rect_addr = 8'd0;
		endcase
	end
	else if (DrawX >= b0x && DrawX < (b0x + width))
	begin
		if (DrawY < (height - 'd1))
			select = {2'd0,DrawY,10'd0};//{n_reg[0][DrawY:0],{('d17-DrawY){1'b0}}};
		else
			select = {2'd0,DrawY,lower};//n_reg[0][DrawY:lower];
		case (possible)
		default	: b = 8'h01;
		18'd0		: b = 8'h00;	
		endcase
		case (possible)
		default	: rect_addr = (offset + 'd54);
		18'd0		: rect_addr = 8'd0;
		endcase
	end
	else
	begin
		b = 8'h00;
		rect_addr = 'd0;
		select = 22'd0;
	end
end

always_comb
begin : get_x
	if     (b[7] && rect_data['d31-(DrawX-b7x)])
		is_fb = 8'b10000000;
	else if(b[6] && rect_data['d31-(DrawX-b6x)])
		is_fb = 8'b01000000;
	else if(b[5] && rect_data['d31-(DrawX-b5x)])
		is_fb = 8'b00100000;
	else if(b[4] && rect_data['d31-(DrawX-b4x)])
		is_fb = 8'b00010000;
	else if(b[3] && rect_data['d31-(DrawX-b3x)])
		is_fb = 8'b00001000;
	else if(b[2] && rect_data['d31-(DrawX-b2x)])
		is_fb = 8'b00000100;
	else if(b[1] && rect_data['d31-(DrawX-b1x)])
		is_fb = 8'b00000010;
	else if(b[0] && rect_data['d31-(DrawX-b0x)])
		is_fb = 8'b00000001;
	else 
		is_fb = 8'b00000000;	
end
						 
endmodule
