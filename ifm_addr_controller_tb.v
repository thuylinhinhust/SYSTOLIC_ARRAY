module ifm_addr_controller_tb ();

parameter KERNEL_SIZE = 1  ;
parameter IFM_SIZE    = 26 ;
parameter IFM_CHANNEL = 20 ;
parameter ADDR_WIDTH  = 14 ;

reg                       clk      ;
reg                       rst_n    ;
reg                       load     ;
wire [4:0]                size     ;
wire [ADDR_WIDTH - 1 : 0] ifm_addr ;
wire                      read_en  ;

ifm_addr_controller #(
    .KERNEL_SIZE ( KERNEL_SIZE ) ,
    .IFM_SIZE    ( IFM_SIZE    ) ,
    .IFM_CHANNEL ( IFM_CHANNEL ) ,
    .ADDR_WIDTH  ( ADDR_WIDTH  )
) ifm_addr_dut (
    .clk      ( clk      ) ,
    .rst_n    ( rst_n    ) ,
    .load     ( load     ) ,
    .size     ( size     ) ,
    .ifm_addr ( ifm_addr ) ,
    .read_en  ( read_en  )
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    load = 0;

    #30 rst_n = 1; load = 1;
    #40000 $finish;
end

initial begin
    $dumpfile ("ifm_addr_controller.VCD");
    $dumpvars (0, ifm_addr_controller_tb);
end

endmodule