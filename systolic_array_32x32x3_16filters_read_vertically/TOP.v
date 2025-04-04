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

	localparam BUFFER_SIZE    = KERNEL_SIZE * KERNEL_SIZE * IFM_CHANNEL ;
	localparam OFM_SIZE       = IFM_SIZE - KERNEL_SIZE + 1 ;
	localparam IFM_ADDR_LINE  = IFM_SIZE * IFM_SIZE * IFM_CHANNEL ;
	localparam IFM_ADDR_WIDTH = $clog2 (IFM_ADDR_LINE) ;
	localparam WGT_ADDR_LINE  = KERNEL_SIZE * KERNEL_SIZE * IFM_CHANNEL * NO_FILTER ;
	localparam WGT_ADDR_WIDTH = $clog2 (WGT_ADDR_LINE) ;
	localparam OFM_ADDR_LINE  = OFM_SIZE * OFM_SIZE * NO_FILTER ;
	localparam OFM_ADDR_WIDTH = $clog2 (OFM_ADDR_LINE) ;


	wire [INOUT_WIDTH               - 1 : 0] ifm_data_out_ram  ;
    wire [INOUT_WIDTH               - 1 : 0] wgt_data_out_ram  ;  
	wire [INOUT_WIDTH*2             - 1 : 0] ofm_data_out ;

	wire [BUFFER_COUNT * DATA_WIDTH - 1 : 0] left_in      ;
	wire [BUFFER_COUNT * DATA_WIDTH - 1 : 0] top_in       ;

	wire ifm_addr_valid, wgt_addr_valid;

	wire [IFM_ADDR_WIDTH - 1 : 0] ifm_addr_a ;	
	wire [WGT_ADDR_WIDTH - 1 : 0] wgt_addr_a ;
	wire [OFM_ADDR_WIDTH - 1 : 0] ofm_addr_b ;

	wire load_ifm, load_wgt;
	wire ifm_demux, ifm_mux;
	wire ifm_RF_shift_en_1, ifm_RF_shift_en_2;
	wire [BUFFER_COUNT - 1 : 0] wgt_RF_shift_en;
	wire select_wgt;
	wire reset_pe;
	wire write_out_en;

	wire [INOUT_WIDTH               - 1 : 0] ifm_data_in = (ifm_addr_valid) ? ifm_data_out_ram : 0 ; 
	wire [INOUT_WIDTH               - 1 : 0] wgt_data_in = (wgt_addr_valid) ? wgt_data_out_ram : 0 ;
	

DPRAM #(.ADDR_WIDTH(IFM_ADDR_WIDTH), .ADDR_LINE(IFM_ADDR_LINE), .DATA_WIDTH(DATA_WIDTH), .INOUT_WIDTH(INOUT_WIDTH)) dpram_ifm (
	.clk        ( clk            ) ,
	.rst_n      ( rst_n          ) ,
	.we_a       ( 1'b0           ) ,
	.addr_a     ( ifm_addr_a     ) ,
	.din_a      (                ) ,
	.dout_a     ( ifm_data_out_ram    ) ,
	.we_b       (                ) ,
	.addr_b     (                ) ,
	.din_b      (                ) ,
	.dout_b     (                )	
);

DPRAM #(.ADDR_WIDTH(WGT_ADDR_WIDTH), .ADDR_LINE(WGT_ADDR_LINE), .DATA_WIDTH(DATA_WIDTH), .INOUT_WIDTH(INOUT_WIDTH)) dpram_wgt (
	.clk        ( clk            ) ,
	.rst_n      ( rst_n          ) ,
	.we_a       ( 1'b0           ) ,
	.addr_a     ( wgt_addr_a     ) ,
	.din_a      (                ) ,
	.dout_a     ( wgt_data_out_ram    ) ,
	.we_b       (                ) ,
	.addr_b     (                ) ,
	.din_b      (                ) ,
	.dout_b     (                )	
);

DPRAM #(.ADDR_WIDTH(OFM_ADDR_WIDTH), .ADDR_LINE(OFM_ADDR_LINE), .DATA_WIDTH(DATA_WIDTH*2), .INOUT_WIDTH(INOUT_WIDTH*2)) dpram_ofm (
	.clk        ( clk          ) ,
	.rst_n      ( rst_n        ) ,
	.we_a       (              ) ,
	.addr_a     (              ) ,
	.din_a      (              ) ,
	.dout_a     (              ) ,
	.we_b       ( write_out_en ) ,
	.addr_b     ( ofm_addr_b   ) ,
	.din_b      ( ofm_data_out ) ,
	.dout_b     (              )	
);

