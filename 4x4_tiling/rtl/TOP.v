module TOP #(parameter DATA_WIDTH = 8, WIDTH = 4, HEIGHT = 4, BUFFER_SIZE = 4, M_SIZE = 4, N_SIZE = 4 , K_SIZE = 4) (
	input                  clk                   ,
	input                  rst_n                 ,
	input                  data_valid            ,
	input                  start_compute         ,
	input [DATA_WIDTH-1:0] data_in_A             ,
	input [DATA_WIDTH-1:0] data_in_B             ,
	output wire done,
	output wire read_data
);
	wire [3:0] in_valid_A ;
	wire [3:0] in_valid_B ;	
  wire data_output_valid;

	wire reset_reg                           ;
	wire reset_register = (rst_n & reset_reg);

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
	wire [DATA_WIDTH - 1:0] B_pe30;
	wire [DATA_WIDTH - 1:0] B_pe31;
	wire [DATA_WIDTH - 1:0] B_pe32;
	wire [DATA_WIDTH - 1:0] B_pe33;

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

	wire [15:0] output_00;
	wire [15:0] output_01;
	wire [15:0] output_02;
	wire [15:0] output_03;
	wire [15:0] output_10;
	wire [15:0] output_11;
	wire [15:0] output_12;
	wire [15:0] output_13;
	wire [15:0] output_20;
	wire [15:0] output_21;
	wire [15:0] output_22;
	wire [15:0] output_23;
	wire [15:0] output_30;
	wire [15:0] output_31;
	wire [15:0] output_32;
	wire [15:0] output_33;

	assign output_00 = pe00.result;
	assign output_01 = pe01.result;
	assign output_02 = pe02.result;
	assign output_03 = pe03.result;
	assign output_10 = pe10.result;
	assign output_11 = pe11.result;
	assign output_12 = pe12.result;
	assign output_13 = pe13.result;
	assign output_20 = pe20.result;
	assign output_21 = pe21.result;
	assign output_22 = pe22.result;
	assign output_23 = pe23.result;
	assign output_30 = pe30.result;
	assign output_31 = pe31.result;
	assign output_32 = pe32.result;
	assign output_33 = pe33.result;


  wire       in_valid_C    ;
  wire       sel_mux       ;
  wire [2:0] set_reg_wdata ;
  wire set_write_data      ;

	wire set_reg_wdata_1;
	wire set_reg_wdata_2;
	wire set_reg_wdata_3;

	wire set_reg_00,set_reg_01,set_reg_02,set_reg_03,set_reg_10,set_reg_11,set_reg_12,set_reg_13,set_reg_20,set_reg_21,set_reg_22,set_reg_23,set_reg_30,set_reg_31,set_reg_32,set_reg_33;

	assign set_reg_10 = (set_write_data) ? set_reg_wdata[2] : set_reg_path_2; 
	assign set_reg_11 = (set_write_data) ? set_reg_wdata[2] : set_reg_path_3; 
	assign set_reg_12 = (set_write_data) ? set_reg_wdata[2] : set_reg_path_4; 
	assign set_reg_13 = (set_write_data) ? set_reg_wdata[2] : set_reg_path_5; 
	assign set_reg_20 = (set_write_data) ? set_reg_wdata[1] : set_reg_path_3; 
	assign set_reg_21 = (set_write_data) ? set_reg_wdata[1] : set_reg_path_4; 
	assign set_reg_22 = (set_write_data) ? set_reg_wdata[1] : set_reg_path_5; 
	assign set_reg_23 = (set_write_data) ? set_reg_wdata[1] : set_reg_path_6; 
	assign set_reg_30 = (set_write_data) ? set_reg_wdata[0] : set_reg_path_4; 
	assign set_reg_31 = (set_write_data) ? set_reg_wdata[0] : set_reg_path_5; 
	assign set_reg_32 = (set_write_data) ? set_reg_wdata[0] : set_reg_path_6; 
	assign set_reg_33 = (set_write_data) ? set_reg_wdata[0] : set_reg_path_7; 

	wire [15:0] psum_00,psum_01,psum_02, psum_03, psum_10, psum_11, psum_12, psum_13, psum_20, psum_21, psum_22, psum_23, psum_30, psum_31, psum_32, psum_33;

