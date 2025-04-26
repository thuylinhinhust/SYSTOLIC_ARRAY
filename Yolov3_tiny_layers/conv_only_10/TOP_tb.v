module TOP_tb();

parameter SYSTOLIC_SIZE  = 16  ;
parameter BUFFER_COUNT   = 16  ;
parameter DATA_WIDTH     = 8   ;
parameter INOUT_WIDTH    = 128 ;
parameter IFM_SIZE       = 13  ;
parameter IFM_CHANNEL    = 512 ;
parameter KERNEL_SIZE    = 1   ; 
parameter NO_FILTER      = 255 ;
parameter MAXPOOL_MODE   = 0   ;
parameter MAXPOOL_STRIDE = 0   ;   
parameter UPSAMPLE_MODE  = 0   ; 

localparam OFM_SIZE_CONV      = IFM_SIZE - KERNEL_SIZE + 1 ;
localparam OFM_SIZE           = (UPSAMPLE_MODE == 1) ? OFM_SIZE_CONV*2 : ((MAXPOOL_MODE == 1) ? ((MAXPOOL_STRIDE == 1) ? OFM_SIZE_CONV : OFM_SIZE_CONV/2) : OFM_SIZE_CONV) ;
localparam NO_TILING_PER_LINE = (OFM_SIZE_CONV  + SYSTOLIC_SIZE - 1) / SYSTOLIC_SIZE ;
localparam NO_TILING          = NO_TILING_PER_LINE * OFM_SIZE_CONV ;

reg  clk   ;
reg  rst_n ;
reg  start ;
wire done  ;

wire [15:0] pe_out_1 = dut.pe_data_out[15:0];
wire [15:0] pe_out_2 = dut.pe_data_out[31:16];
wire [15:0] pe_out_3 = dut.pe_data_out[47:32];
wire [15:0] pe_out_4 = dut.pe_data_out[63:48];
wire [15:0] pe_out_5 = dut.pe_data_out[79:64];
wire [15:0] pe_out_6 = dut.pe_data_out[95:80];
wire [15:0] pe_out_7 = dut.pe_data_out[111:96];
wire [15:0] pe_out_8 = dut.pe_data_out[127:112];
wire [15:0] pe_out_9 = dut.pe_data_out[143:128];
wire [15:0] pe_out_10 = dut.pe_data_out[159:144];
wire [15:0] pe_out_11 = dut.pe_data_out[175:160];
wire [15:0] pe_out_12 = dut.pe_data_out[191:176];
wire [15:0] pe_out_13 = dut.pe_data_out[207:192];
wire [15:0] pe_out_14 = dut.pe_data_out[223:208];
wire [15:0] pe_out_15 = dut.pe_data_out[239:224];
wire [15:0] pe_out_16 = dut.pe_data_out[255:240];

wire [15:0] max_pool_pe_out_1 = dut.max_pool_1_data_out[15:0];
wire [15:0] max_pool_pe_out_2 = dut.max_pool_1_data_out[31:16];
wire [15:0] max_pool_pe_out_3 = dut.max_pool_1_data_out[47:32];
wire [15:0] max_pool_pe_out_4 = dut.max_pool_1_data_out[63:48];
wire [15:0] max_pool_pe_out_5 = dut.max_pool_1_data_out[79:64];
wire [15:0] max_pool_pe_out_6 = dut.max_pool_1_data_out[95:80];
wire [15:0] max_pool_pe_out_7 = dut.max_pool_1_data_out[111:96];
wire [15:0] max_pool_pe_out_8 = dut.max_pool_1_data_out[127:112];
wire [15:0] max_pool_pe_out_9 = dut.max_pool_1_data_out[143:128];
wire [15:0] max_pool_pe_out_10 = dut.max_pool_1_data_out[159:144];
wire [15:0] max_pool_pe_out_11 = dut.max_pool_1_data_out[175:160];
wire [15:0] max_pool_pe_out_12 = dut.max_pool_1_data_out[191:176];
wire [15:0] max_pool_pe_out_13 = dut.max_pool_1_data_out[207:192];
wire [15:0] max_pool_pe_out_14 = dut.max_pool_1_data_out[223:208];
wire [15:0] max_pool_pe_out_15 = dut.max_pool_1_data_out[239:224];
wire [15:0] max_pool_pe_out_16 = dut.max_pool_1_data_out[255:240];

