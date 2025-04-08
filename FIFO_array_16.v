module FIFO_array_16 #( parameter SYSTOLIC_SIZE = 16, DATA_WIDTH = 8) 
	(
		input clk,
		input rst_n,
		input [SYSTOLIC_SIZE * 2 *DATA_WIDTH - 1 :0] data_in,
		input [SYSTOLIC_SIZE-1 :0] rd_en,
		input [SYSTOLIC_SIZE - 1:0] wr_en,
		input [SYSTOLIC_SIZE - 1:0] rd_clr,
		input [SYSTOLIC_SIZE - 1:0] wr_clr,
		output [SYSTOLIC_SIZE * 2*DATA_WIDTH - 1 :0] data_out
	);

	  wire [SYSTOLIC_SIZE * 2 * DATA_WIDTH - 1 :0] data_out_fifo;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : fifo
           FIFO_ASYNCH #(.DATA_WIDTH(DATA_WIDTH), .FIFO_SIZE(SYSTOLIC_SIZE - i), .ADD_WIDTH(5)) fifo_inst (
           		 .clk1          (clk   )    
           		,.clk2          (clk   )    
           		,.rd_clr        (rd_clr[i])       
           		,.wr_clr        (wr_clr[i])      
           		,.rd_inc        ( 1'b1    )  
           		,.wr_inc        ( 1'b1    ) 
           		,.wr_en         (wr_en [i] )    
           		,.rd_en         (rd_en [i] )  
           		,.data_in_fifo  (data_in[(i+1)*DATA_WIDTH*2-1:(i*2*DATA_WIDTH)]) 
           		,.data_out_fifo (data_out_fifo[(i+1)*DATA_WIDTH*2-1:(i*2*DATA_WIDTH)])
	);	
		end
	endgenerate
	assign data_out = data_out_fifo;
endmodule
