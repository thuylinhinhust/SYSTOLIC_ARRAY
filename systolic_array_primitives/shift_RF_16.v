module shift_RF_16 #(parameter DATA_WIDTH = 8, BUFFER_SIZE = 27, BUFFER_COUNT = 16) (
    input                                      clk     ,
    input                                      rst_n   ,
    input                                      read_en ,
    input  [BUFFER_COUNT * DATA_WIDTH - 1 : 0] data_in ,
    output [BUFFER_COUNT * DATA_WIDTH - 1 : 0] data_out
);

    genvar i;
    generate
        for (i = 0; i < BUFFER_COUNT; i = i + 1) begin
            shift_RF #(.DATA_WIDTH (DATA_WIDTH), .BUFFER_SIZE (BUFFER_SIZE + i)) shift_RF_inst (
                .clk      ( clk                                     ) ,
                .rst_n    ( rst_n                                   ) ,
                .read_en  (read_en                                  ) ,
                .data_in  ( data_in  [i * DATA_WIDTH +: DATA_WIDTH] ) ,
                .data_out ( data_out [i * DATA_WIDTH +: DATA_WIDTH] )
            );
        end
    endgenerate

endmodule