wire [15:0] fifo_out_1 = dut.fifo_data_out[15:0];
wire [15:0] fifo_out_2 = dut.fifo_data_out[31:16];
wire [15:0] fifo_out_3 = dut.fifo_data_out[47:32];
wire [15:0] fifo_out_4 = dut.fifo_data_out[63:48];
wire [15:0] fifo_out_5 = dut.fifo_data_out[79:64];
wire [15:0] fifo_out_6 = dut.fifo_data_out[95:80];
wire [15:0] fifo_out_7 = dut.fifo_data_out[111:96];
wire [15:0] fifo_out_8 = dut.fifo_data_out[127:112];
wire [15:0] fifo_out_9 = dut.fifo_data_out[143:128];
wire [15:0] fifo_out_10 = dut.fifo_data_out[159:144];
wire [15:0] fifo_out_11 = dut.fifo_data_out[175:160];
wire [15:0] fifo_out_12 = dut.fifo_data_out[191:176];
wire [15:0] fifo_out_13 = dut.fifo_data_out[207:192];
wire [15:0] fifo_out_14 = dut.fifo_data_out[223:208];
wire [15:0] fifo_out_15 = dut.fifo_data_out[239:224];
wire [15:0] fifo_out_16 = dut.fifo_data_out[255:240];

wire [15:0] max_pool_fifo_out_1 = dut.max_pool_2_data_out[15:0];
wire [15:0] max_pool_fifo_out_2 = dut.max_pool_2_data_out[31:16];
wire [15:0] max_pool_fifo_out_3 = dut.max_pool_2_data_out[47:32];
wire [15:0] max_pool_fifo_out_4 = dut.max_pool_2_data_out[63:48];
wire [15:0] max_pool_fifo_out_5 = dut.max_pool_2_data_out[79:64];
wire [15:0] max_pool_fifo_out_6 = dut.max_pool_2_data_out[95:80];
wire [15:0] max_pool_fifo_out_7 = dut.max_pool_2_data_out[111:96];
wire [15:0] max_pool_fifo_out_8 = dut.max_pool_2_data_out[127:112];
wire [15:0] max_pool_fifo_out_9 = dut.max_pool_2_data_out[143:128];
wire [15:0] max_pool_fifo_out_10 = dut.max_pool_2_data_out[159:144];
wire [15:0] max_pool_fifo_out_11 = dut.max_pool_2_data_out[175:160];
wire [15:0] max_pool_fifo_out_12 = dut.max_pool_2_data_out[191:176];
wire [15:0] max_pool_fifo_out_13 = dut.max_pool_2_data_out[207:192];
wire [15:0] max_pool_fifo_out_14 = dut.max_pool_2_data_out[223:208];
wire [15:0] max_pool_fifo_out_15 = dut.max_pool_2_data_out[239:224];
wire [15:0] max_pool_fifo_out_16 = dut.max_pool_2_data_out[255:240];

wire [15:0] ofm_out_1 = dut.ofm_data_out[15:0];
wire [15:0] ofm_out_2 = dut.ofm_data_out[31:16];
wire [15:0] ofm_out_3 = dut.ofm_data_out[47:32];
wire [15:0] ofm_out_4 = dut.ofm_data_out[63:48];
wire [15:0] ofm_out_5 = dut.ofm_data_out[79:64];
wire [15:0] ofm_out_6 = dut.ofm_data_out[95:80];
wire [15:0] ofm_out_7 = dut.ofm_data_out[111:96];
wire [15:0] ofm_out_8 = dut.ofm_data_out[127:112];
wire [15:0] ofm_out_9 = dut.ofm_data_out[143:128];
wire [15:0] ofm_out_10 = dut.ofm_data_out[159:144];
wire [15:0] ofm_out_11 = dut.ofm_data_out[175:160];
wire [15:0] ofm_out_12 = dut.ofm_data_out[191:176];
wire [15:0] ofm_out_13 = dut.ofm_data_out[207:192];
wire [15:0] ofm_out_14 = dut.ofm_data_out[223:208];
wire [15:0] ofm_out_15 = dut.ofm_data_out[239:224];
wire [15:0] ofm_out_16 = dut.ofm_data_out[255:240];

