// Takes in n_reg and indexes, returning the correct
module 	index(input logic[3:0][359:0] n_reg,
					input logic [1:0] freq,
					input logic [9:0] to, from,
					output logic [17:0] possible
					);
					
logic [10:0] difference;
assign difference = to-from;
					
always_comb
begin
	unique case(difference)
	10'd0		:	possible = {n_reg[freq][from],17'd0};
	10'd1		:	possible = {n_reg[freq][from+:2],16'd0};
	10'd2		:	possible = {n_reg[freq][from+:3],15'd0};
	10'd3		:	possible = {n_reg[freq][from+:4],14'd0};
	10'd4		:	possible = {n_reg[freq][from+:5],13'd0};
	10'd5		:	possible = {n_reg[freq][from+:6],12'd0};
	10'd6		:	possible = {n_reg[freq][from+:7],11'd0};
	10'd7		:	possible = {n_reg[freq][from+:8],10'd0};
	10'd8		:	possible = {n_reg[freq][from+:9],9'd0};
	10'd9		:	possible = {n_reg[freq][from+:10],8'd0};
	10'd10	:	possible = {n_reg[freq][from+:11],7'd0};
	10'd11	:	possible = {n_reg[freq][from+:12],6'd0};
	10'd12	:	possible = {n_reg[freq][from+:13],5'd0};
	10'd13	:	possible = {n_reg[freq][from+:14],4'd0};
	10'd14	:	possible = {n_reg[freq][from+:15],3'd0};
	10'd15	:	possible = {n_reg[freq][from+:16],2'd0};
	10'd16	:	possible = {n_reg[freq][from+:17],1'd0};
	10'd17	:	possible = {n_reg[freq][from+:18]};
	endcase
end

endmodule
