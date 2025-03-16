module PE_array #(parameter DATA_WIDTH = 8, SYSTOLIC_SIZE = 16) (
    input                                         clk             ,
    input                                         rst_n           ,
    input  [(SYSTOLIC_SIZE - 1) * 2 : 0]          set_reg_compute ,
    input  [SYSTOLIC_SIZE - 2 : 0]                set_reg_write   ,
    input                                         ofm_write_en    ,
    input                                         psum_down_en    ,
    input  [SYSTOLIC_SIZE * DATA_WIDTH   - 1 : 0] top_in          ,
    input  [SYSTOLIC_SIZE * DATA_WIDTH   - 1 : 0] left_in         ,
    output [SYSTOLIC_SIZE * DATA_WIDTH*2 - 1 : 0] result
);
    wire [SYSTOLIC_SIZE * SYSTOLIC_SIZE * DATA_WIDTH   - 1 : 0] right_out  ;  
    wire [SYSTOLIC_SIZE * SYSTOLIC_SIZE * DATA_WIDTH   - 1 : 0] bottom_out ;
    wire [SYSTOLIC_SIZE * SYSTOLIC_SIZE * DATA_WIDTH*2 - 1 : 0] psum_in    ;
    wire [SYSTOLIC_SIZE * SYSTOLIC_SIZE * DATA_WIDTH*2 - 1 : 0] psum_out   ;

    genvar i, j;
    generate
        for (i = 0; i < SYSTOLIC_SIZE; i = i + 1) begin : row
            for (j = 0; j < SYSTOLIC_SIZE; j = j + 1) begin : col
                PE #(.DATA_WIDTH (DATA_WIDTH)) pe_inst (
                    .clk          ( clk                                                                                                                 ) ,
                    .rst_n        ( rst_n                                                                                                               ) ,
                    .set_reg      ( (i == 0) ? set_reg_compute [j] : ( (ofm_write_en) ? set_reg_write [i-1] : set_reg_compute [i+j] )                   ) ,
                    .psum_down_en ( psum_down_en                                                                                                        ) , 
                    .top_in       ( (i == 0) ? top_in  [j*DATA_WIDTH +: DATA_WIDTH] : bottom_out [((i-1)*SYSTOLIC_SIZE + j) * DATA_WIDTH +: DATA_WIDTH] ) ,
                    .left_in      ( (j == 0) ? left_in [i*DATA_WIDTH +: DATA_WIDTH] : right_out  [(i*SYSTOLIC_SIZE + (j-1)) * DATA_WIDTH +: DATA_WIDTH] ) ,
                    .psum_in      ( (i == 0) ? 16'b0 : psum_out [((i-1)*SYSTOLIC_SIZE + j) * DATA_WIDTH*2 +: DATA_WIDTH*2]                              ) ,
                    .bottom_out   ( bottom_out [(i*SYSTOLIC_SIZE + j) * DATA_WIDTH +: DATA_WIDTH]                                                       ) ,
                    .right_out    ( right_out  [(i*SYSTOLIC_SIZE + j) * DATA_WIDTH +: DATA_WIDTH]                                                       ) ,
                    .psum_out     ( psum_out   [(i*SYSTOLIC_SIZE + j) * DATA_WIDTH*2 +: DATA_WIDTH*2]                                                   )
                );
            end
        end
    endgenerate

    generate
        for (i = 0; i < SYSTOLIC_SIZE; i = i + 1) begin
            assign result [i] = psum_out [( (SYSTOLIC_SIZE - 1) * SYSTOLIC_SIZE + i) * DATA_WIDTH*2 +: DATA_WIDTH*2];
        end
    endgenerate

endmodule