module TOP #(parameter DATA_WIDTH = 8, WIDTH = 4, HEIGHT = 4, BUFFER_SIZE = 4) (
	input clk                   ,
	input rst_n                 ,
	input data_valid            ,
	input start_compute         ,
	input [DATA_WIDTH-1:0] data_in_A,
	input [DATA_WIDTH-1:0] data_in_B,
	output wire done,
	output wire read_data
 // input [3:0] in_valid_A,
 // input [3:0] in_valid_B
);
	wire [3:0] in_valid_A;
	wire [3:0] in_valid_B;	

// mux select matrix A
	wire [DATA_WIDTH - 1:0] data_to_mux_1;
	wire [DATA_WIDTH - 1:0] data_to_mux_2;
	wire [DATA_WIDTH - 1:0] data_to_mux_3;
	wire [DATA_WIDTH - 1:0] data_to_mux_4;

// mux select matrix B 
	wire [DATA_WIDTH - 1:0] data_to_mux_5;
	wire [DATA_WIDTH - 1:0] data_to_mux_6;
	wire [DATA_WIDTH - 1:0] data_to_mux_7;
	wire [DATA_WIDTH - 1:0] data_to_mux_8;

// from matrix A
	wire [DATA_WIDTH - 1:0] bf_to_pe_1;
	wire [DATA_WIDTH - 1:0] bf_to_pe_2;
	wire [DATA_WIDTH - 1:0] bf_to_pe_3;
	wire [DATA_WIDTH - 1:0] bf_to_pe_4;

// from matrix B 
	wire [DATA_WIDTH - 1:0] bf_to_pe_5;
	wire [DATA_WIDTH - 1:0] bf_to_pe_6;
	wire [DATA_WIDTH - 1:0] bf_to_pe_7;
	wire [DATA_WIDTH - 1:0] bf_to_pe_8;

	// right connect of each PE
	wire [DATA_WIDTH - 1:0] R_pe00;
	wire [DATA_WIDTH - 1:0] R_pe10;
	wire [DATA_WIDTH - 1:0] R_pe20;
	wire [DATA_WIDTH - 1:0] R_pe30;
	wire [DATA_WIDTH - 1:0] R_pe01;
	wire [DATA_WIDTH - 1:0] R_pe11;
	wire [DATA_WIDTH - 1:0] R_pe21;
	wire [DATA_WIDTH - 1:0] R_pe31;
	wire [DATA_WIDTH - 1:0] R_pe02;
	wire [DATA_WIDTH - 1:0] R_pe12;
	wire [DATA_WIDTH - 1:0] R_pe22;
	wire [DATA_WIDTH - 1:0] R_pe32;

	// right bottom of each PE
	wire [DATA_WIDTH - 1:0] B_pe00;
	wire [DATA_WIDTH - 1:0] B_pe10;
	wire [DATA_WIDTH - 1:0] B_pe20;
	wire [DATA_WIDTH - 1:0] B_pe01;
	wire [DATA_WIDTH - 1:0] B_pe11;
	wire [DATA_WIDTH - 1:0] B_pe21;
	wire [DATA_WIDTH - 1:0] B_pe02;
	wire [DATA_WIDTH - 1:0] B_pe12;
	wire [DATA_WIDTH - 1:0] B_pe22;
	wire [DATA_WIDTH - 1:0] B_pe03;
	wire [DATA_WIDTH - 1:0] B_pe13;
	wire [DATA_WIDTH - 1:0] B_pe23;

	wire in_valid_1;
	wire in_valid_2;
	wire in_valid_3;
	wire in_valid_4;
	wire in_valid_5;
	wire in_valid_6;
	wire in_valid_7;
	wire in_valid_8;
	assign in_valid_1 = in_valid_A[3]; 
	assign in_valid_2 = in_valid_A[2]; 
	assign in_valid_3 = in_valid_A[1]; 
	assign in_valid_4 = in_valid_A[0]; 
	assign in_valid_5 = in_valid_B[3]; 
	assign in_valid_6 = in_valid_B[2]; 
	assign in_valid_7 = in_valid_B[1]; 
	assign in_valid_8 = in_valid_B[0]; 
	wire set_reg_path_1;  
	wire set_reg_path_2;
	wire set_reg_path_3;
	wire set_reg_path_4;
	wire set_reg_path_5;
	wire set_reg_path_6;
	wire set_reg_path_7;



	wire set_reg_00,set_reg_01,set_reg_02,set_reg_03,set_reg_10,set_reg_11,set_reg_12,set_reg_13,set_reg_20,set_reg_21,set_reg_22,set_reg_23,set_reg_30,set_reg_31,set_reg_32,set_reg_33;
	
// buffer of matrix A
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_A1 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_1    ) ,
	.data_in  ( data_in_A     ) ,
	.data_out ( bf_to_pe_1    )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_A2 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_2    ) ,
	.data_in  ( data_in_A     ) ,
	.data_out ( bf_to_pe_2    )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_A3 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_3    ) ,
	.data_in  ( data_in_A     ) ,
	.data_out ( bf_to_pe_3    )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_A4 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_4    ) ,
	.data_in  ( data_in_A     ) ,
	.data_out ( bf_to_pe_4    )
);
// buffer of matrix B
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_B1 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_5    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( bf_to_pe_5    )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_B2 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_6    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( bf_to_pe_6    )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_B3 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_7    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( bf_to_pe_7    )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_B4 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_8    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( bf_to_pe_8    )
);


	// Array of PE, first row
