module DPRAM #(
    parameter ADDR_WIDTH    = 19     , 
    parameter ADDR_LINE     = 519168 , 
    parameter DATA_WIDTH    = 8      , 
    parameter INOUT_WIDTH   = 128    ,
    parameter UPSAMPLE_MODE = 1      ,
    parameter OFM_SIZE      = 26
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
            if (UPSAMPLE_MODE == 1) begin
                case (size)
                    5'd1: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                    end
                    5'd2: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                    end
                    5'd3: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                    end
                    5'd4: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                    end
                    5'd5: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                    end
                    5'd6: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                    end
                    5'd7: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                    end
                    5'd8: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                    end
                    5'd9: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                        mem[addr_b+16]          <= din_b[143:128]; mem[addr_b+17]          <= din_b[143:128]; 
                        mem[addr_b+OFM_SIZE+16] <= din_b[143:128]; mem[addr_b+OFM_SIZE+17] <= din_b[143:128];
                    end
                    5'd10: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                        mem[addr_b+16]          <= din_b[143:128]; mem[addr_b+17]          <= din_b[143:128]; 
                        mem[addr_b+OFM_SIZE+16] <= din_b[143:128]; mem[addr_b+OFM_SIZE+17] <= din_b[143:128];
                        mem[addr_b+18]          <= din_b[159:144]; mem[addr_b+19]          <= din_b[159:144]; 
                        mem[addr_b+OFM_SIZE+18] <= din_b[159:144]; mem[addr_b+OFM_SIZE+19] <= din_b[159:144];
                    end
                    5'd11: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                        mem[addr_b+16]          <= din_b[143:128]; mem[addr_b+17]          <= din_b[143:128]; 
                        mem[addr_b+OFM_SIZE+16] <= din_b[143:128]; mem[addr_b+OFM_SIZE+17] <= din_b[143:128];
                        mem[addr_b+18]          <= din_b[159:144]; mem[addr_b+19]          <= din_b[159:144]; 
                        mem[addr_b+OFM_SIZE+18] <= din_b[159:144]; mem[addr_b+OFM_SIZE+19] <= din_b[159:144];
                        mem[addr_b+20]          <= din_b[175:160]; mem[addr_b+21]          <= din_b[175:160]; 
                        mem[addr_b+OFM_SIZE+20] <= din_b[175:160]; mem[addr_b+OFM_SIZE+21] <= din_b[175:160];
                    end
                    5'd12: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                        mem[addr_b+16]          <= din_b[143:128]; mem[addr_b+17]          <= din_b[143:128]; 
                        mem[addr_b+OFM_SIZE+16] <= din_b[143:128]; mem[addr_b+OFM_SIZE+17] <= din_b[143:128];
                        mem[addr_b+18]          <= din_b[159:144]; mem[addr_b+19]          <= din_b[159:144]; 
                        mem[addr_b+OFM_SIZE+18] <= din_b[159:144]; mem[addr_b+OFM_SIZE+19] <= din_b[159:144];
                        mem[addr_b+20]          <= din_b[175:160]; mem[addr_b+21]          <= din_b[175:160]; 
                        mem[addr_b+OFM_SIZE+20] <= din_b[175:160]; mem[addr_b+OFM_SIZE+21] <= din_b[175:160];
                        mem[addr_b+22]          <= din_b[191:176]; mem[addr_b+23]          <= din_b[191:176]; 
                        mem[addr_b+OFM_SIZE+22] <= din_b[191:176]; mem[addr_b+OFM_SIZE+23] <= din_b[191:176];
                    end
                    5'd13: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                        mem[addr_b+16]          <= din_b[143:128]; mem[addr_b+17]          <= din_b[143:128]; 
                        mem[addr_b+OFM_SIZE+16] <= din_b[143:128]; mem[addr_b+OFM_SIZE+17] <= din_b[143:128];
                        mem[addr_b+18]          <= din_b[159:144]; mem[addr_b+19]          <= din_b[159:144]; 
                        mem[addr_b+OFM_SIZE+18] <= din_b[159:144]; mem[addr_b+OFM_SIZE+19] <= din_b[159:144];
                        mem[addr_b+20]          <= din_b[175:160]; mem[addr_b+21]          <= din_b[175:160]; 
                        mem[addr_b+OFM_SIZE+20] <= din_b[175:160]; mem[addr_b+OFM_SIZE+21] <= din_b[175:160];
                        mem[addr_b+22]          <= din_b[191:176]; mem[addr_b+23]          <= din_b[191:176]; 
                        mem[addr_b+OFM_SIZE+22] <= din_b[191:176]; mem[addr_b+OFM_SIZE+23] <= din_b[191:176];
                        mem[addr_b+24]          <= din_b[207:192]; mem[addr_b+25]          <= din_b[207:192]; 
                        mem[addr_b+OFM_SIZE+24] <= din_b[207:192]; mem[addr_b+OFM_SIZE+25] <= din_b[207:192];
                    end
                    5'd14: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                        mem[addr_b+16]          <= din_b[143:128]; mem[addr_b+17]          <= din_b[143:128]; 
                        mem[addr_b+OFM_SIZE+16] <= din_b[143:128]; mem[addr_b+OFM_SIZE+17] <= din_b[143:128];
                        mem[addr_b+18]          <= din_b[159:144]; mem[addr_b+19]          <= din_b[159:144]; 
                        mem[addr_b+OFM_SIZE+18] <= din_b[159:144]; mem[addr_b+OFM_SIZE+19] <= din_b[159:144];
                        mem[addr_b+20]          <= din_b[175:160]; mem[addr_b+21]          <= din_b[175:160]; 
                        mem[addr_b+OFM_SIZE+20] <= din_b[175:160]; mem[addr_b+OFM_SIZE+21] <= din_b[175:160];
                        mem[addr_b+22]          <= din_b[191:176]; mem[addr_b+23]          <= din_b[191:176]; 
                        mem[addr_b+OFM_SIZE+22] <= din_b[191:176]; mem[addr_b+OFM_SIZE+23] <= din_b[191:176];
                        mem[addr_b+24]          <= din_b[207:192]; mem[addr_b+25]          <= din_b[207:192]; 
                        mem[addr_b+OFM_SIZE+24] <= din_b[207:192]; mem[addr_b+OFM_SIZE+25] <= din_b[207:192];
                        mem[addr_b+26]          <= din_b[223:208]; mem[addr_b+27]          <= din_b[223:208]; 
                        mem[addr_b+OFM_SIZE+26] <= din_b[223:208]; mem[addr_b+OFM_SIZE+27] <= din_b[223:208];
                    end
                    5'd15: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                        mem[addr_b+16]          <= din_b[143:128]; mem[addr_b+17]          <= din_b[143:128]; 
                        mem[addr_b+OFM_SIZE+16] <= din_b[143:128]; mem[addr_b+OFM_SIZE+17] <= din_b[143:128];
                        mem[addr_b+18]          <= din_b[159:144]; mem[addr_b+19]          <= din_b[159:144]; 
                        mem[addr_b+OFM_SIZE+18] <= din_b[159:144]; mem[addr_b+OFM_SIZE+19] <= din_b[159:144];
                        mem[addr_b+20]          <= din_b[175:160]; mem[addr_b+21]          <= din_b[175:160]; 
                        mem[addr_b+OFM_SIZE+20] <= din_b[175:160]; mem[addr_b+OFM_SIZE+21] <= din_b[175:160];
                        mem[addr_b+22]          <= din_b[191:176]; mem[addr_b+23]          <= din_b[191:176]; 
                        mem[addr_b+OFM_SIZE+22] <= din_b[191:176]; mem[addr_b+OFM_SIZE+23] <= din_b[191:176];
                        mem[addr_b+24]          <= din_b[207:192]; mem[addr_b+25]          <= din_b[207:192]; 
                        mem[addr_b+OFM_SIZE+24] <= din_b[207:192]; mem[addr_b+OFM_SIZE+25] <= din_b[207:192];
                        mem[addr_b+26]          <= din_b[223:208]; mem[addr_b+27]          <= din_b[223:208]; 
                        mem[addr_b+OFM_SIZE+26] <= din_b[223:208]; mem[addr_b+OFM_SIZE+27] <= din_b[223:208];
                        mem[addr_b+28]          <= din_b[239:224]; mem[addr_b+29]          <= din_b[239:224]; 
                        mem[addr_b+OFM_SIZE+28] <= din_b[239:224]; mem[addr_b+OFM_SIZE+29] <= din_b[239:224];
                    end
                    5'd16: begin
                        mem[addr_b]             <= din_b[15:0];    mem[addr_b+1]           <= din_b[15:0]; 
                        mem[addr_b+OFM_SIZE]    <= din_b[15:0];    mem[addr_b+OFM_SIZE+1]  <= din_b[15:0];
                        mem[addr_b+2]           <= din_b[31:16];   mem[addr_b+3]           <= din_b[31:16]; 
                        mem[addr_b+OFM_SIZE+2]  <= din_b[31:16];   mem[addr_b+OFM_SIZE+3]  <= din_b[31:16];
                        mem[addr_b+4]           <= din_b[47:32];   mem[addr_b+5]           <= din_b[47:32]; 
                        mem[addr_b+OFM_SIZE+4]  <= din_b[47:32];   mem[addr_b+OFM_SIZE+5]  <= din_b[47:32];
                        mem[addr_b+6]           <= din_b[63:48];   mem[addr_b+7]           <= din_b[63:48]; 
                        mem[addr_b+OFM_SIZE+6]  <= din_b[63:48];   mem[addr_b+OFM_SIZE+7]  <= din_b[63:48];
                        mem[addr_b+8]           <= din_b[79:64];   mem[addr_b+9]           <= din_b[79:64]; 
                        mem[addr_b+OFM_SIZE+8]  <= din_b[79:64];   mem[addr_b+OFM_SIZE+9]  <= din_b[79:64];
                        mem[addr_b+10]          <= din_b[95:80];   mem[addr_b+11]          <= din_b[95:80]; 
                        mem[addr_b+OFM_SIZE+10] <= din_b[95:80];   mem[addr_b+OFM_SIZE+11] <= din_b[95:80];
                        mem[addr_b+12]          <= din_b[111:96];  mem[addr_b+13]          <= din_b[111:96]; 
                        mem[addr_b+OFM_SIZE+12] <= din_b[111:96];  mem[addr_b+OFM_SIZE+13] <= din_b[111:96];
                        mem[addr_b+14]          <= din_b[127:112]; mem[addr_b+15]          <= din_b[127:112]; 
                        mem[addr_b+OFM_SIZE+14] <= din_b[127:112]; mem[addr_b+OFM_SIZE+15] <= din_b[127:112];
                        mem[addr_b+16]          <= din_b[143:128]; mem[addr_b+17]          <= din_b[143:128]; 
                        mem[addr_b+OFM_SIZE+16] <= din_b[143:128]; mem[addr_b+OFM_SIZE+17] <= din_b[143:128];
                        mem[addr_b+18]          <= din_b[159:144]; mem[addr_b+19]          <= din_b[159:144]; 
                        mem[addr_b+OFM_SIZE+18] <= din_b[159:144]; mem[addr_b+OFM_SIZE+19] <= din_b[159:144];
                        mem[addr_b+20]          <= din_b[175:160]; mem[addr_b+21]          <= din_b[175:160]; 
                        mem[addr_b+OFM_SIZE+20] <= din_b[175:160]; mem[addr_b+OFM_SIZE+21] <= din_b[175:160];
                        mem[addr_b+22]          <= din_b[191:176]; mem[addr_b+23]          <= din_b[191:176]; 
                        mem[addr_b+OFM_SIZE+22] <= din_b[191:176]; mem[addr_b+OFM_SIZE+23] <= din_b[191:176];
                        mem[addr_b+24]          <= din_b[207:192]; mem[addr_b+25]          <= din_b[207:192]; 
                        mem[addr_b+OFM_SIZE+24] <= din_b[207:192]; mem[addr_b+OFM_SIZE+25] <= din_b[207:192];
                        mem[addr_b+26]          <= din_b[223:208]; mem[addr_b+27]          <= din_b[223:208]; 
                        mem[addr_b+OFM_SIZE+26] <= din_b[223:208]; mem[addr_b+OFM_SIZE+27] <= din_b[223:208];
                        mem[addr_b+28]          <= din_b[239:224]; mem[addr_b+29]          <= din_b[239:224]; 
                        mem[addr_b+OFM_SIZE+28] <= din_b[239:224]; mem[addr_b+OFM_SIZE+29] <= din_b[239:224];
                        mem[addr_b+30]          <= din_b[255:240]; mem[addr_b+31]          <= din_b[255:240]; 
                        mem[addr_b+OFM_SIZE+30] <= din_b[255:240]; mem[addr_b+OFM_SIZE+31] <= din_b[255:240];
                    end
                endcase
            end
            else begin
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
    end

endmodule