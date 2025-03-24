module DPRAM #(parameter ADDR_WIDTH = 19, ADDR_LINE = 519168, DATA_WIDTH = 8, INOUT_WIDTH = 128) (
    input                            clk    ,
    input                            rst_n  ,

    //Port A: read
    input                            we_a       ,
    input      [ADDR_WIDTH  - 1 : 0] addr_a     ,
    input                            addr_valid ,
    input      [INOUT_WIDTH - 1 : 0] din_a      ,
    output reg [INOUT_WIDTH - 1 : 0] dout_a     ,

    //Port B
    input                            we_b   ,
    input      [ADDR_WIDTH  - 1 : 0] addr_b ,
    input      [INOUT_WIDTH - 1 : 0] din_b  ,
    output reg [INOUT_WIDTH - 1 : 0] dout_b
);  

    //507 KByte
    reg [DATA_WIDTH - 1 : 0] mem [0 : ADDR_LINE - 1];   //ADDR_LINE = 2^ADDR_WIDTH (2**ADDR_WIDTH), in this case = 416x416x3

    //Reset memory
    /*integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          dout_a <= 0;
          dout_b <= 0;
          for (i = 0; i < ADDR_LINE; i = i + 1)
            mem[i] <= {DATA_WIDTH{1'b0}};
        end
    end*/

    //Port A
    always @(posedge clk) begin
        if (we_a)
        //Write
            { mem[addr_a+15], mem[addr_a+14], mem[addr_a+13], mem[addr_a+12], mem[addr_a+11], mem[addr_a+10], 
              mem[addr_a+9] , mem[addr_a+8] , mem[addr_a+7] , mem[addr_a+6] , mem[addr_a+5] , mem[addr_a+4] ,  
              mem[addr_a+3] , mem[addr_a+2] , mem[addr_a+1] , mem[addr_a] } <= din_a;
        else
        //Synchronous Read
            dout_a <= (addr_valid) ? 
                      { mem[addr_a+15], mem[addr_a+14], mem[addr_a+13], mem[addr_a+12], mem[addr_a+11], mem[addr_a+10], 
                        mem[addr_a+9] , mem[addr_a+8] , mem[addr_a+7] , mem[addr_a+6] , mem[addr_a+5] , mem[addr_a+4] ,  
                        mem[addr_a+3] , mem[addr_a+2] , mem[addr_a+1] , mem[addr_a] } : 0;
    end
    
    //Port B
    always @(posedge clk) begin
        if (we_b)
        //Write
            { mem[addr_b+15], mem[addr_b+14], mem[addr_b+13], mem[addr_b+12], mem[addr_b+11], mem[addr_b+10], 
              mem[addr_b+9] , mem[addr_b+8] , mem[addr_b+7] , mem[addr_b+6] , mem[addr_b+5] , mem[addr_b+4] ,  
              mem[addr_b+3] , mem[addr_b+2] , mem[addr_b+1] , mem[addr_b] } <= din_b;
        else
        //Synchronous Read
            dout_b <= { mem[addr_b+15], mem[addr_b+14], mem[addr_b+13], mem[addr_b+12], mem[addr_b+11], mem[addr_b+10], 
                        mem[addr_b+9] , mem[addr_b+8] , mem[addr_b+7] , mem[addr_b+6] , mem[addr_b+5] , mem[addr_b+4] ,  
                        mem[addr_b+3] , mem[addr_b+2] , mem[addr_b+1] , mem[addr_b] };        
        end

endmodule