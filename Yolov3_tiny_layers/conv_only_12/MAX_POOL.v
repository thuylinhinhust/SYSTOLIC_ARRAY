module MAX_POOL #(
    parameter DATA_WIDTH = 8
) (
    input  [DATA_WIDTH*2 - 1 : 0] data_in_1, 
    input  [DATA_WIDTH*2 - 1 : 0] data_in_2, 
    output [DATA_WIDTH*2 - 1 : 0] data_out  
);

    assign data_out = ($signed(data_in_1) > $signed(data_in_2)) ? data_in_1 : data_in_2;

endmodule