module wgt_addr_controller_tb();
 
parameter SYSTOLIC_SIZE = 16 ;
parameter KERNEL_SIZE   = 1  ;
parameter NO_CHANNEL    = 3  ;
parameter NO_FILTER     = 19 ;
parameter ADDR_WIDTH    = 11 ;

reg                       clk        ;
reg                       rst_n      ;
reg                       load       ;
wire [ADDR_WIDTH - 1 : 0] wgt_addr   ;
wire                      read_en    ;
wire [4:0]                size       ;

wgt_addr_controller #(
    .SYSTOLIC_SIZE (SYSTOLIC_SIZE),
    .KERNEL_SIZE ( KERNEL_SIZE ) ,
    .NO_CHANNEL  ( NO_CHANNEL  ) ,
    .NO_FILTER   (NO_FILTER) ,
    .ADDR_WIDTH  ( ADDR_WIDTH  )
) wgt_addr_dut (
    .clk        ( clk        ) ,
    .rst_n      ( rst_n      ) ,
    .load       ( load       ) ,
    .wgt_addr   ( wgt_addr   ) ,
    .read_en    ( read_en    ) ,
    .size       ( size )
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    load = 0;

    #30 rst_n = 1; load = 1;
    #50 load = 0;
    #350 load = 1;
    #500 $finish;
end

initial begin
    $dumpfile ("wgt_addr_controller.VCD");
    $dumpvars (0, wgt_addr_controller_tb);
end

endmodule