module systolic_array_16x16 #(parameter DATA_WIDTH = 8, ARRAY_SIZE = 16) (
    input clk,
    input rst_n,
    input [ARRAY_SIZE * DATA_WIDTH - 1 : 0] top_in,  
    input [ARRAY_SIZE * DATA_WIDTH - 1 : 0] left_in,
    output reg [ARRAY_SIZE * ARRAY_SIZE * DATA_WIDTH*2 - 1 : 0] result
);
    wire [ARRAY_SIZE * ARRAY_SIZE * DATA_WIDTH - 1 : 0] right_out;  
    wire [ARRAY_SIZE * ARRAY_SIZE * DATA_WIDTH - 1 : 0] bottom_out;

    genvar i, j;
    generate
        for (i = 0; i < ARRAY_SIZE; i = i + 1) begin : row
            for (j = 0; j < ARRAY_SIZE; j = j + 1) begin : col
                PE #(.DATA_WIDTH(DATA_WIDTH)) pe_inst (
                    .clk(clk),
                    .rst_n(rst_n),
                    .top_in((i == 0) ? top_in[j*DATA_WIDTH +: DATA_WIDTH] : bottom_out[((i-1)*ARRAY_SIZE + j) * DATA_WIDTH +: DATA_WIDTH]),  
                    .left_in((j == 0) ? left_in[i*DATA_WIDTH +: DATA_WIDTH] : right_out[(i*ARRAY_SIZE + (j-1)) * DATA_WIDTH +: DATA_WIDTH]),  
                    .right_out(right_out[(i*ARRAY_SIZE + j) * DATA_WIDTH +: DATA_WIDTH]),  
                    .bottom_out(bottom_out[(i*ARRAY_SIZE + j) * DATA_WIDTH +: DATA_WIDTH]),  
                    .result(result[(i*ARRAY_SIZE + j) * DATA_WIDTH*2 +: DATA_WIDTH*2])  
                );
            end
        end
    endgenerate

endmodule