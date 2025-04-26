module systolic_array_16x16 #(parameter DATA_WIDTH = 8, SIZE = 16) (
    input clk,
    input rst_n,
    input [SIZE * DATA_WIDTH - 1 : 0] top_in,  
    input [SIZE * DATA_WIDTH - 1 : 0] left_in,
    input [7 : 0] sel,
    output reg [DATA_WIDTH*2 - 1 : 0] result_out
);

    wire [SIZE * SIZE * DATA_WIDTH - 1 : 0] right_out;  
    wire [SIZE * SIZE * DATA_WIDTH - 1 : 0] bottom_out;
    wire [SIZE * SIZE * DATA_WIDTH*2 - 1 : 0] result; 

    genvar i, j;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : row
            for (j = 0; j < SIZE; j = j + 1) begin : col
                PE #(.DATA_WIDTH(DATA_WIDTH)) pe_inst (
                    .clk(clk),
                    .rst_n(rst_n),
                    .top_in((i == 0) ? top_in[j*DATA_WIDTH +: DATA_WIDTH] : bottom_out[((i-1)*SIZE + j) * DATA_WIDTH +: DATA_WIDTH]),  
                    .left_in((j == 0) ? left_in[i*DATA_WIDTH +: DATA_WIDTH] : right_out[(i*SIZE + (j-1)) * DATA_WIDTH +: DATA_WIDTH]),  
                    .right_out(right_out[(i*SIZE + j) * DATA_WIDTH +: DATA_WIDTH]),  
                    .bottom_out(bottom_out[(i*SIZE + j) * DATA_WIDTH +: DATA_WIDTH]),  
                    .result(result[(i*SIZE + j) * DATA_WIDTH*2 +: DATA_WIDTH*2])  
                );
            end
        end
    endgenerate

    always @(sel, result) begin
        if (sel < SIZE * SIZE)
            result_out = result[(sel * DATA_WIDTH*2) +: DATA_WIDTH*2];  
        else 
            result_out = 0;
    end

endmodule