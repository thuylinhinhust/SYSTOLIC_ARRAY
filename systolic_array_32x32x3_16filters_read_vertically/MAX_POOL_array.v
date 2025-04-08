module MAX_POOL_array #(
    parameter DATA_WIDTH    = 8  ,
    parameter SYSTOLIC_SIZE = 16 ,
    parameter NUM_MODULES   = 8
) (
    input  [DATA_WIDTH*2 * SYSTOLIC_SIZE     - 1 : 0] data_in,
    output [DATA_WIDTH*2 * (SYSTOLIC_SIZE/2) - 1 : 0] data_out
);

    genvar i;
    generate
        for (i = 0; i < NUM_MODULES; i = i + 1) begin : max_pooling
            MAX_POOL #(.DATA_WIDTH (DATA_WIDTH)) u_max_pooling (
                .data_in_1 ( data_in [(2*i)  * DATA_WIDTH*2 +: DATA_WIDTH*2] ) ,
                .data_in_2 ( data_in [(2*i+1)* DATA_WIDTH*2 +: DATA_WIDTH*2] ) ,
                .data_out  ( data_out[ i     * DATA_WIDTH*2 +: DATA_WIDTH*2] )
            );
        end
    endgenerate
endmodule