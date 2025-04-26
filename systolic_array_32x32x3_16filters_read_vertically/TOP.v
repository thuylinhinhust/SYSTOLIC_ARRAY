module TOP #(
	parameter SYSTOLIC_SIZE = 16  ,
    parameter BUFFER_COUNT  = 16  ,
	parameter DATA_WIDTH    = 8   ,
	parameter INOUT_WIDTH   = 128 ,
	parameter IFM_SIZE      = 34  ,
	parameter IFM_CHANNEL   = 3   ,
	parameter KERNEL_SIZE   = 3   , 
	parameter NO_FILTER     = 16 
) (
	input  clk   ,
	input  rst_n ,
	input  start ,
	output done 
);

	localparam BUFFER_SIZE      = KERNEL_SIZE * KERNEL_SIZE * IFM_CHANNEL ;
	localparam OFM_SIZE         = IFM_SIZE - KERNEL_SIZE + 1 ;
	localparam OFM_SIZE_POOLING = OFM_SIZE / 2 ;
	localparam IFM_ADDR_LINE    = IFM_SIZE * IFM_SIZE * IFM_CHANNEL ;
	localparam IFM_ADDR_WIDTH   = $clog2 (IFM_ADDR_LINE) ;
	localparam WGT_ADDR_LINE    = KERNEL_SIZE * KERNEL_SIZE * IFM_CHANNEL * NO_FILTER ;
	localparam WGT_ADDR_WIDTH   = $clog2 (WGT_ADDR_LINE) ;
	localparam OFM_ADDR_LINE    = OFM_SIZE_POOLING * OFM_SIZE_POOLING * NO_FILTER ;
	localparam OFM_ADDR_WIDTH   = $clog2 (OFM_ADDR_LINE) ;

	wire [INOUT_WIDTH               - 1 : 0] ifm_data_in  ;
    wire [INOUT_WIDTH               - 1 : 0] wgt_data_in  ;  
	wire [INOUT_WIDTH               - 1 : 0] ofm_data_out ;

	wire [BUFFER_COUNT * DATA_WIDTH - 1 : 0] left_in      ;
	wire [BUFFER_COUNT * DATA_WIDTH - 1 : 0] top_in       ;

	wire ifm_read_en, wgt_read_en;
	wire [4:0] wgt_size, ifm_size, ofm_size;

	wire [IFM_ADDR_WIDTH - 1 : 0] ifm_addr_a ;	
	wire [WGT_ADDR_WIDTH - 1 : 0] wgt_addr_a ;
	wire [OFM_ADDR_WIDTH - 1 : 0] ofm_addr_b ;

	wire load_ifm, load_wgt;
	wire ifm_demux, ifm_mux;
	wire ifm_RF_shift_en_1, ifm_RF_shift_en_2;
	wire [BUFFER_COUNT - 1 : 0] wgt_RF_shift_en;
	wire select_wgt;
	wire reset_pe;
	wire write_out_pe_en;
	wire write_ofm_en;
	wire fifo_rd_clr;
	wire fifo_wr_clr;
	wire fifo_rd_en;
	wire fifo_wr_en;
	wire [6:0] count_filter;

	wire [INOUT_WIDTH*2 - 1 : 0] pe_data_out ;
	wire [INOUT_WIDTH   - 1 : 0] max_pool_1_data_out ;
	wire [INOUT_WIDTH   - 1 : 0] fifo_data_out ;
	wire [INOUT_WIDTH*2 - 1 : 0] max_pool_2_data_in = {  
							max_pool_1_data_out[7 *DATA_WIDTH*2 +: DATA_WIDTH*2], fifo_data_out[7 *DATA_WIDTH*2 +: DATA_WIDTH*2],  
							max_pool_1_data_out[6 *DATA_WIDTH*2 +: DATA_WIDTH*2], fifo_data_out[6 *DATA_WIDTH*2 +: DATA_WIDTH*2],
							max_pool_1_data_out[5 *DATA_WIDTH*2 +: DATA_WIDTH*2], fifo_data_out[5 *DATA_WIDTH*2 +: DATA_WIDTH*2],
							max_pool_1_data_out[4 *DATA_WIDTH*2 +: DATA_WIDTH*2], fifo_data_out[4 *DATA_WIDTH*2 +: DATA_WIDTH*2],
							max_pool_1_data_out[3 *DATA_WIDTH*2 +: DATA_WIDTH*2], fifo_data_out[3 *DATA_WIDTH*2 +: DATA_WIDTH*2],
							max_pool_1_data_out[2 *DATA_WIDTH*2 +: DATA_WIDTH*2], fifo_data_out[2 *DATA_WIDTH*2 +: DATA_WIDTH*2],
							max_pool_1_data_out[1 *DATA_WIDTH*2 +: DATA_WIDTH*2], fifo_data_out[1 *DATA_WIDTH*2 +: DATA_WIDTH*2],
							max_pool_1_data_out[0 *DATA_WIDTH*2 +: DATA_WIDTH*2], fifo_data_out[0 *DATA_WIDTH*2 +: DATA_WIDTH*2]
    };
	