// row 1
PE #(.DATA_WIDTH(DATA_WIDTH)) pe00 (
  .clk        (clk            ) ,
  .rst_n      (reset_registe  ) ,
  .set_reg    (set_reg_path_1 ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (bf_to_pe_5     ) ,
  .left_in    (bf_to_pe_1     ) ,
  .psum_in    (16'b0          ) ,
  .right_out  (R_pe00         ) ,
  .bottom_out (B_pe00         ) ,
  .psum_out   (psum_00        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe01 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_path_2 ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (bf_to_pe_6     ) ,
  .left_in    (R_pe00         ) ,
  .psum_in    (16'b0          ) ,
  .right_out  (R_pe01         ) ,
  .bottom_out (B_pe01         ) ,
  .psum_out   (psum_01        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe02 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_path_3 ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (bf_to_pe_7     ) ,
  .left_in    (R_pe01         ) ,
  .psum_in    (16'b0          ) ,
  .right_out  (R_pe02         ) ,
  .bottom_out (B_pe02         ) ,
  .psum_out   (psum_02        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe03 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_path_4 ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (bf_to_pe_8     ) ,
  .left_in    (R_pe02         ) ,
  .psum_in    (16'b0          ) ,
  .right_out  (               ) ,
  .bottom_out (B_pe03         ) ,
  .psum_out   (psum_03        )
);
// row 2
PE #(.DATA_WIDTH(DATA_WIDTH)) pe10 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_10     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe00         ) ,
  .left_in    (bf_to_pe_2     ) ,
  .psum_in    (psum_00        ) ,
  .right_out  (R_pe10         ) ,
  .bottom_out (B_pe10         ) ,
  .psum_out   (psum_10        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe11 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_11     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe01         ) ,
  .left_in    (R_pe10         ) ,
  .psum_in    (psum_01        ) ,
  .right_out  (R_pe11         ) ,
  .bottom_out (B_pe11         ) ,
  .psum_out   (psum_11        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe12 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_12     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe02         ) ,
  .left_in    (R_pe11         ) ,
  .psum_in    (psum_02        ) ,
  .right_out  (R_pe12         ) ,
  .bottom_out (B_pe12         ) ,
  .psum_out   (psum_12        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe13 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_13     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe03         ) ,
  .left_in    (R_pe12         ) ,
  .psum_in    (psum_03        ) ,
  .right_out  (               ) ,
  .bottom_out (B_pe13         ) ,
  .psum_out   (psum_13        )
);
// row 3
PE #(.DATA_WIDTH(DATA_WIDTH)) pe20 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_20     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe10         ) ,
  .left_in    (bf_to_pe_3     ) ,
  .psum_in    (psum_10        ) ,
  .right_out  (R_pe20         ) ,
  .bottom_out (B_pe20         ) ,
  .psum_out   (psum_20        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe21 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_21     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe11         ) ,
  .left_in    (R_pe20         ) ,
  .psum_in    (psum_11        ) ,
  .right_out  (R_pe21         ) ,
  .bottom_out (B_pe21         ) ,
  .psum_out   (psum_21        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe22 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_22     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe12         ) ,
  .left_in    (R_pe21         ) ,
  .psum_in    (psum_12        ) ,
  .right_out  (R_pe22         ) ,
  .bottom_out (B_pe22         ) ,
  .psum_out   (psum_22        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe23 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_23     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe13         ) ,
  .left_in    (R_pe22         ) ,
  .psum_in    (psum_13        ) ,
  .right_out  (               ) ,
  .bottom_out (B_pe23         ) ,
  .psum_out   (psum_23        )
);
// row 4
PE #(.DATA_WIDTH(DATA_WIDTH)) pe30 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_30     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe20         ) ,
  .left_in    (bf_to_pe_4     ) ,
  .psum_in    (psum_20        ) ,
  .right_out  (R_pe30         ) ,
  .bottom_out (B_pe30         ) ,
  .psum_out   (psum_30        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe31 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_31     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe21         ) ,
  .left_in    (R_pe30         ) ,
  .psum_in    (psum_21        ) ,
  .right_out  (R_pe31         ) ,
  .bottom_out (B_pe31         ) ,
  .psum_out   (psum_31        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe32 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_32     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe22         ) ,
  .left_in    (R_pe31         ) ,
  .psum_in    (psum_22        ) ,
  .right_out  (R_pe32         ) ,
  .bottom_out (B_pe32         ) ,
  .psum_out   (psum_32        )
);
PE #(.DATA_WIDTH(DATA_WIDTH)) pe33 (
  .clk        (clk            ) ,
  .rst_n      (reset_register ) ,
  .set_reg    (set_reg_33     ) ,
  .sel_mux    (sel_mux        ) ,
  .top_in     (B_pe23         ) ,
  .left_in    (R_pe32         ) ,
  .psum_in    (psum_23        ) ,
  .right_out  (               ) ,
  .bottom_out (B_pe33         ) ,
  .psum_out   (psum_33        )
);

// buffer of matrix C
BUFFER #(.DATA_WIDTH(16), .BUFFER_SIZE (4)) buffer_row_C1 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_C    ) ,
	.data_in  ( psum_30       ) ,
	.data_out ( )
);
BUFFER #(.DATA_WIDTH(16), .BUFFER_SIZE (4)) buffer_row_C2 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_C    ) ,
	.data_in  ( psum_31       ) ,
	.data_out ( )
);
BUFFER #(.DATA_WIDTH(16), .BUFFER_SIZE (4)) buffer_row_C3 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_C    ) ,
	.data_in  ( psum_32       ) ,
	.data_out ( )
);
BUFFER #(.DATA_WIDTH(16), .BUFFER_SIZE (4)) buffer_row_C4 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_C    ) ,
	.data_in  ( psum_33       ) ,
	.data_out ( )
);

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

controller #(.ROW_NUM(4), .WIDTH(4), .HEIGHT(4), .M_SIZE(M_SIZE), .N_SIZE(N_SIZE), .K_SIZE(K_SIZE)) control (
	.clk              ( clk              ) ,
	.rst_n            ( rst_n            ) ,
	.data_valid       ( data_valid       ) ,
	.in_valid_A       ( in_valid_A       ) ,
	.in_valid_B       ( in_valid_B       ) ,
	.in_valid_C       ( in_valid_C       ) ,
	.read_data        ( read_data        ) ,
	.set_reg_path_1   ( set_reg_path_1   ) ,
	.set_reg_path_2   ( set_reg_path_2   ) ,
	.set_reg_path_3   ( set_reg_path_3   ) ,
	.set_reg_path_4   ( set_reg_path_4   ) ,
	.set_reg_path_5   ( set_reg_path_5   ) ,
	.set_reg_path_6   ( set_reg_path_6   ) ,
	.set_reg_path_7   ( set_reg_path_7   ) ,
	.done             ( done             ) ,
	.sel_mux          ( sel_mux          ) ,
	.set_reg_wdata    (set_reg_wdata     ) ,
	.set_write_data   (set_write_data    ) ,
	.data_output_valid(data_output_valid ),
	.reset_reg        (reset_reg         )
);
endmodule
