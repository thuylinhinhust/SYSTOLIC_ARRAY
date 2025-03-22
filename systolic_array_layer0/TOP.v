module TOP #(
	parameter SYSTOLIC_SIZE = 16 ,
    parameter BUFFER_COUNT  = 16 ,
	parameter BUFFER_SIZE   = 27 ,
	parameter DATA_WIDTH    = 8  ,
	parameter INOUT_WIDTH   = 128
) (
	input        clk          ,
	input        rst_n        ,
	input        start ,


	input        ifm_we_a     , 	
	input        wgt_we_a     ,
	input        ofm_we_b     
);

	wire [BUFFER_COUNT * DATA_WIDTH - 1 : 0] left_in      ;
	wire [BUFFER_COUNT * DATA_WIDTH - 1 : 0] top_in       ;

	wire [INOUT_WIDTH               - 1 : 0] ifm_data_in  ;
    wire [INOUT_WIDTH               - 1 : 0] wgt_data_in  ;  
	wire [INOUT_WIDTH*2             - 1 : 0] ofm_data_out ;

	wire ifm_addr_valid, wgt_addr_valid;

	wire load_ifm, load_wgt;
	wire write_out_en;
	wire ifm_demux, ifm_mux;
	wire ifm_RF_shift_en_1, ifm_RF_shift_en_2;
	wire select_wgt;
	wire [BUFFER_COUNT - 1 : 0] wgt_RF_shift_en;
	wire reset_pe;

	wire [18:0] ifm_addr_a   ;	
	wire [8:0]  wgt_addr_a   ;
	wire [21:0] ofm_addr_b   ;
  
DPRAM #(.ADDR_WIDTH(19), .ADDR_LINE(519168), .DATA_WIDTH(DATA_WIDTH), .INOUT_WIDTH (INOUT_WIDTH)) dpram_ifm (
	.clk    ( clk         ) ,
	.rst_n  ( rst_n       ) ,
	.we_a   ( ifm_we_a    ) ,
	.addr_a ( ifm_addr_a  ) ,
	.addr_valid (ifm_addr_valid) ,
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
	.addr_valid (wgt_addr_valid) ,
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
	.addr_valid (),
	.din_a  (              ) ,
	.dout_a (              ) ,
	.we_b   ( ofm_we_b     ) ,  //write_out_en
	.addr_b ( ofm_addr_b   ) ,
	.din_b  ( ofm_data_out ) ,
	.dout_b (              )	
);

ifm_addr_controller #(.KERNEL_SIZE(3), .IFM_SIZE(416), .IFM_CHANNEL(3), .ADDR_WIDTH(19)) ifm_addr (
	.clk (clk),
	.rst_n (rst_n),
	.load (load_ifm),
	.ifm_addr (ifm_addr_a),
	.addr_valid (ifm_addr_valid)
);

wgt_addr_controller #(.KERNEL_SIZE(3), .NO_CHANNEL(3), .ADDR_WIDTH(9)) wgt_addr (
	.clk (clk),
	.rst_n (rst_n),
	.load (load_wgt),
	.wgt_addr (wgt_addr_a),
	.addr_valid (wgt_addr_valid)
);

ofm_addr_controller #(.SYSTOLIC_SIZE(SYSTOLIC_SIZE), .OFM_SIZE(414), .ADDR_WIDTH(22)) ofm_addr (
	.clk (clk),
	.rst_n (rst_n),
	.write (write_out_en),
	.ofm_addr (ofm_addr_b),
	.addr_valid ()
);

ifm_shift_RF_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(27), .BUFFER_COUNT(BUFFER_COUNT)) ifm_RF (
	.clk      ( clk         ) ,
	.rst_n    ( rst_n       ) ,
	.ifm_demux  (ifm_demux      ) ,
	.ifm_mux  (ifm_mux      ) ,
	.ifm_RF_shift_en_1  (ifm_RF_shift_en_1      ) ,
	.ifm_RF_shift_en_2  (ifm_RF_shift_en_2      ) ,
	.data_in  ( ifm_data_in ) ,
	.data_out ( left_in     )  
);

wgt_shift_RF_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(27), .BUFFER_COUNT(BUFFER_COUNT)) wgt_RF (
	.clk      ( clk         ) ,
	.rst_n    ( rst_n       ) ,
	.select_wgt  (select_wgt      ) ,
	.wgt_RF_shift_en  (wgt_RF_shift_en      ) ,
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

main_controller #(.NO_FILTER(16), .KERNEL_SIZE(3), .NO_CHANNEL(3), .SYSTOLIC_SIZE(SYSTOLIC_SIZE)) main_control (
	.clk (clk),
	.rst_n (rst_n),
	.start (start),
	.load_ifm (load_ifm),
	.load_wgt (load_wgt),
	.ifm_demux (ifm_demux),
	.ifm_mux (ifm_mux),
	.ifm_RF_shift_en_1 (ifm_RF_shift_en_1),
	.ifm_RF_shift_en_2 (ifm_RF_shift_en_2),
	.wgt_RF_shift_en (wgt_RF_shift_en),
	.select_wgt (select_wgt),
	.reset_pe (reset_pe),
	.write_out_en (write_out_en)
);

endmodule