DPRAM #(.ADDR_WIDTH(IFM_ADDR_WIDTH), .ADDR_LINE(IFM_ADDR_LINE), .DATA_WIDTH(DATA_WIDTH), .INOUT_WIDTH(INOUT_WIDTH)) dpram_ifm (
	.clk    ( clk         ) ,
	.size   (             ) ,
	.re_a   ( ifm_read_en ) ,
	.addr_a ( ifm_addr_a  ) ,
	.dout_a ( ifm_data_in ) ,
	.we_b   (             ) ,
	.addr_b (             ) ,
	.din_b  (             ) 
);

DPRAM #(.ADDR_WIDTH(WGT_ADDR_WIDTH), .ADDR_LINE(WGT_ADDR_LINE), .DATA_WIDTH(DATA_WIDTH), .INOUT_WIDTH(INOUT_WIDTH)) dpram_wgt (
	.clk    ( clk         ) ,
	.size   (             ) ,
	.re_a   ( wgt_read_en ) ,
	.addr_a ( wgt_addr_a  ) ,
	.dout_a ( wgt_data_in ) ,
	.we_b   (             ) ,
	.addr_b (             ) ,
	.din_b  (             ) 
);

DPRAM #(.ADDR_WIDTH(OFM_ADDR_WIDTH), .ADDR_LINE(OFM_ADDR_LINE), .DATA_WIDTH(DATA_WIDTH*2), .INOUT_WIDTH(INOUT_WIDTH)) dpram_ofm (
	.clk    ( clk          ) ,
	.size   ( ofm_size     ) ,
	.re_a   (              ) ,
	.addr_a (              ) ,
	.dout_a (              ) ,
	.we_b   ( write_ofm_en ) ,
	.addr_b ( ofm_addr_b   ) ,
	.din_b  ( ofm_data_out ) 
);

ifm_addr_controller #(.SYSTOLIC_SIZE(SYSTOLIC_SIZE), .KERNEL_SIZE(KERNEL_SIZE), .IFM_SIZE(IFM_SIZE), .IFM_CHANNEL(IFM_CHANNEL), .ADDR_WIDTH(IFM_ADDR_WIDTH)) ifm_addr (
	.clk      ( clk         ) ,
	.rst_n    ( rst_n       ) ,
	.load     ( load_ifm    ) ,
	.ifm_addr ( ifm_addr_a  ) ,
	.read_en  ( ifm_read_en ) ,
	.size     ( ifm_size    )
);

wgt_addr_controller #(.SYSTOLIC_SIZE (SYSTOLIC_SIZE), .KERNEL_SIZE(KERNEL_SIZE), .NO_CHANNEL(IFM_CHANNEL), .NO_FILTER(NO_FILTER), .ADDR_WIDTH(WGT_ADDR_WIDTH)) wgt_addr (
	.clk      ( clk         ) ,
	.rst_n    ( rst_n       ) ,
	.load     ( load_wgt    ) ,
	.wgt_addr ( wgt_addr_a  ) ,
	.read_en  ( wgt_read_en ) ,
	.size     ( wgt_size    )
);

ofm_addr_controller #(.SYSTOLIC_SIZE(SYSTOLIC_SIZE), .OFM_SIZE(OFM_SIZE_POOLING), .ADDR_WIDTH(OFM_ADDR_WIDTH)) ofm_addr (
	.clk          ( clk              ) ,
	.rst_n        ( rst_n            ) ,
	.write        ( write_ofm_en     ) ,
	.wgt_size     ( wgt_size         ) ,
	.count_filter ( count_filter     ) ,
	.ofm_addr     ( ofm_addr_b       ) ,
	.ofm_size     ( ofm_size         )
);

