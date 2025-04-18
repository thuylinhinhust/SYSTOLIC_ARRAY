module TOP_tb();

parameter SYSTOLIC_SIZE     = 16      ;
parameter DATA_WIDTH        = 16      ;
parameter INOUT_WIDTH       = 256     ;
parameter IFM_RAM_SIZE      = 705600  ;
parameter WGT_RAM_SIZE      = 8845488 ;
parameter OFM_RAM_SIZE      = 692224  ;
parameter MAX_WGT_FIFO_SIZE = 4608    ;

//Modify layer config to different input
localparam IFM_SIZE       = 9'd26  ;
localparam IFM_CHANNEL    = 11'd16  ;
localparam KERNEL_SIZE    = 2'd1   ; 
localparam NUM_FILTER     = 11'd15 ;
localparam MAXPOOL_MODE   = 1'd0   ;
localparam MAXPOOL_STRIDE = 2'd0   ;   
localparam UPSAMPLE_MODE  = 1'd0   ; 

localparam OFM_SIZE_CONV = IFM_SIZE - KERNEL_SIZE + 1 ;
localparam OFM_SIZE      = (UPSAMPLE_MODE == 1) ? OFM_SIZE_CONV*2 : ((MAXPOOL_MODE == 1) ? ((MAXPOOL_STRIDE == 1) ? OFM_SIZE_CONV : OFM_SIZE_CONV/2) : OFM_SIZE_CONV) ;


reg  clk   ;
reg  rst_n ;
reg  start ;
wire done  ;

//Modify layer config
reg [8 : 0] ifm_size       ;
reg [10: 0] ifm_channel    ;
reg [1 : 0] kernel_size    ; 
reg [10: 0] num_filter     ;
reg         maxpool_mode   ;
reg [1 : 0] maxpool_stride ;
reg         upsample_mode  ;

TOP #(
    .SYSTOLIC_SIZE     ( SYSTOLIC_SIZE     ) ,
    .DATA_WIDTH        ( DATA_WIDTH        ) ,
    .INOUT_WIDTH       ( INOUT_WIDTH       ) ,
    .IFM_RAM_SIZE      ( IFM_RAM_SIZE      ) ,
    .WGT_RAM_SIZE      ( WGT_RAM_SIZE      ) ,
    .OFM_RAM_SIZE      ( OFM_RAM_SIZE      ) ,
    .MAX_WGT_FIFO_SIZE ( MAX_WGT_FIFO_SIZE ) 
) dut (
    .clk   ( clk   ) ,
    .rst_n ( rst_n ) ,
    .start ( start ) ,
    .done  ( done  ) ,
    //Modify layer config
    .ifm_size       ( IFM_SIZE       ) ,
    .ifm_channel    ( IFM_CHANNEL    ) ,
    .kernel_size    ( KERNEL_SIZE    ) ,
    .num_filter     ( NUM_FILTER     ) ,
    .maxpool_mode   ( MAXPOOL_MODE   ) ,
    .maxpool_stride ( MAXPOOL_STRIDE ) ,
    .upsample_mode  ( UPSAMPLE_MODE  )
);

//read text files
initial begin
    $readmemb ("./ifm_bin_c16xh26xw26.txt", dut.ifm_dpram.mem);
end

initial begin
    $readmemb ("./weight_bin_co15xci16xk1xk1.txt", dut.wgt_dpram.mem);
end

reg [DATA_WIDTH - 1 : 0] ofm_golden [OFM_SIZE * OFM_SIZE * NUM_FILTER - 1 : 0];
initial begin
	$readmemb ("./ofm_bin_c15xh26xw26.txt", ofm_golden);
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
    #100000 $finish ; 
end

//write to output text file
integer i, j;
integer file;

initial begin
    wait (done)
    file = $fopen ("output_matrix.txt", "w");
        for (i = 0; i < OFM_SIZE * NUM_FILTER; i = i + 1) begin
            for (j = 0; j < OFM_SIZE; j = j + 1) begin
                $fwrite (file, "%0d ", $signed(dut.ofm_dpram.mem[i * OFM_SIZE + j]));  
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
		for (i = 0; i < OFM_SIZE * OFM_SIZE * NUM_FILTER; i = i + 1) begin
			$display (" matrix ofm RTL : %d", dut.ofm_dpram.mem[i]);
			$display (" matrix golden : %d", ofm_golden[i]);
			if (ofm_golden[i] != dut.ofm_dpram.mem[i]) begin
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
	$monitor ("At time : %d - counter filter = %d (max = %d) - counter tiling = %d (max = %d)", $time, dut.main_control.count_filter, dut.main_control.num_load_filter, dut.main_control.count_tiling, dut.main_control.num_tiling);
end

endmodule