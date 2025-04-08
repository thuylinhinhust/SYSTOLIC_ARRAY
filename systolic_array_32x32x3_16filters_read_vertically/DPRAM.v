module DPRAM #(
    parameter ADDR_WIDTH  = 19     , 
    parameter ADDR_LINE   = 519168 , 
    parameter DATA_WIDTH  = 8      , 
    parameter INOUT_WIDTH = 128
) (
    input                            clk    ,
    input [4:0]                      size   ,

    //Port A: read
    input                            re_a   ,
    input      [ADDR_WIDTH  - 1 : 0] addr_a ,
    output reg [INOUT_WIDTH - 1 : 0] dout_a ,

    //Port B: write
    input                            we_b   ,
    input      [ADDR_WIDTH  - 1 : 0] addr_b ,
    input      [INOUT_WIDTH - 1 : 0] din_b  
);  

    //507 KByte
    reg [DATA_WIDTH - 1 : 0] mem [0 : ADDR_LINE - 1];   //ADDR_LINE = 2^ADDR_WIDTH (2**ADDR_WIDTH), in this case = 416x416x3

    //Port A: read
    always @(posedge clk) begin
        if (re_a)
            dout_a <= { mem[addr_a+15], mem[addr_a+14], mem[addr_a+13], mem[addr_a+12], mem[addr_a+11], mem[addr_a+10], 
                        mem[addr_a+9] , mem[addr_a+8] , mem[addr_a+7] , mem[addr_a+6] , mem[addr_a+5] , mem[addr_a+4] ,  
                        mem[addr_a+3] , mem[addr_a+2] , mem[addr_a+1] , mem[addr_a] };
        else
            dout_a <= 0;
    end
    
    //Port B: write
    always @(posedge clk) begin
        if (we_b) begin
            case (size)
                5'd1:     mem[addr_b] <= din_b;
                5'd2:    {mem[addr_b+1] , mem[addr_b]} <= din_b;
                5'd3:    {mem[addr_b+2] , mem[addr_b+1] , mem[addr_b]} <= din_b;
                5'd4:    {mem[addr_b+3] , mem[addr_b+2] , mem[addr_b+1] , mem[addr_b]} <= din_b;
                5'd5:    {mem[addr_b+4] , mem[addr_b+3] , mem[addr_b+2] , mem[addr_b+1] , mem[addr_b]} <= din_b;
                5'd6:    {mem[addr_b+5] , mem[addr_b+4] , mem[addr_b+3] , mem[addr_b+2] , mem[addr_b+1] , mem[addr_b]} <= din_b;
                5'd7:    {mem[addr_b+6] , mem[addr_b+5] , mem[addr_b+4] , mem[addr_b+3] , mem[addr_b+2] , mem[addr_b+1] , mem[addr_b]} <= din_b;
                5'd8:    {mem[addr_b+7] , mem[addr_b+6] , mem[addr_b+5] , mem[addr_b+4] , mem[addr_b+3] , mem[addr_b+2] , mem[addr_b+1], mem[addr_b]} <= din_b;
                5'd9:    {mem[addr_b+8] , mem[addr_b+7] , mem[addr_b+6] , mem[addr_b+5] , mem[addr_b+4] , mem[addr_b+3] , mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
                5'd10:   {mem[addr_b+9] , mem[addr_b+8] , mem[addr_b+7] , mem[addr_b+6] , mem[addr_b+5] , mem[addr_b+4] , mem[addr_b+3], mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
                5'd11:   {mem[addr_b+10], mem[addr_b+9] , mem[addr_b+8] , mem[addr_b+7] , mem[addr_b+6] , mem[addr_b+5] , mem[addr_b+4], mem[addr_b+3], mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
                5'd12:   {mem[addr_b+11], mem[addr_b+10], mem[addr_b+9] , mem[addr_b+8] , mem[addr_b+7] , mem[addr_b+6] , mem[addr_b+5], mem[addr_b+4], mem[addr_b+3], mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
                5'd13:   {mem[addr_b+12], mem[addr_b+11], mem[addr_b+10], mem[addr_b+9] , mem[addr_b+8] , mem[addr_b+7] , mem[addr_b+6], mem[addr_b+5], mem[addr_b+4], mem[addr_b+3], mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
                5'd14:   {mem[addr_b+13], mem[addr_b+12], mem[addr_b+11], mem[addr_b+10], mem[addr_b+9] , mem[addr_b+8] , mem[addr_b+7], mem[addr_b+6], mem[addr_b+5], mem[addr_b+4], mem[addr_b+3], mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
                5'd15:   {mem[addr_b+14], mem[addr_b+13], mem[addr_b+12], mem[addr_b+11], mem[addr_b+10], mem[addr_b+9] , mem[addr_b+8], mem[addr_b+7], mem[addr_b+6], mem[addr_b+5], mem[addr_b+4], mem[addr_b+3], mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
                5'd16:   {mem[addr_b+15], mem[addr_b+14], mem[addr_b+13], mem[addr_b+12], mem[addr_b+11], mem[addr_b+10], mem[addr_b+9], mem[addr_b+8], mem[addr_b+7], mem[addr_b+6], mem[addr_b+5], mem[addr_b+4], mem[addr_b+3], mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
                default: {mem[addr_b+15], mem[addr_b+14], mem[addr_b+13], mem[addr_b+12], mem[addr_b+11], mem[addr_b+10], mem[addr_b+9], mem[addr_b+8], mem[addr_b+7], mem[addr_b+6], mem[addr_b+5], mem[addr_b+4], mem[addr_b+3], mem[addr_b+2], mem[addr_b+1], mem[addr_b]} <= din_b;
            endcase
        end 
    end

endmodule