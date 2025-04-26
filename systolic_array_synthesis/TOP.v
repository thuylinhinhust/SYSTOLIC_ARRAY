module TOP #(parameter DATA_WIDTH = 8, ARRAY_SIZE = 16, BUFFER_SIZE = 9, M_SIZE = 16, N_SIZE = 16, K_SIZE = 27) (
	input                                   clk        ,
	input                                   rst_n      ,
	input                                   data_valid ,
	input [ARRAY_SIZE * DATA_WIDTH - 1 : 0] data_in_A  ,
	input [ARRAY_SIZE * DATA_WIDTH - 1 : 0] data_in_B  ,
	output                                  done       ,
	output                                  read_data
);
	wire [15:0] in_valid_A;
	wire [15:0] in_valid_B;	

	wire [ARRAY_SIZE * DATA_WIDTH - 1 : 0] top_in;
	wire [ARRAY_SIZE * DATA_WIDTH - 1 : 0] left_in;
	wire [ARRAY_SIZE * ARRAY_SIZE * DATA_WIDTH*2 - 1 : 0] result;   

shift_reg_16x16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(BUFFER_SIZE), .BUFFER_COUNT(ARRAY_SIZE)) buffer_ifm (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_A    ) ,
	.data_in  ( data_in_A     ) ,
	.data_out ( left_in       )  
);

shift_reg_16x16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(BUFFER_SIZE), .BUFFER_COUNT(ARRAY_SIZE)) buffer_weight (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_B    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( top_in        )  
);
	
systolic_array_16x16 #(.DATA_WIDTH(DATA_WIDTH), .ARRAY_SIZE(ARRAY_SIZE)) pe_array (
	.clk     (clk)     ,
	.rst_n   (rst_n)   ,
	.top_in  (top_in)  ,
	.left_in (left_in) ,
	.result  (result)
);

controller #(.BUFFER_SIZE(BUFFER_SIZE), .WIDTH(ARRAY_SIZE), .HEIGHT(ARRAY_SIZE), .M_SIZE(M_SIZE), .N_SIZE(N_SIZE), .K_SIZE(K_SIZE)) control (
	.clk            ( clk            ) ,
	.rst_n          ( rst_n          ) ,
	.data_valid     ( data_valid     ) ,
	.in_valid_A     ( in_valid_A     ) ,
	.in_valid_B     ( in_valid_B     ) ,
	.read_data      ( read_data      ) ,
	.done           ( done           )
);

endmodule