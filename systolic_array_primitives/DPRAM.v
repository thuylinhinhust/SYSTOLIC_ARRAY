module DPRAM #(parameter ADDR_WIDTH = 19, ADDR_LINE = 519168, DATA_WIDTH = 8) (
    input                           clk    ,

    //Port A
    input                           we_a   ,
    input      [ADDR_WIDTH - 1 : 0] addr_a ,
    input      [DATA_WIDTH - 1 : 0] din_a  ,
    output reg [DATA_WIDTH - 1 : 0] dout_a ,

    //Port B
    input                           we_b   ,
    input      [ADDR_WIDTH - 1 : 0] addr_b ,
    input      [DATA_WIDTH - 1 : 0] din_b  ,
    output reg [DATA_WIDTH - 1 : 0] dout_b ,
);  

    reg [DATA_WIDTH - 1 : 0] mem [0 : ADDR_LINE - 1];   //ADDR_LINE = 2^ADDR_WIDTH (2**ADDR_WIDTH), in this case = 416x416x3

    //Port A
    always @(posedge clk) begin
        if (we_a)
            mem [addr_a] <= din_a;          //Write
        else
            dout_a       <= mem [addr_a];   //Synchronous Read
    end
    
    //Port B
    always @(posedge clk) begin
        if (we_b)
            mem [addr_b] <= din_b;
        else
            dout_b       <= mem [addr_b];
        end

endmodule