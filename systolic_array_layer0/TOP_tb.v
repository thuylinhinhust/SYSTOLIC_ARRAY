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
reg                      ofm_we_b ;

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
    .wgt_we_a ( wgt_we_a ) ,
    .ofm_we_b ( ofm_we_b ) 
    
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    start = 0;
    ifm_we_a = 0;
    wgt_we_a = 0;
    ofm_we_b = 1;

    #30 rst_n = 1; 
    #50 start = 1;
    #2000 start = 0;
    #250 start = 1;
    #5000 $finish;
end

initial begin
    $dumpfile ("TOPv2.VCD");
    $dumpvars (0, TOP_tb);
end

endmodule