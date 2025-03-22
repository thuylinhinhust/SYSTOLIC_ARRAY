module ifm_addr_controller_tb();

parameter KERNEL_SIZE = 3   ;
parameter IFM_SIZE    = 416 ;
parameter IFM_CHANNEL = 3   ;
parameter ADDR_WIDTH  = 19  ;

reg                       clk        ;
reg                       rst_n      ;
reg                       load       ;
wire [ADDR_WIDTH - 1 : 0] ifm_addr   ;
wire                      addr_valid ;

ifm_addr_controller #(
    .KERNEL_SIZE ( KERNEL_SIZE ) ,
    .IFM_SIZE    ( IFM_SIZE    ) ,
    .IFM_CHANNEL ( IFM_CHANNEL ) ,
    .ADDR_WIDTH  ( ADDR_WIDTH  )
) ifm_addr_dut (
    .clk        ( clk        ) ,
    .rst_n      ( rst_n      ) ,
    .load       ( load       ) ,
    .ifm_addr   ( ifm_addr   ) ,
    .addr_valid ( addr_valid )
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    load = 0;

    #30 rst_n = 1; load = 1;
    #1000 $finish;
end

initial begin
    $dumpfile ("ifm_addr_controller.VCD");
    $dumpvars (0, ifm_addr_controller_tb);
end

endmodule