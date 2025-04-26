module TOP_tb();

parameter SYSTOLIC_SIZE = 16  ;
parameter BUFFER_COUNT  = 16  ;
parameter DATA_WIDTH    = 8   ;
parameter INOUT_WIDTH   = 128 ;
parameter IFM_SIZE      = 34  ;
parameter IFM_CHANNEL   = 16  ;
parameter KERNEL_SIZE   = 3   ; 
parameter NO_FILTER     = 32  ;

localparam OFM_SIZE           = IFM_SIZE - KERNEL_SIZE + 1 ;
localparam NO_TILING_PER_LINE = IFM_SIZE / SYSTOLIC_SIZE;
localparam NO_TILING          = NO_TILING_PER_LINE * OFM_SIZE;

reg  clk   ;
reg  rst_n ;
reg  start ;
wire done  ;

TOP #(
    .SYSTOLIC_SIZE ( SYSTOLIC_SIZE ) ,
    .BUFFER_COUNT  ( BUFFER_COUNT  ) ,
    .DATA_WIDTH    ( DATA_WIDTH    ) ,
    .INOUT_WIDTH   ( INOUT_WIDTH   ) ,
    .IFM_SIZE      ( IFM_SIZE      ) ,
    .IFM_CHANNEL   ( IFM_CHANNEL   ) ,
    .KERNEL_SIZE   ( KERNEL_SIZE   ) ,
    .NO_FILTER     ( NO_FILTER     ) 
) dut (
    .clk   ( clk   ) ,
    .rst_n ( rst_n ) ,
    .start ( start ) ,
    .done  ( done  )
);

//read text files
initial begin
    $readmemb ("./ifm_bin_c16xh34xw34.txt", dut.dpram_ifm.mem);
end

initial begin
    $readmemb ("./weight_bin_co32xci16xk3xk3.txt", dut.dpram_wgt.mem);
end

reg [DATA_WIDTH*2 - 1 : 0] ofm_golden [OFM_SIZE * OFM_SIZE * NO_FILTER - 1 : 0];
initial begin
	$readmemb ("./ofm_bin_c32xh32xw32.txt", ofm_golden);
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
    #300000 $finish ; 
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