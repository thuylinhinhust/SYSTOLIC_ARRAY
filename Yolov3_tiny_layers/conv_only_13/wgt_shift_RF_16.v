module wgt_shift_RF_16 #(
    parameter DATA_WIDTH   = 8  , 
    parameter BUFFER_SIZE  = 27 , 
    parameter BUFFER_COUNT = 16
) (
    input                                      clk             ,
    input                                      rst_n           ,
    input                                      select_wgt      ,
    input  [BUFFER_COUNT              - 1 : 0] wgt_RF_shift_en ,
    input  [4:0]                               size            , 
    input  [BUFFER_COUNT * DATA_WIDTH - 1 : 0] data_in         ,
    output [BUFFER_COUNT * DATA_WIDTH - 1 : 0] data_out
);

    reg [BUFFER_COUNT * DATA_WIDTH - 1 : 0] wgt_data_in ;
    
    always @(size, data_in) begin
        case (size)
            5'd1:    wgt_data_in = {120'b0, data_in[7  :0]} ; 	
            5'd2:    wgt_data_in = {112'b0, data_in[15 :0]} ;	
            5'd3:    wgt_data_in = {104'b0, data_in[23 :0]} ;
            5'd4:    wgt_data_in = {96'b0 , data_in[31 :0]} ; 	
            5'd5:    wgt_data_in = {88'b0 , data_in[39 :0]} ;	
            5'd6:    wgt_data_in = {80'b0 , data_in[47 :0]} ;
            5'd7:    wgt_data_in = {72'b0 , data_in[55 :0]} ; 	
            5'd8:    wgt_data_in = {64'b0 , data_in[63 :0]} ;	
            5'd9:    wgt_data_in = {56'b0 , data_in[71 :0]} ;
            5'd10:   wgt_data_in = {48'b0 , data_in[79 :0]} ; 	
            5'd11:   wgt_data_in = {40'b0 , data_in[87 :0]} ;	
            5'd12:   wgt_data_in = {32'b0 , data_in[95 :0]} ;
            5'd13:   wgt_data_in = {24'b0 , data_in[103:0]} ; 	
            5'd14:   wgt_data_in = {16'b0 , data_in[111:0]} ;	
            5'd15:   wgt_data_in = {8'b0  , data_in[119:0]} ;
            5'd16:   wgt_data_in = data_in ;
            default: wgt_data_in = data_in ;	
        endcase
    end

    genvar i;
    generate
        for (i = 0; i < BUFFER_COUNT; i = i + 1) begin
            wgt_shift_RF #(.DATA_WIDTH (DATA_WIDTH), .BUFFER_SIZE (BUFFER_SIZE)) wgt_shift_RF_inst (
                .clk             ( clk                                        ) ,
                .rst_n           ( rst_n                                      ) ,
                .select_wgt      ( select_wgt                                 ) ,
                .wgt_RF_shift_en ( wgt_RF_shift_en[i]                         ) ,
                .data_in         ( wgt_data_in [i * DATA_WIDTH +: DATA_WIDTH] ) ,
                .data_out        ( data_out    [i * DATA_WIDTH +: DATA_WIDTH] )
            );
        end
    endgenerate

endmodule