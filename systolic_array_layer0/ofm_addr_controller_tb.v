module ofm_addr_controller_tb();

parameter ADDR_WIDTH    = 22  ;
parameter SYSTOLIC_SIZE = 16  ;
parameter OFM_SIZE      = 416 ;

reg                       clk        ;
reg                       rst_n      ;
reg                       write      ;
wire [ADDR_WIDTH - 1 : 0] ofm_addr   ;
wire                      addr_valid ;

ofm_addr_controller #(
    .ADDR_WIDTH    ( ADDR_WIDTH    ) ,
    .SYSTOLIC_SIZE ( SYSTOLIC_SIZE ) ,
    .OFM_SIZE      ( OFM_SIZE      )
) ofm_addr_dut (
    .clk        ( clk        ) ,
    .rst_n      ( rst_n      ) ,
    .write      ( write      ) ,
    .ofm_addr   ( ofm_addr   ) ,
    .addr_valid ( addr_valid )
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    write = 0;

    #30 rst_n = 1; 
    #50 write = 1;
    #500 write = 0;
    #100 write = 1;
    #500 $finish;
end

initial begin
    $dumpfile ("ofm_addr_controller.VCD");
    $dumpvars (0, ofm_addr_controller_tb);
end

endmodule