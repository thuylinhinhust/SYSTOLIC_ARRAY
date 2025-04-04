module ifm_shift_RF_16 #(parameter DATA_WIDTH = 8, BUFFER_SIZE = 27, BUFFER_COUNT = 16) (
    input                                      clk               ,
    input                                      rst_n             ,
    input                                      ifm_demux         ,
	input                                      ifm_mux           ,
    input                                      ifm_RF_shift_en_1 ,
    input                                      ifm_RF_shift_en_2 ,    
    input  [BUFFER_COUNT * DATA_WIDTH - 1 : 0] data_in           ,
    output [BUFFER_COUNT * DATA_WIDTH - 1 : 0] data_out
);

    genvar i;
    generate
        for (i = 0; i < BUFFER_COUNT; i = i + 1) begin
            ifm_shift_RF #(.DATA_WIDTH (DATA_WIDTH), .BUFFER_SIZE (BUFFER_SIZE + i)) ifm_shift_RF_inst (
                .clk               ( clk                                     ) ,
                .rst_n             ( rst_n                                   ) ,
                .ifm_demux         ( ifm_demux                               ) ,
                .ifm_mux           ( ifm_mux                                 ) ,
                .ifm_RF_shift_en_1 ( ifm_RF_shift_en_1                       ) ,
                .ifm_RF_shift_en_2 ( ifm_RF_shift_en_2                       ) ,
                .data_in           ( data_in  [i * DATA_WIDTH +: DATA_WIDTH] ) ,
                .data_out          ( data_out [i * DATA_WIDTH +: DATA_WIDTH] )
            );
        end
    endgenerate

endmodule