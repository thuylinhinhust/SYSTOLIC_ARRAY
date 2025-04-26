module FIFO_tb ();

parameter DATA_WIDTH = 8  ;
parameter FIFO_SIZE  = 16 ;
parameter ADDR_WIDTH = 5  ;

reg                         clk           ;
reg                         rd_clr        ;
reg                         wr_clr        ;
reg                         rd_en         ;
reg                         wr_en         ;
wire [DATA_WIDTH*2 - 1 : 0] data_in_fifo  ;
wire [DATA_WIDTH*2 - 1 : 0] data_out_fifo ;

FIFO #(.DATA_WIDTH(DATA_WIDTH), .FIFO_SIZE(FIFO_SIZE), .ADDR_WIDTH(ADDR_WIDTH)
) dut (
    .clk           ( clk           ) ,
    .rd_clr        ( rd_clr        ) ,
    .wr_clr        ( wr_clr        ) ,
    .rd_inc        ( 1'b1          ) ,
    .wr_inc        ( 1'b1          ) ,
    .rd_en         ( rd_en         ) ,
    .wr_en         ( wr_en         ) ,
    .data_in_fifo  ( data_in_fifo  ) ,
    .data_out_fifo ( data_out_fifo )
);

always #5 clk = ~clk;

initial begin
    dut.fifo_data [0] = 16'd1;
    dut.fifo_data [1] = 16'd2;
    dut.fifo_data [2] = 16'd3;
    dut.fifo_data [3] = 16'd4;
    dut.fifo_data [4] = 16'd5;
    dut.fifo_data [5] = 16'd6;
    dut.fifo_data [6] = 16'd7;
    dut.fifo_data [7] = 16'd8;
    dut.fifo_data [8] = 16'd9;
    dut.fifo_data [9] = 16'd10;
    dut.fifo_data [10] = 16'd11;
    dut.fifo_data [11] = 16'd12;
    dut.fifo_data [12] = 16'd13;
    dut.fifo_data [13] = 16'd14;
    dut.fifo_data [14] = 16'd15;
    dut.fifo_data [15] = 16'd16;

    clk = 0;
    rd_clr = 1;
    wr_clr = 1;
    rd_en = 0;
    wr_en = 0;
    #10 
    rd_clr = 0;
    rd_en = 1;
    #50
    rd_clr = 1;
    rd_en = 0;
    #50 $finish;
end

initial begin
    $dumpfile ("FIFO.VCD");
    $dumpvars (0, FIFO_tb);
end

endmodule