PE #(.DATA_WIDTH(8)) pe00 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( bf_to_pe_5 ) ,
	.set_reg    ( set_reg_path_1 ) ,
	.left_in    ( bf_to_pe_1 ) ,
	.right_out  ( R_pe00     ) ,
	.bottom_out ( B_pe00     ) 
);
PE #(.DATA_WIDTH(8)) pe01 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( bf_to_pe_6 ) ,
	.set_reg    ( set_reg_path_2 ) ,
	.left_in    ( R_pe00     ) ,
	.right_out  ( R_pe01     ) ,
	.bottom_out ( B_pe01     ) 
);
PE #(.DATA_WIDTH(8)) pe02 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( bf_to_pe_7 ) ,
	.set_reg    ( set_reg_path_3 ) ,
	.left_in    ( R_pe01     ) ,
	.right_out  ( R_pe02     ) ,
	.bottom_out ( B_pe02     ) 
);
PE #(.DATA_WIDTH(8)) pe03 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( bf_to_pe_8 ) ,
	.set_reg    ( set_reg_path_4 ) ,
	.left_in    ( R_pe02     ) ,
	.right_out  (            ) ,
	.bottom_out ( B_pe03     ) 
);
	// Array of PE, second row
PE #(.DATA_WIDTH(8)) pe10 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe00     ) ,
	.left_in    ( bf_to_pe_2 ) ,
	.set_reg    ( set_reg_path_2 ) ,
	.right_out  ( R_pe10     ) ,
	.bottom_out ( B_pe10     ) 
);
PE #(.DATA_WIDTH(8)) pe11 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe01     ) ,
	.left_in    ( R_pe10     ) ,
	.set_reg    ( set_reg_path_3 ) ,
	.right_out  ( R_pe11     ) ,
	.bottom_out ( B_pe11     ) 
);
PE #(.DATA_WIDTH(8)) pe12 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe02     ) ,
	.set_reg    ( set_reg_path_4 ) ,
	.left_in    ( R_pe11     ) ,
	.right_out  ( R_pe12     ) ,
	.bottom_out ( B_pe12     ) 
);
PE #(.DATA_WIDTH(8)) pe13 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe03     ) ,
	.set_reg    ( set_reg_path_5 ) ,
	.left_in    ( R_pe12     ) ,
	.right_out  (            ) ,
	.bottom_out ( B_pe13     ) 
);
	// Array of PE, third row
PE #(.DATA_WIDTH(8)) pe20 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe10     ) ,
	.set_reg    ( set_reg_path_3 ) ,
	.left_in    ( bf_to_pe_3 ) ,
	.right_out  ( R_pe20     ) ,
	.bottom_out ( B_pe20     ) 
);
PE #(.DATA_WIDTH(8)) pe21 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe11     ) ,
	.set_reg    ( set_reg_path_4 ) ,
	.left_in    ( R_pe20     ) ,
	.right_out  ( R_pe21     ) ,
	.bottom_out ( B_pe21     ) 
);
PE #(.DATA_WIDTH(8)) pe22 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe12     ) ,
	.set_reg    ( set_reg_path_5 ) ,
	.left_in    ( R_pe21     ) ,
	.right_out  ( R_pe22     ) ,
	.bottom_out ( B_pe22     ) 
);
PE #(.DATA_WIDTH(8)) pe23 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe13     ) ,
	.set_reg    ( set_reg_path_6 ) ,
	.left_in    ( R_pe22     ) ,
	.right_out  (            ) ,
	.bottom_out ( B_pe23     ) 
);
	// Array of PE, four row
PE #(.DATA_WIDTH(8)) pe30 (
	.clk        ( clk            ) ,
	.rst_n      ( rst_n          ) ,
	.top_in     ( B_pe20         ) ,
	.set_reg    ( set_reg_path_4 ) ,
	.left_in    ( bf_to_pe_4     ) ,
	.right_out  ( R_pe30         ) ,
	.bottom_out (                )
);
PE #(.DATA_WIDTH(8)) pe31 (
	.clk        ( clk            ) ,
	.rst_n      ( rst_n          ) ,
	.top_in     ( B_pe21         ) ,
	.set_reg    ( set_reg_path_5 ) ,
	.left_in    ( R_pe30         ) ,
	.right_out  ( R_pe31         ) ,
	.bottom_out (                )
);
PE #(.DATA_WIDTH(8)) pe32 (
	.clk        ( clk            ) ,
	.rst_n      ( rst_n          ) ,
	.top_in     ( B_pe22         ) ,
	.set_reg    ( set_reg_path_6 ) ,
	.left_in    ( R_pe31         ) ,
	.right_out  ( R_pe32         ) ,
	.bottom_out (                )
);
PE #(.DATA_WIDTH(8)) pe33 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe23     ) ,
	.set_reg    ( set_reg_path_7 ) ,
	.left_in    ( R_pe32     ) ,
	.right_out  (            ) ,
	.bottom_out (            ) 
);

controller #(.ROW_NUM(4), .WIDTH(4), .HEIGHT(4)) control (
	.clk        (clk       ),
	.rst_n      (rst_n     ),
	.data_valid (data_valid),
	.in_valid_A (in_valid_A), 
	.in_valid_B (in_valid_B), 
	.read_data  (read_data ),
  .set_reg_path_1(set_reg_path_1),
  .set_reg_path_2(set_reg_path_2),
  .set_reg_path_3(set_reg_path_3),
  .set_reg_path_4(set_reg_path_4),
  .set_reg_path_5(set_reg_path_5),
  .set_reg_path_6(set_reg_path_6),
  .set_reg_path_7(set_reg_path_7),
	.done       (done      )
);
endmodule
