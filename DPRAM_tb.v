module DPRAM_tb ();

parameter ADDR_WIDTH  = 9   ;
parameter ADDR_LINE   = 432 ;
parameter DATA_WIDTH  = 8   ;
parameter INOUT_WIDTH = 128 ;

reg                        clk    ;
reg  [4:0]                 size   ;
reg                        re_a   ;
reg  [ADDR_WIDTH  - 1 : 0] addr_a ;
wire [INOUT_WIDTH - 1 : 0] dout_a ;
reg                        we_b   ;
reg  [ADDR_WIDTH  - 1 : 0] addr_b ;
reg  [INOUT_WIDTH - 1 : 0] din_b  ;

DPRAM #(.ADDR_WIDTH(ADDR_WIDTH), .ADDR_LINE(ADDR_LINE), .DATA_WIDTH(DATA_WIDTH), .INOUT_WIDTH(INOUT_WIDTH)
) dut (
    .clk    ( clk    ) ,
    .size   ( size   ) ,
    .re_a   ( re_a   ) ,
    .addr_a ( addr_a ) ,
    .dout_a ( dout_a ) ,
    .we_b   ( we_b   ) ,
    .addr_b ( addr_b ) ,
    .din_b  ( din_b  )
);

always #5 clk = ~clk;

initial begin
    dut.mem [48] = 8'h11;
    dut.mem [49] = 8'h11;
    dut.mem [50] = 8'h11;
    dut.mem [51] = 8'h11;
    dut.mem [52] = 8'h11;
    dut.mem [53] = 8'h11;
    dut.mem [54] = 8'h11;
    dut.mem [55] = 8'h11;
    dut.mem [56] = 8'h11;
    dut.mem [57] = 8'h11;
    dut.mem [58] = 8'h11;
    dut.mem [59] = 8'h11;
    dut.mem [60] = 8'h11;
    dut.mem [61] = 8'h11;
    dut.mem [62] = 8'h11;
    dut.mem [63] = 8'h11;

    clk = 0;
    we_b = 1;
    addr_b = 16;
    din_b = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    size = 16;
    #10 
    addr_b = 48;
    din_b = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    size = 8;
    #10
    we_b = 0;
    re_a = 1;
    addr_a = 16;
    #10
    re_a = 1;
    addr_a = 48;
    #10
    re_a = 0;
    addr_a = 16;
    #50 $finish;
end

initial begin
    $dumpfile ("DPRAM.VCD");
    $dumpvars (0, DPRAM_tb);
end

endmodule