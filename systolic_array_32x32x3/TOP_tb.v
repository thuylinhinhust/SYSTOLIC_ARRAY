module TOP_tb();

parameter SYSTOLIC_SIZE = 16 ;
parameter BUFFER_COUNT  = 16 ;
parameter BUFFER_SIZE   = 27 ;
parameter DATA_WIDTH    = 8  ;
parameter INOUT_WIDTH   = 128;

reg                       clk        ;
reg                       rst_n      ;
reg                       start       ;
reg                      ifm_we_a ;
reg                      wgt_we_a ;
//reg                      ofm_we_b ;

TOP #(
    .SYSTOLIC_SIZE ( SYSTOLIC_SIZE ) ,
    .BUFFER_COUNT  ( BUFFER_COUNT  ) ,
    .BUFFER_SIZE  ( BUFFER_SIZE  ) ,
    .DATA_WIDTH  ( DATA_WIDTH  ) ,
    .INOUT_WIDTH  ( INOUT_WIDTH  ) 
) dut (
    .clk        ( clk        ) ,
    .rst_n      ( rst_n      ) ,
    .start       ( start       ) ,
    .ifm_we_a   ( ifm_we_a   ) ,
    .wgt_we_a ( wgt_we_a ) 
    //.ofm_we_b ( ofm_we_b ) 
    
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    start = 0;
    ifm_we_a = 0;
    wgt_we_a = 0;
    //ofm_we_b = 1;

    #30 rst_n = 1; 

end

    initial begin
        $readmemb ("./ifm_bin_c3xh34xw34.txt", dut.dpram_ifm.mem);
    end

    initial begin
        $readmemb ("./weight_bin_co16xci3xk3xk3.txt", dut.dpram_wgt.mem);
    end

    integer i, j;
    integer file;

    initial begin
        wait (dut.done)
        file = $fopen("output_matrix_1.txt", "w");
            for (i = 0; i < 32*16 ; i = i + 1) begin
                for (j = 0; j < 32; j = j + 1) begin
                    $fwrite(file, "%0d ", $signed(dut.dpram_ofm.mem[i * 32 + j]));  
                end
                $fwrite(file, "\n");
                if((i % 32) == 0 && i != 0) $fwrite(file, "\n");
            end
            $fclose(file);
    end


initial begin
    #50 start = 1;
    #20 start = 0;

    #80000 $finish;
end
initial begin 
    $monitor( " counter write = %d " , dut.main_control.count_write );
    $monitor( " counter filter = %d " , dut.main_control.count_filter );
end
initial begin
    $dumpfile ("TOP.VCD");
    $dumpvars (0, TOP_tb);
end

endmodule