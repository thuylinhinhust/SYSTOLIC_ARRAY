module TOP #(
	parameter SYSTOLIC_SIZE = 16 ,
    parameter BUFFER_COUNT  = 16 ,
	parameter BUFFER_SIZE   = 27 ,
	parameter DATA_WIDTH    = 8  ,
	parameter INOUT_WIDTH   = 128
) (
	input        clk          ,
	input        rst_n        ,
	input        write_out_en ,
	input        read_en      ,
	input        ifm_we_a     , 	
	input        wgt_we_a     ,
	input        ofm_we_b     ,
	input        reset_pe     ,
	input [18:0] ifm_addr_a   ,	
	input [8:0]  wgt_addr_a   ,
	input [21:0] ofm_addr_b   
);

	wire [BUFFER_COUNT * DATA_WIDTH - 1 : 0] left_in      ;
	wire [BUFFER_COUNT * DATA_WIDTH - 1 : 0] top_in       ;

	wire [INOUT_WIDTH               - 1 : 0] ifm_data_in  ;
    wire [INOUT_WIDTH               - 1 : 0] wgt_data_in  ;  
	wire [INOUT_WIDTH*2             - 1 : 0] ofm_data_out ;
  
DPRAM #(.ADDR_WIDTH(19), .ADDR_LINE(519168), .DATA_WIDTH(DATA_WIDTH), .INOUT_WIDTH (INOUT_WIDTH)) dpram_ifm (
	.clk    ( clk         ) ,
	.rst_n  ( rst_n       ) ,
	.we_a   ( ifm_we_a    ) ,
	.addr_a ( ifm_addr_a  ) ,
	.din_a  (             ) ,
	.dout_a ( ifm_data_in ) ,
	.we_b   (             ) ,
	.addr_b (             ) ,
	.din_b  (             ) ,
	.dout_b (             )	
);

DPRAM #(.ADDR_WIDTH(9), .ADDR_LINE(432), .DATA_WIDTH(DATA_WIDTH), .INOUT_WIDTH (INOUT_WIDTH)) dpram_wgt (
	.clk    ( clk         ) ,
	.rst_n  ( rst_n       ) ,
	.we_a   ( wgt_we_a    ) ,
	.addr_a ( wgt_addr_a  ) ,
	.din_a  (             ) ,
	.dout_a ( wgt_data_in ) ,
	.we_b   (             ) ,
	.addr_b (             ) ,
	.din_b  (             ) ,
	.dout_b (             )	
);

DPRAM #(.ADDR_WIDTH(22), .ADDR_LINE(2768896), .DATA_WIDTH(DATA_WIDTH*2), .INOUT_WIDTH (INOUT_WIDTH*2)) dpram_ofm (
	.clk    ( clk          ) ,
	.rst_n  ( rst_n        ) ,
	.we_a   (              ) ,
	.addr_a (              ) ,
	.din_a  (              ) ,
	.dout_a (              ) ,
	.we_b   ( ofm_we_b     ) ,
	.addr_b ( ofm_addr_b   ) ,
	.din_b  ( ofm_data_out ) ,
	.dout_b (              )	
);

shift_RF_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(27), .BUFFER_COUNT(BUFFER_COUNT)) RF_ifm (
	.clk      ( clk         ) ,
	.rst_n    ( rst_n       ) ,
	.read_en  (read_en      ) ,
	.data_in  ( ifm_data_in ) ,
	.data_out ( left_in     )  
);

shift_RF_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(27), .BUFFER_COUNT(BUFFER_COUNT)) RF_wgt (
	.clk      ( clk         ) ,
	.rst_n    ( rst_n       ) ,
	.read_en  (read_en      ) ,
	.data_in  ( wgt_data_in ) ,
	.data_out ( top_in      )  
);

PE_array #(.DATA_WIDTH(DATA_WIDTH), .SYSTOLIC_SIZE(SYSTOLIC_SIZE)) pe_array (
	.clk          ( clk              ) ,
    .rst_n        ( rst_n            ) ,
	.reset_pe     ( reset_pe         ) ,
    .write_out_en ( write_out_en     ) ,
    .wgt_in       ( top_in           ) ,
    .ifm_in       ( left_in          ) ,
    .ofm_out      ( ofm_data_out     )
);

endmodule
