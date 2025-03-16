module ROM #(parameter ADDR_WIDTH = 9, ADDR_LINE = 432, DATA_WIDTH = 8, NUM_BANKS = 16) (
    input                                       clk  ,                     
    input      [ADDR_WIDTH             - 1 : 0] addr ,    
    output reg [DATA_WIDTH * NUM_BANKS - 1 : 0] dout     
);

    reg [DATA_WIDTH - 1 : 0] rom_mem [0 : ADDR_LINE - 1];

    initial begin
        $readmemh ("rom_data.hex", rom_mem);   //Load from external file (Hex format)
    end

    //Synchronous read operation
    always @(posedge clk) begin
        dout <= { rom_mem [addr+15], rom_mem [addr+14], rom_mem [addr+13], rom_mem [addr+12], rom_mem [addr+11], rom_mem [addr+10], 
                  rom_mem [addr+9] , rom_mem [addr+8] , rom_mem [addr+7] , rom_mem [addr+6] , rom_mem [addr+5] , rom_mem [addr+4], 
                  rom_mem [addr+3] , rom_mem [addr+2] , rom_mem [addr+1] , rom_mem [addr+0] };
    end

endmodule