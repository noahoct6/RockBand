module SDRAM_Master(
	// Avalon Clock Input
	input   logic CLK,
	
	// Avalon Reset Input
	input   logic RESET,
	
	// Avalon-MM Master Signals
	output  logic AVL_READ,					// Avalon-MM Read
	output  logic AVL_WRITE,				// Avalon-MM Write
	output  logic AVL_CS,					// Avalon-MM Chip Select
	output  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	output  logic [31:0] AVL_ADDR,		// Avalon-MM Address
	output  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	input   logic AVL_WAITREQ,				// Avalon-MM Wait Request
	input   logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	input	  logic AVL_RDV,					// Avalon-MM Readdatavalid
	
	// Top-Level Signals
	input   logic [31:0] TL_ADDR,
	input	  logic TL_READ,
	input	  logic TL_WRITE,
	input   logic [15:0] TL_WRITEDATA,
	output  logic [31:0] TL_READDATA,
	output  logic TL_RDV
	
	);

assign AVL_BYTE_EN = 4'b1100; 					// we will never overwrite the lower two bytes (the song)
assign AVL_CS = 1'b1; 								// always enable chip
assign AVL_ADDR = TL_ADDR; 						// from controller
assign AVL_READ = TL_READ; 						// from controller
assign AVL_WRITE = TL_WRITE; 						// from controller
assign TL_READDATA = AVL_READDATA; 				// to top level
assign AVL_WRITEDATA = {TL_WRITEDATA,16'd0}; // from top level (for DSP)
assign TL_RDV = AVL_RDV;

	
endmodule