ifm_addr_controller #(.KERNEL_SIZE(KERNEL_SIZE), .IFM_SIZE(IFM_SIZE), .IFM_CHANNEL(IFM_CHANNEL), .ADDR_WIDTH(IFM_ADDR_WIDTH)) ifm_addr (
	.clk        ( clk            ) ,
	.rst_n      ( rst_n          ) ,
	.load       ( load_ifm       ) ,
	.ifm_addr   ( ifm_addr_a     ) ,
	.addr_valid ( ifm_addr_valid )
);

wgt_addr_controller #(.KERNEL_SIZE(KERNEL_SIZE), .NO_CHANNEL(IFM_CHANNEL), .ADDR_WIDTH(WGT_ADDR_WIDTH)) wgt_addr (
	.clk        ( clk            ) ,
	.rst_n      ( rst_n          ) ,
	.load       ( load_wgt       ) ,
	.wgt_addr   ( wgt_addr_a     ) ,
	.addr_valid ( wgt_addr_valid )
);

ofm_addr_controller #(.SYSTOLIC_SIZE(SYSTOLIC_SIZE), .OFM_SIZE(OFM_SIZE), .ADDR_WIDTH(OFM_ADDR_WIDTH)) ofm_addr (
	.clk        ( clk          ) ,
	.rst_n      ( rst_n        ) ,
	.write      ( write_out_en ) ,
	.ofm_addr   ( ofm_addr_b   ) ,
	.addr_valid (              )
);

ifm_shift_RF_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(BUFFER_SIZE), .BUFFER_COUNT(BUFFER_COUNT)) ifm_RF (
	.clk               ( clk               ) ,
	.rst_n             ( rst_n             ) ,
	.ifm_demux         ( ifm_demux         ) ,
	.ifm_mux           ( ifm_mux           ) ,
	.ifm_RF_shift_en_1 ( ifm_RF_shift_en_1 ) ,
	.ifm_RF_shift_en_2 ( ifm_RF_shift_en_2 ) ,
	.data_in           ( ifm_data_in       ) ,
	.data_out          ( left_in           )  
);

wgt_shift_RF_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(BUFFER_SIZE), .BUFFER_COUNT(BUFFER_COUNT)) wgt_RF (
	.clk             ( clk             ) ,
	.rst_n           ( rst_n           ) ,
	.select_wgt      ( select_wgt      ) ,
	.wgt_RF_shift_en ( wgt_RF_shift_en ) ,
	.data_in         ( wgt_data_in     ) ,
	.data_out        ( top_in          )  
);

PE_array #(.DATA_WIDTH(DATA_WIDTH), .SYSTOLIC_SIZE(SYSTOLIC_SIZE)) pe_array (
	.clk          ( clk          ) ,
    .rst_n        ( rst_n        ) ,
	.reset_pe     ( reset_pe     ) ,
    .write_out_en ( write_out_en ) ,
    .wgt_in       ( top_in       ) ,
    .ifm_in       ( left_in      ) ,
    .ofm_out      ( ofm_data_out )
);

main_controller #(.NO_FILTER(NO_FILTER), .KERNEL_SIZE(KERNEL_SIZE), .IFM_SIZE(IFM_SIZE), .OFM_SIZE(OFM_SIZE), .IFM_CHANNEL(IFM_CHANNEL), .SYSTOLIC_SIZE(SYSTOLIC_SIZE)) main_control (
	.clk               ( clk               ) ,
	.rst_n             ( rst_n             ) ,
	.start             ( start             ) ,
	.addr_valid        ( ifm_addr_valid    ) ,
	.load_ifm          ( load_ifm          ) ,
	.load_wgt          ( load_wgt          ) ,
	.ifm_demux         ( ifm_demux         ) ,
	.ifm_mux           ( ifm_mux           ) ,
	.ifm_RF_shift_en_1 ( ifm_RF_shift_en_1 ) ,
	.ifm_RF_shift_en_2 ( ifm_RF_shift_en_2 ) ,
	.wgt_RF_shift_en   ( wgt_RF_shift_en   ) ,
	.select_wgt        ( select_wgt        ) ,
	.reset_pe          ( reset_pe          ) ,
	.write_out_en      ( write_out_en      ) ,
	.done              ( done              )
);

endmodule