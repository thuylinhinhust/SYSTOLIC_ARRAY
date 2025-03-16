module TOP #(
	parameter SYSTOLIC_SIZE = 16,
    parameter BUFFER_COUNT = 16,
    parameter IFM_SIZE = 64,
    parameter IFM_CHANNEL = 3,
    parameter WEIGHT_SIZE = 3,
    parameter WEIGHT_FILTER = 16,
	parameter DATA_WIDTH = 8
) (
	input                      clk                                   ,
	input                      rst_n                                 ,
	input                      data_valid                            ,
	input [BUFFER_COUNT * DATA_WIDTH - 1 : 0] ifm_data_in            ,
	input [BUFFER_COUNT * DATA_WIDTH - 1 : 0] weight_data_in         ,
	output                     ifm_read_en                           ,
	output                     weight_read_en                        ,
	output                     done                               
);

	wire [BUFFER_COUNT * DATA_WIDTH   - 1 : 0] left_in ;
	wire [BUFFER_COUNT * DATA_WIDTH   - 1 : 0] top_in  ;
	wire [BUFFER_COUNT * DATA_WIDTH*2 - 1 : 0] result  ;

	wire [BUFFER_COUNT - 1 : 0] ifm_in_valid, weight_in_valid;
	wire                        ofm_in_valid;
	wire [(SYSTOLIC_SIZE - 1) * 2 : 0] set_reg_compute;
	wire [SYSTOLIC_SIZE - 2 : 0] set_reg_write;
	wire ofm_write_en;
	wire sel_mux;
	wire reset_pe;

shift_reg_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(9), .BUFFER_COUNT(BUFFER_COUNT)) ifm (
	.clk      ( clk          ) ,
	.rst_n    ( rst_n        ) ,
	.read_en  ( ifm_read_en  ) ,
	.in_valid ( ifm_in_valid ) ,
	.data_in  ( ifm_data_in  ) ,
	.data_out ( left_in      )  
);

shift_reg_16 #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_SIZE(9), .BUFFER_COUNT(BUFFER_COUNT)) weight (
	.clk      ( clk             ) ,
	.rst_n    ( rst_n           ) ,
	.read_en  ( weight_read_en  ) ,
	.in_valid ( weight_in_valid ) ,
	.data_in  ( weight_data_in  ) ,
	.data_out ( top_in          )  
);

shift_reg_16 #(.DATA_WIDTH(DATA_WIDTH*2), .BUFFER_SIZE(16), .BUFFER_COUNT(BUFFER_COUNT)) ofm (
	.clk      ( clk          ) ,
	.rst_n    ( rst_n        ) ,
	.read_en  ( ofm_write_en ) ,
	.in_valid ( ofm_in_valid ) ,
	.data_in  ( result       ) ,
	.data_out (              )  
);

PE_array #(.DATA_WIDTH(DATA_WIDTH), .SYSTOLIC_SIZE(SYSTOLIC_SIZE)) pe_array (
	.clk             ( clk              ) ,
    .rst_n           ( rst_n & reset_pe ) , 
    .set_reg_compute ( set_reg_compute  ) ,
    .set_reg_write   ( set_reg_write    ) ,
    .ofm_write_en    ( ofm_write_en     ) ,
    .sel_mux         ( sel_mux          ) ,
    .top_in          ( top_in           ) ,
    .left_in         ( left_in          ) ,
    .result          ( result           )
);

controller #(.SYSTOLIC_SIZE(SYSTOLIC_SIZE), .BUFFER_SIZE(9), .BUFFER_COUNT(BUFFER_COUNT), .IFM_SIZE(IFM_SIZE), .IFM_CHANNEL(IFM_CHANNEL), .WEIGHT_SIZE(WEIGHT_SIZE), .WEIGHT_FILTER(WEIGHT_FILTER)) control (
	.clk             ( clk             ) ,
    .rst_n           ( rst_n           ) ,
    .data_valid      ( data_valid      ) ,
    .ifm_read_en     ( ifm_read_en     ) , 
	.weight_read_en  ( weight_read_en  ) ,
    .ifm_in_valid    ( ifm_in_valid    ) , 
	.weight_in_valid ( weight_in_valid ) ,
    .ofm_in_valid    ( ofm_in_valid    ) ,
    .set_reg_compute ( set_reg_compute ) ,
    .set_reg_write   ( set_reg_write   ) ,
    .ofm_write_en    ( ofm_write_en    ) ,
    .sel_mux         ( sel_mux         ) ,
    .reset_pe        ( reset_pe        ) ,
    .done            ( done            )
);

endmodule