//wire [4:0] rd_ptr = dut.fifo_array.rd_ptr;
//wire [4:0] wr_ptr = dut.fifo_array.wr_ptr;

TOP #(
    .SYSTOLIC_SIZE  ( SYSTOLIC_SIZE  ) ,
    .BUFFER_COUNT   ( BUFFER_COUNT   ) ,
    .DATA_WIDTH     ( DATA_WIDTH     ) ,
    .INOUT_WIDTH    ( INOUT_WIDTH    ) ,
    .IFM_SIZE       ( IFM_SIZE       ) ,
    .IFM_CHANNEL    ( IFM_CHANNEL    ) ,
    .KERNEL_SIZE    ( KERNEL_SIZE    ) ,
    .NO_FILTER      ( NO_FILTER      ) ,
    .MAXPOOL_MODE   ( MAXPOOL_MODE   ) ,
    .MAXPOOL_STRIDE ( MAXPOOL_STRIDE ) ,
    .UPSAMPLE_MODE  ( UPSAMPLE_MODE  )
) dut (
    .clk   ( clk   ) ,
    .rst_n ( rst_n ) ,
    .start ( start ) ,
    .done  ( done  )
);

//read text files
initial begin
    $readmemb ("./ifm_bin_c512xh13xw13.txt", dut.dpram_ifm.mem);
end

initial begin
    $readmemb ("./weight_bin_co255xci512xk1xk1.txt", dut.dpram_wgt.mem);
end

reg [DATA_WIDTH*2 - 1 : 0] ofm_golden [OFM_SIZE * OFM_SIZE * NO_FILTER - 1 : 0];
initial begin
	$readmemb ("./ofm_bin_c255xh13xw13.txt", ofm_golden);
end

initial begin
    $dumpfile ("TOP.VCD");
    $dumpvars (0, TOP_tb);
end

//start
always #5 clk = ~clk;

initial begin
    clk   = 0 ;
    rst_n = 0 ;
    start = 0 ;
    #30 rst_n = 1  ;
    #20 start = 1  ;
    #20 start = 0  ;
    #10000000 $finish ; 
end

//write to output text file
integer i, j;
integer file;

initial begin
    wait (done)
    file = $fopen ("output_matrix.txt", "w");
        for (i = 0; i < OFM_SIZE * NO_FILTER; i = i + 1) begin
            for (j = 0; j < OFM_SIZE; j = j + 1) begin
                $fwrite (file, "%0d ", $signed(dut.dpram_ofm.mem[i * OFM_SIZE + j]));  
            end
            $fwrite (file, "\n");
            if ( (i + 1) % OFM_SIZE == 0 ) $fwrite (file, "\n");
        end
        $fclose (file);
end

//compare
task compare;
	integer i;
	begin
		for (i = 0; i < OFM_SIZE * OFM_SIZE * NO_FILTER; i = i + 1) begin
			$display (" matrix ofm RTL : %d", dut.dpram_ofm.mem[i]);
			$display (" matrix golden : %d", ofm_golden[i]);
			if (ofm_golden[i] != dut.dpram_ofm.mem[i]) begin
				$display ("NO PASS in addess %d", i);
				disable compare;
			end
		end
		$display("\n");
		$display("██████╗  █████╗ ███████╗███████╗    ████████╗███████╗███████╗████████╗");
		$display("██╔══██╗██╔══██╗██╔════╝██╔════╝    ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝");
		$display("██████╔╝███████║███████╗███████╗       ██║   █████╗  ███████    ██║   ");
		$display("██╔═══╝ ██╔══██║╚════██║╚════██║       ██║   ██╔══╝       ██    ██║   ");
		$display("██║     ██║  ██║███████║███████║       ██║   ███████╗███████╗   ██║   ");
		$display("╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝       ╚═╝   ╚══════╝╚══════╝   ╚═╝   ");
	end
endtask

always @(posedge done) begin
	if (done) begin
		compare();
	end
end

initial begin
	$monitor ("At time : %d - counter filter = %d - counter tiling = %d (max = %d)", $time, dut.main_control.count_filter, dut.main_control.count_tiling, NO_TILING);
end

endmodule