module ifm_shift_RF_tb();

parameter DATA_WIDTH  = 8 ;
parameter BUFFER_SIZE = 5 ;

reg                       clk               ;
reg                       rst_n             ;
reg                       ifm_demux         ;
reg                       ifm_mux           ;
reg                       ifm_RF_shift_en_1 ;
reg                       ifm_RF_shift_en_2 ;
reg  [DATA_WIDTH - 1 : 0] data_in           ;
wire [DATA_WIDTH - 1 : 0] data_out          ;

ifm_shift_RF #(
    .DATA_WIDTH  ( DATA_WIDTH  ) ,
    .BUFFER_SIZE ( BUFFER_SIZE )
) ifm_shift_RF_dut ( 
    .clk               ( clk               ) ,
    .rst_n             ( rst_n             ) ,
    .ifm_demux         ( ifm_demux         ) ,
    .ifm_mux           ( ifm_mux           ) ,
    .ifm_RF_shift_en_1 ( ifm_RF_shift_en_1 ) ,
    .ifm_RF_shift_en_2 ( ifm_RF_shift_en_2 ) ,
    .data_in           ( data_in           ) ,
    .data_out          ( data_out          )
);

always #5 clk = ~clk;

integer i;

initial begin
    clk = 0;
    rst_n = 0;
    
    ifm_demux = 0;
    ifm_mux = 1;
    ifm_RF_shift_en_1 = 1;
    ifm_RF_shift_en_2 = 1;

    data_in = 1;

    #30 rst_n = 1; 
    
    for (i = 2; i < 7; i = i + 1) begin
        data_in = i;
        #10;
    end

    #10 
    ifm_demux = 1;
    ifm_mux = 0;

    #30 ifm_RF_shift_en_1 = 0;

    for (i = 12; i < 17; i = i + 1) begin
        data_in = i;
        #10;
    end

    #20 
    ifm_RF_shift_en_1 = 1;
    ifm_RF_shift_en_2 = 0;

    for (i = 22; i < 27; i = i + 1) begin
        data_in = i;
        #10;
    end

    ifm_RF_shift_en_1 = 1;
    ifm_RF_shift_en_2 = 1;

    for (i = 30; i < 33; i = i + 1) begin
        data_in = i;
        #10;
    end

    #500 $finish;
end

initial begin
    $dumpfile ("ifm_shift_RF.VCD");
    $dumpvars (0, ifm_shift_RF_tb);

    $dumpvars (0, ifm_shift_RF_dut.buffer_1[0]);
    $dumpvars (0, ifm_shift_RF_dut.buffer_1[1]);
    $dumpvars (0, ifm_shift_RF_dut.buffer_1[2]);
    $dumpvars (0, ifm_shift_RF_dut.buffer_1[3]);
    $dumpvars (0, ifm_shift_RF_dut.buffer_1[4]);

    $dumpvars (0, ifm_shift_RF_dut.buffer_2[0]);
    $dumpvars (0, ifm_shift_RF_dut.buffer_2[1]);
    $dumpvars (0, ifm_shift_RF_dut.buffer_2[2]);
    $dumpvars (0, ifm_shift_RF_dut.buffer_2[3]);
    $dumpvars (0, ifm_shift_RF_dut.buffer_2[4]);

/*  $dumpvars (0, wgt_shift_RF_dut.buffer[5]);
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
    $dumpvars (0, wgt_shift_RF_dut.buffer[26]);*/
end

endmodule