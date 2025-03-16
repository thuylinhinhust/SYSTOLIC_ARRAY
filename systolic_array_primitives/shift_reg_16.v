module shift_reg_16 #(parameter DATA_WIDTH = 8, BUFFER_SIZE = 27, BUFFER_COUNT = 16) (
    input                                        clk      ,
    input                                        rst_n    ,
    input  [BUFFER_COUNT - 1 : 0]                in_valid ,
    input  [BUFFER_COUNT * DATA_WIDTH   - 1 : 0] data_in  ,
    output [BUFFER_COUNT * DATA_WIDTH   - 1 : 0] data_out
);
    genvar i;
    generate
        for (i = 0; i < BUFFER_COUNT; i = i + 1) begin
            shift_reg #(.DATA_WIDTH (DATA_WIDTH), .BUFFER_SIZE (BUFFER_SIZE + i)) shift_reg_inst (
                .clk      ( clk                                   ) ,
                .rst_n    ( rst_n                                 ) ,
                .in_valid ( in_valid [i*DATA_WIDTH +: DATA_WIDTH] ) ,
                .data_in  ( data_in  [i*DATA_WIDTH +: DATA_WIDTH] ) ,
                .data_out ( data_out [i*DATA_WIDTH +: DATA_WIDTH] )
            );
        end
    endgenerate

endmodule