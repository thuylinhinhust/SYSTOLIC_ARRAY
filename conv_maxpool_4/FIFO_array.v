module FIFO_array #( 
	parameter DATA_WIDTH    = 8  ,
	parameter SYSTOLIC_SIZE = 16 , 
	parameter NUM_MODULES   = 16
) (
	input                                       clk      ,
	input                                       rd_clr   ,
	input                                       wr_clr   ,
	input                                       rd_en    ,
	input                                       wr_en    , 
	input  [NUM_MODULES * DATA_WIDTH*2 - 1 : 0] data_in  ,
	output [NUM_MODULES * DATA_WIDTH*2 - 1 : 0] data_out   
);

	genvar i;
    generate
        for (i = 0; i < NUM_MODULES; i = i + 1) begin : fifo
           FIFO #(.DATA_WIDTH(DATA_WIDTH), .FIFO_SIZE(SYSTOLIC_SIZE), .ADDR_WIDTH(5)) fifo_inst (
           		.clk           ( clk                                        ) , 
           		.rd_clr        ( rd_clr                                     ) ,    
           		.wr_clr        ( wr_clr                                     ) ,  
           		.rd_inc        ( 1'b1                                       ) ,
           		.wr_inc        ( 1'b1                                       ) ,
				.rd_en         ( rd_en                                      ) ,
           		.wr_en         ( wr_en                                      ) ,
           		.data_in_fifo  ( data_in [i * DATA_WIDTH*2 +: DATA_WIDTH*2] ) ,
           		.data_out_fifo ( data_out[i * DATA_WIDTH*2 +: DATA_WIDTH*2] )
			);	
		end
	endgenerate

endmodule