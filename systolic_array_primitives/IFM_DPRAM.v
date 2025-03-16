module IFM_DPRAM #(parameter ADDR_WIDTH = 19, ADDR_LINE = 519168, DATA_WIDTH = 8, NUM_BANKS = 16) (
    input                                       clk                        ,

    //Port A
    input      [NUM_BANKS              - 1]     we_a                       ,
    input      [ADDR_WIDTH             - 1 : 0] addr_a [0 : NUM_BANKS - 1] ,
    input      [DATA_WIDTH * NUM_BANKS - 1 : 0] din_a                      ,
    output reg [DATA_WIDTH * NUM_BANKS - 1 : 0] dout_a                     ,

    //Port B  
    input      [NUM_BANKS              - 1]     we_b                       ,
    input      [ADDR_WIDTH             - 1 : 0] addr_b [0 : NUM_BANKS - 1] ,
    input      [DATA_WIDTH * NUM_BANKS - 1 : 0] din_b                      ,
    output reg [DATA_WIDTH * NUM_BANKS - 1 : 0] dout_b                     ,
);

    genvar i;
    generate
        for (i = 0; i < NUM_BANKS; i = i + 1) begin
            DPRAM #(.ADDR_WIDTH (ADDR_WIDTH), .ADDR_LINE (ADDR_LINE), .DATA_WIDTH (DATA_WIDTH)) DPRAM_bank_inst (
                .clk    ( clk                                 ) ,

                .we_a   ( we_a   [i]                          ) ,
                .addr_a ( addr_a [i]                          ) ,
                .din_a  ( din_a  [i*DATA_WIDTH +: DATA_WIDTH] ) ,
                .dout_a ( dout_a [i*DATA_WIDTH +: DATA_WIDTH] ) ,

                .we_b   ( we_b   [i]                          ) ,
                .addr_b ( addr_b [i]                          ) ,
                .din_b  ( din_b  [i*DATA_WIDTH +: DATA_WIDTH] ) ,
                .dout_b ( dout_b [i*DATA_WIDTH +: DATA_WIDTH] )
            );
        end
    endgenerate


endmodule