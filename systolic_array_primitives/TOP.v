module TOP #(
	parameter SYSTOLIC_SIZE = 16,
    parameter BUFFER_COUNT  = 16,
	parameter DATA_WIDTH    = 8
) (
	input                                     clk                    ,
	input                                     rst_n                  ,
	input [8:0]                               weight_addr            ,
	input [18:0]                              ifm_addr_a, ifm_addr_b ,
	input [DATA_WIDTH * BUFFER_COUNT - 1 : 0] din_a, din_b           ,
	input [BUFFER_COUNT              - 1]     we_a , we_b	
);
    wire [BUFFER_COUNT * DATA_WIDTH   - 1 : 0] weight_data_in ;  
	wire [BUFFER_COUNT * DATA_WIDTH   - 1 : 0] ifm_data_in    ;
	wire [BUFFER_COUNT * DATA_WIDTH   - 1 : 0] left_in        ;
	wire [BUFFER_COUNT * DATA_WIDTH   - 1 : 0] top_in         ;
	wire [BUFFER_COUNT * DATA_WIDTH*2 - 1 : 0] result         ;

	wire [BUFFER_COUNT - 1 : 0] ifm_in_valid, weight_in_valid ;
	wire                        ofm_in_valid                  ;
	wire [(SYSTOLIC_SIZE - 1) * 2 : 0] set_reg_compute        ;
	wire [SYSTOLIC_SIZE - 2 : 0]       set_reg_write          ;
	wire sel_mux                                              ;
	wire reset_pe                                             ;

ROM #(.ADDR_WIDTH(9), .ADDR_LINE(432), .DATA_WIDTH(DATA_WIDTH), .NUM_BANKS (BUFFER_COUNT)) weight_rom (
	.clk  ( clk            ) ,
	.addr ( weight_addr    ) ,
	.dout ( weight_data_in )
);

IFM_DPRAM #(.ADDR_WIDTH(19), .ADDR_LINE(519168), .DATA_WIDTH(DATA_WIDTH), .NUM_BANKS (BUFFER_COUNT)) ifm_ram (
	.clk    ( clk         ) ,
	.we_a   ( we_a        ) ,
	.addr_a ( ifm_addr_a  ) ,
	.din_a  ( din_a       ) ,
	.dout_a ( ifm_data_in ) ,
	.we_b   ( we_b        ) ,
	.addr_b ( ifm_addr_b  ) ,
	.din_b  ( din_b       ) ,
	.dout_b (             )	
);

shift_reg_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(27), .BUFFER_COUNT(BUFFER_COUNT)) ifm (
	.clk      ( clk          ) ,
	.rst_n    ( rst_n        ) ,
	.in_valid ( ifm_in_valid ) ,
	.data_in  ( ifm_data_in  ) ,
	.data_out ( left_in      )  
);

shift_reg_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(27), .BUFFER_COUNT(BUFFER_COUNT)) weight (
	.clk      ( clk             ) ,
	.rst_n    ( rst_n           ) ,
	.in_valid ( weight_in_valid ) ,
	.data_in  ( weight_data_in  ) ,
	.data_out ( top_in          )  
);

shift_reg_16 #(.DATA_WIDTH(DATA_WIDTH*2), .BUFFER_SIZE(16), .BUFFER_COUNT(BUFFER_COUNT)) ofm (   //buffer sized fixed 16
	.clk      ( clk          ) ,
	.rst_n    ( rst_n        ) ,
	.in_valid ( ofm_in_valid ) ,
	.data_in  ( result       ) ,
	.data_out (              )  
);

PE_array #(.DATA_WIDTH(DATA_WIDTH), .SYSTOLIC_SIZE(SYSTOLIC_SIZE)) pe_array (
	.clk             ( clk              ) ,
    .rst_n           ( rst_n & reset_pe ) ,   //reset_pe after write out
    .set_reg_compute ( set_reg_compute  ) ,
    .set_reg_write   ( set_reg_write    ) ,
    .ofm_write_en    ( ofm_write_en     ) ,
    .psum_down_en    ( sel_mux          ) ,
    .top_in          ( top_in           ) ,
    .left_in         ( left_in          ) ,
    .result          ( result           )
);

endmodule
