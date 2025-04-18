module TOP #(
	parameter SYSTOLIC_SIZE     = 16      ,
	parameter DATA_WIDTH        = 16      ,
	parameter INOUT_WIDTH       = 256     ,
	parameter IFM_RAM_SIZE      = 705600  ,
	parameter WGT_RAM_SIZE      = 8845488 ,
	parameter OFM_RAM_SIZE      = 692224  ,
	parameter MAX_WGT_FIFO_SIZE = 4608
) (
	input         clk            ,
	input         rst_n          ,
	input         start          ,
	output        done           ,

	//Remove ifm, wgt, ofm ram
	output                                ifm_read_en , 
	output [$clog2(IFM_RAM_SIZE) - 1 : 0] ifm_addr_a  ,
	input  [INOUT_WIDTH          - 1 : 0] ifm_data_in ,

	output                                wgt_read_en , 
	output [$clog2(WGT_RAM_SIZE) - 1 : 0] wgt_addr_a  ,
	input  [INOUT_WIDTH          - 1 : 0] wgt_data_in ,  

	output [4 : 0]                        write_ofm_size   ,
	output                                write_out_ofm_en ,
	output [$clog2(OFM_RAM_SIZE) - 1 : 0] ofm_addr_b       ,
	output [INOUT_WIDTH          - 1 : 0] ofm_data_out     ,

    //Layer config
    input [8 : 0] ifm_size       ,
    input [10: 0] ifm_channel    ,
    input [1 : 0] kernel_size    , 
    input [10: 0] num_filter     ,
    input         maxpool_mode   ,
    input [1 : 0] maxpool_stride ,
	input         upsample_mode 
);

	wire [8 : 0] ofm_size_conv = ifm_size - kernel_size + 1 ;
	wire [8 : 0] ofm_size      = (upsample_mode) ? ofm_size_conv*2 : ((maxpool_mode) ? ((maxpool_stride == 1) ? ofm_size_conv : ofm_size_conv/2) : ofm_size_conv) ;

	wire [INOUT_WIDTH - 1 : 0] left_in ;
	wire [INOUT_WIDTH - 1 : 0] top_in  ;

	wire [4 : 0] read_ifm_size, read_wgt_size ;

	wire load_ifm , load_wgt ;
	wire ifm_demux, ifm_mux  ; 

    wire                         wgt_rd_clr   ;
    wire                         wgt_wr_clr   ;
    wire [SYSTOLIC_SIZE - 1 : 0] wgt_rd_en    ;
    wire                         wgt_wr_en    ;

    wire                         ifm_rd_clr_1 ;
    wire                         ifm_wr_clr_1 ;
    wire [SYSTOLIC_SIZE - 1 : 0] ifm_rd_en_1  ;
    wire                         ifm_wr_en_1  ;
    
    wire                         ifm_rd_clr_2 ;
    wire                         ifm_wr_clr_2 ;
    wire [SYSTOLIC_SIZE - 1 : 0] ifm_rd_en_2  ;
    wire                         ifm_wr_en_2  ;    

	wire maxpool_rd_clr ;
	wire maxpool_wr_clr ;
	wire maxpool_rd_en  ;
	wire maxpool_wr_en  ;

	wire         reset_pe     ;
	wire [6 : 0] count_filter ;

	wire write_out_pe_en                                                            ;
	wire write_out_maxpool_en                                                       ;
	wire write_out_ofm_en = (maxpool_mode) ? write_out_maxpool_en : write_out_pe_en ;

	wire [INOUT_WIDTH   - 1 : 0] pe_data_out        ;
	wire [INOUT_WIDTH   - 1 : 0] maxpool_1_data_out ;
	wire [INOUT_WIDTH   - 1 : 0] fifo_data_out      ;
	wire [INOUT_WIDTH*2 - 1 : 0] maxpool_2_data_in = {
							maxpool_1_data_out[15 * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[15 * DATA_WIDTH +: DATA_WIDTH],   
							maxpool_1_data_out[14 * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[14 * DATA_WIDTH +: DATA_WIDTH],  
							maxpool_1_data_out[13 * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[13 * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[12 * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[12 * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[11 * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[11 * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[10 * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[10 * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[9  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[9  * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[8  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[8  * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[7  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[7  * DATA_WIDTH +: DATA_WIDTH],  
							maxpool_1_data_out[6  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[6  * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[5  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[5  * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[4  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[4  * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[3  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[3  * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[2  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[2  * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[1  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[1  * DATA_WIDTH +: DATA_WIDTH],
							maxpool_1_data_out[0  * DATA_WIDTH +: DATA_WIDTH], fifo_data_out[0  * DATA_WIDTH +: DATA_WIDTH] };
	wire [INOUT_WIDTH - 1 : 0] maxpool_2_data_out ;
	wire [INOUT_WIDTH - 1 : 0] maxpool_2_data_out_stride_2 = 
		{ 128'b0, maxpool_2_data_out[14 * DATA_WIDTH +: DATA_WIDTH], maxpool_2_data_out[12 * DATA_WIDTH +: DATA_WIDTH],
				  maxpool_2_data_out[10 * DATA_WIDTH +: DATA_WIDTH], maxpool_2_data_out[8  * DATA_WIDTH +: DATA_WIDTH],
				  maxpool_2_data_out[6  * DATA_WIDTH +: DATA_WIDTH], maxpool_2_data_out[4  * DATA_WIDTH +: DATA_WIDTH],
			      maxpool_2_data_out[2  * DATA_WIDTH +: DATA_WIDTH], maxpool_2_data_out[0  * DATA_WIDTH +: DATA_WIDTH] };

	wire [INOUT_WIDTH - 1 : 0] ofm_data_out = (maxpool_mode) ? ((maxpool_stride == 1) ? maxpool_2_data_out : maxpool_2_data_out_stride_2) : pe_data_out ; 


ifm_addr_controller #(.SYSTOLIC_SIZE (SYSTOLIC_SIZE), .IFM_RAM_SIZE (IFM_RAM_SIZE)) ifm_addr (
	.clk           ( clk           ) ,
	.rst_n         ( rst_n         ) ,
	.load          ( load_ifm      ) ,
	.ifm_addr      ( ifm_addr_a    ) ,
	.read_en       ( ifm_read_en   ) ,
	.read_ifm_size ( read_ifm_size ) ,
	.ifm_size      ( ifm_size      ) ,
	.ifm_channel   ( ifm_channel   ) , 
	.kernel_size   ( kernel_size   ) , 
	.ofm_size      ( ofm_size_conv )
);

wgt_addr_controller #(.SYSTOLIC_SIZE (SYSTOLIC_SIZE), .WGT_RAM_SIZE (WGT_RAM_SIZE)) wgt_addr (
	.clk           ( clk           ) ,
	.rst_n         ( rst_n         ) ,
	.load          ( load_wgt      ) ,
	.wgt_addr      ( wgt_addr_a    ) ,
	.read_en       ( wgt_read_en   ) ,
	.read_wgt_size ( read_wgt_size ) ,
	.kernel_size   ( kernel_size   ) ,
	.num_channel   ( ifm_channel   ) , 
	.num_filter    ( num_filter    )   
);

ofm_addr_controller #(.SYSTOLIC_SIZE (SYSTOLIC_SIZE), .OFM_RAM_SIZE (OFM_RAM_SIZE)) ofm_addr (
	.clk            ( clk              ) ,
	.rst_n          ( rst_n            ) ,
	.write          ( write_out_ofm_en ) ,
	.read_wgt_size  ( read_wgt_size    ) ,
	.count_filter   ( count_filter     ) ,
	.ofm_addr       ( ofm_addr_b       ) ,
	.write_ofm_size ( write_ofm_size   ) ,
	.ofm_size       ( ofm_size         ) , 
	.maxpool_mode   ( maxpool_mode     ) ,
	.maxpool_stride ( maxpool_stride   ) ,  
	.upsample_mode  ( upsample_mode    )   
);

ifm_FIFO_array #(.DATA_WIDTH (DATA_WIDTH), .MAX_WGT_FIFO_SIZE (MAX_WGT_FIFO_SIZE), .NUM_FIFO (SYSTOLIC_SIZE)) ifm_fifo_array (
	.clk           ( clk           ) ,
	.rd_clr_1      ( ifm_rd_clr_1  ) ,
	.wr_clr_1      ( ifm_wr_clr_1  ) ,
	.rd_en_1       ( ifm_rd_en_1   ) ,
	.wr_en_1       ( ifm_wr_en_1   ) ,
	.rd_clr_2      ( ifm_rd_clr_2  ) ,
	.wr_clr_2      ( ifm_wr_clr_2  ) ,
	.rd_en_2       ( ifm_rd_en_2   ) ,
	.wr_en_2       ( ifm_wr_en_2   ) ,
	.ifm_demux     ( ifm_demux     ) ,
	.ifm_mux       ( ifm_mux       ) ,	
	.read_ifm_size ( read_ifm_size ) ,	
	.data_in       ( ifm_data_in   ) ,
	.data_out      ( left_in       )  
);

wgt_FIFO_array #(.DATA_WIDTH (DATA_WIDTH), .MAX_WGT_FIFO_SIZE (MAX_WGT_FIFO_SIZE), .NUM_FIFO (SYSTOLIC_SIZE)) wgt_fifo_array (
	.clk           ( clk           ) ,
	.rd_clr        ( wgt_rd_clr    ) ,
	.wr_clr        ( wgt_wr_clr    ) ,
	.rd_en         ( wgt_rd_en     ) ,
	.wr_en         ( wgt_wr_en     ) ,
	.read_wgt_size ( read_wgt_size ) ,
	.data_in       ( wgt_data_in   ) ,
	.data_out      ( top_in        )  
);

PE_array #(.DATA_WIDTH (DATA_WIDTH), .SYSTOLIC_SIZE (SYSTOLIC_SIZE)) pe_array (
	.clk          ( clk             ) ,
    .rst_n        ( rst_n           ) ,
	.reset_pe     ( reset_pe        ) ,
    .write_out_en ( write_out_pe_en ) ,
    .wgt_in       ( top_in          ) ,
    .ifm_in       ( left_in         ) ,
    .ofm_out      ( pe_data_out     )
);

PE_MAXPOOL_array #(.DATA_WIDTH (DATA_WIDTH), .NUM_MODULES (SYSTOLIC_SIZE)) maxpool_array_1 (
	.data_in  ( pe_data_out        ) ,
    .data_out ( maxpool_1_data_out ) 
);

FIFO_MAXPOOL_array #(.DATA_WIDTH (DATA_WIDTH), .NUM_MODULES (SYSTOLIC_SIZE)) maxpool_array_2 (
	.data_in  ( maxpool_2_data_in  ) ,
    .data_out ( maxpool_2_data_out )
);

MAXPOOL_FIFO_array #(.DATA_WIDTH (DATA_WIDTH), .SYSTOLIC_SIZE (SYSTOLIC_SIZE), .NUM_FIFO (SYSTOLIC_SIZE)) maxpool_fifo_array (
	.clk      ( clk                ) ,
    .rd_clr   ( maxpool_rd_clr     ) ,
	.wr_clr   ( maxpool_wr_clr     ) ,
    .rd_en    ( maxpool_rd_en      ) ,
    .wr_en    ( maxpool_wr_en      ) ,
    .data_in  ( maxpool_1_data_out ) ,
    .data_out ( fifo_data_out      )
);

main_controller #(.SYSTOLIC_SIZE (SYSTOLIC_SIZE)) main_control (
	.clk                  ( clk                  ) ,
	.rst_n                ( rst_n                ) ,
	.start                ( start                ) ,
	.read_wgt_size        ( read_wgt_size        ) ,

	.load_ifm             ( load_ifm             ) ,
	.load_wgt             ( load_wgt             ) ,
	.ifm_demux            ( ifm_demux            ) ,
	.ifm_mux              ( ifm_mux              ) ,

	.wgt_rd_clr           ( wgt_rd_clr           ) ,
	.wgt_wr_clr           ( wgt_wr_clr           ) ,
	.wgt_rd_en            ( wgt_rd_en            ) ,
	.wgt_wr_en            ( wgt_wr_en            ) ,

	.ifm_rd_clr_1         ( ifm_rd_clr_1         ) ,
	.ifm_wr_clr_1         ( ifm_wr_clr_1         ) ,
	.ifm_rd_en_1          ( ifm_rd_en_1          ) ,
	.ifm_wr_en_1          ( ifm_wr_en_1          ) ,

	.ifm_rd_clr_2         ( ifm_rd_clr_2         ) ,
	.ifm_wr_clr_2         ( ifm_wr_clr_2         ) ,
	.ifm_rd_en_2          ( ifm_rd_en_2          ) ,
	.ifm_wr_en_2          ( ifm_wr_en_2          ) ,

	.maxpool_rd_clr       ( maxpool_rd_clr       ) ,
	.maxpool_wr_clr       ( maxpool_wr_clr       ) ,
    .maxpool_rd_en        ( maxpool_rd_en        ) ,
    .maxpool_wr_en        ( maxpool_wr_en        ) ,	
	
	.reset_pe             ( reset_pe             ) ,
	.write_out_pe_en      ( write_out_pe_en      ) ,
	.write_out_maxpool_en ( write_out_maxpool_en ) ,
	.count_filter         ( count_filter         ) ,
	.done                 ( done                 ) ,

	.ifm_size             ( ifm_size             ) ,
	.ifm_channel          ( ifm_channel          ) ,
	.kernel_size          ( kernel_size          ) ,
	.ofm_size             ( ofm_size_conv        ) ,
	.num_filter           ( num_filter           ) ,
	.maxpool_mode         ( maxpool_mode         ) ,
	.maxpool_stride       ( maxpool_stride       )
);

endmodule