ifm_shift_RF_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(BUFFER_SIZE), .BUFFER_COUNT(BUFFER_COUNT)) ifm_RF (
	.clk               ( clk               ) ,
	.rst_n             ( rst_n             ) ,
	.ifm_demux         ( ifm_demux         ) ,
	.ifm_mux           ( ifm_mux           ) ,
	.ifm_RF_shift_en_1 ( ifm_RF_shift_en_1 ) ,
	.ifm_RF_shift_en_2 ( ifm_RF_shift_en_2 ) ,
	.size              ( ifm_size          ) ,
	.data_in           ( ifm_data_in       ) ,
	.data_out          ( left_in           )  
);

wgt_shift_RF_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(BUFFER_SIZE), .BUFFER_COUNT(BUFFER_COUNT)) wgt_RF (
	.clk             ( clk             ) ,
	.rst_n           ( rst_n           ) ,
	.select_wgt      ( select_wgt      ) ,
	.wgt_RF_shift_en ( wgt_RF_shift_en ) ,
	.size            ( wgt_size        ) ,
	.data_in         ( wgt_data_in     ) ,
	.data_out        ( top_in          )  
);

PE_array #(.DATA_WIDTH(DATA_WIDTH), .SYSTOLIC_SIZE(SYSTOLIC_SIZE)) pe_array (
	.clk          ( clk             ) ,
    .rst_n        ( rst_n           ) ,
	.reset_pe     ( reset_pe        ) ,
    .write_out_en ( write_out_pe_en ) ,
    .wgt_in       ( top_in          ) ,
    .ifm_in       ( left_in         ) ,
    .ofm_out      ( pe_data_out     )
);

MAX_POOL_array #(.DATA_WIDTH(DATA_WIDTH), .SYSTOLIC_SIZE(SYSTOLIC_SIZE), .NUM_MODULES(SYSTOLIC_SIZE/2)) max_pool_array_1 (
	.data_in  ( pe_data_out         ) ,
    .data_out ( max_pool_1_data_out ) 
);

MAX_POOL_array #(.DATA_WIDTH(DATA_WIDTH), .SYSTOLIC_SIZE(SYSTOLIC_SIZE), .NUM_MODULES(SYSTOLIC_SIZE/2)) max_pool_array_2 (
	.data_in  ( max_pool_2_data_in ) ,
    .data_out ( ofm_data_out       ) 
);

FIFO_array #(.DATA_WIDTH(DATA_WIDTH), .SYSTOLIC_SIZE(SYSTOLIC_SIZE), .NUM_MODULES(SYSTOLIC_SIZE/2)) fifo_array (
	.clk      ( clk                 ) ,
    .rd_clr   ( fifo_rd_clr         ) ,
	.wr_clr   ( fifo_wr_clr         ) ,
    .rd_en    ( fifo_rd_en          ) ,
    .wr_en    ( fifo_wr_en          ) ,
    .data_in  ( max_pool_1_data_out ) ,
    .data_out ( fifo_data_out       )
);

main_controller #(.NO_FILTER(NO_FILTER), .KERNEL_SIZE(KERNEL_SIZE), .IFM_SIZE(IFM_SIZE), .OFM_SIZE(OFM_SIZE), .IFM_CHANNEL(IFM_CHANNEL), .SYSTOLIC_SIZE(SYSTOLIC_SIZE)) main_control (
	.clk               ( clk               ) ,
	.rst_n             ( rst_n             ) ,
	.start             ( start             ) ,
	.wgt_size          ( wgt_size          ) ,
	.load_ifm          ( load_ifm          ) ,
	.load_wgt          ( load_wgt          ) ,
	.ifm_demux         ( ifm_demux         ) ,
	.ifm_mux           ( ifm_mux           ) ,
	.ifm_RF_shift_en_1 ( ifm_RF_shift_en_1 ) ,
	.ifm_RF_shift_en_2 ( ifm_RF_shift_en_2 ) ,
	.wgt_RF_shift_en   ( wgt_RF_shift_en   ) ,
	.select_wgt        ( select_wgt        ) ,
	.reset_pe          ( reset_pe          ) ,
	.write_out_pe_en   ( write_out_pe_en   ) ,
	.write_ofm_en      ( write_ofm_en      ) ,
	.count_filter      ( count_filter      ) ,
	.fifo_rd_clr       ( fifo_rd_clr       ) ,
	.fifo_wr_clr       ( fifo_wr_clr       ) ,
    .fifo_rd_en        ( fifo_rd_en        ) ,
    .fifo_wr_en        ( fifo_wr_en        ) ,
	.done              ( done              )
);

endmodule