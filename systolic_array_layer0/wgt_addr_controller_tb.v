module wgt_addr_controller_tb();

parameter KERNEL_SIZE = 3  ;
parameter NO_CHANNEL  = 3  ;
parameter ADDR_WIDTH  = 11 ;

reg                       clk        ;
reg                       rst_n      ;
reg                       load       ;
wire [ADDR_WIDTH - 1 : 0] wgt_addr   ;
wire                      addr_valid ;

wgt_addr_controller #(
    .KERNEL_SIZE ( KERNEL_SIZE ) ,
    .NO_CHANNEL  ( NO_CHANNEL  ) ,
    .ADDR_WIDTH  ( ADDR_WIDTH  )
) wgt_addr_dut (
    .clk        ( clk        ) ,
    .rst_n      ( rst_n      ) ,
    .load       ( load       ) ,
    .wgt_addr   ( wgt_addr   ) ,
    .addr_valid ( addr_valid )
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    load = 0;

    #30 rst_n = 1; load = 1;
    #50 load = 0;
    #250 load = 1;
    #500 $finish;
end

initial begin
    $dumpfile ("wgt_addr_controller.VCD");
    $dumpvars (0, wgt_addr_controller_tb);
end

endmodule