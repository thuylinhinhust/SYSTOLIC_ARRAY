module wgt_shift_RF_tb();

parameter DATA_WIDTH  = 8  ;
parameter BUFFER_SIZE = 27 ;

reg                       clk             ;
reg                       rst_n           ;
reg                       select_wgt      ;
reg                       wgt_RF_shift_en ;
reg  [DATA_WIDTH - 1 : 0] data_in         ;
wire [DATA_WIDTH - 1 : 0] data_out        ;

wgt_shift_RF #(
    .DATA_WIDTH  ( DATA_WIDTH  ) ,
    .BUFFER_SIZE ( BUFFER_SIZE )
) wgt_shift_RF_dut ( 
    .clk             ( clk             ) ,
    .rst_n           ( rst_n           ) ,
    .select_wgt      ( select_wgt      ) ,
    .wgt_RF_shift_en ( wgt_RF_shift_en ) ,
    .data_in         ( data_in         ) ,
    .data_out        ( data_out        )
);

always #5 clk = ~clk;

integer i;

initial begin
    clk = 0;
    rst_n = 0;
    select_wgt = 1;
    wgt_RF_shift_en = 1;
    data_in = 1;

    #30 rst_n = 1; 
    
    for (i = 2; i < 29; i = i + 1) begin
        data_in = i;
        #10;
    end
    
    #50
    wgt_RF_shift_en = 0;

    for (i = 30; i < 33; i = i + 1) begin
        data_in = i;
        #10;
    end

    #50
    wgt_RF_shift_en = 1;
    select_wgt = 0;

    #10
    
    for (i = 40; i < 33; i = i + 1) begin
        data_in = i;
        #10;
    end

    #500 $finish;
end

initial begin
    $dumpfile ("wgt_shift_RF.VCD");
    $dumpvars (0, wgt_shift_RF_tb);
    $dumpvars (0, wgt_shift_RF_dut.buffer[0]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[1]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[2]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[3]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[4]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[5]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[6]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[7]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[8]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[9]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[10]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[11]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[12]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[13]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[14]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[15]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[16]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[17]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[18]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[19]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[20]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[21]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[22]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[23]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[24]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[25]);
    $dumpvars (0, wgt_shift_RF_dut.buffer[26]);
end

endmodule