module wgt_addr_controller #(
    parameter SYSTOLIC_SIZE = 16 ,
    parameter KERNEL_SIZE   = 3  ,
    parameter NO_CHANNEL    = 3  ,
    parameter NO_FILTER     = 16 ,
    parameter ADDR_WIDTH    = 9
) (
    input                           clk      ,
    input                           rst_n    ,
    input                           load     ,
    output reg [ADDR_WIDTH - 1 : 0] wgt_addr ,
    output reg                      read_en  ,
    output reg [4:0]                size 
);

    localparam MAX_ADDR            = KERNEL_SIZE * KERNEL_SIZE * NO_CHANNEL * NO_FILTER;
    localparam NO_FILTER_REMAINING = NO_FILTER % SYSTOLIC_SIZE;

    parameter IDLE       = 2'b00 ;
    parameter HOLD       = 2'b01 ;
    parameter ADDRESSING = 2'b10 ;
    parameter UPDATE     = 2'b11 ;

    reg [1:0] current_state, next_state;

    reg [12:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:       if (load) next_state = HOLD;
            HOLD:                 next_state = ADDRESSING;
            ADDRESSING: if (count == KERNEL_SIZE * KERNEL_SIZE * NO_CHANNEL - 1) next_state = UPDATE;
            UPDATE:     next_state = IDLE;
            default:    next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                    wgt_addr <= 0             ;  
                    read_en  <= 0             ;
                    size     <= SYSTOLIC_SIZE ;
                    count    <= 0             ;
        end
        else begin
            case (next_state)
                IDLE: begin
                    wgt_addr <= wgt_addr ;
                    read_en  <= 0        ;
                    count    <= 0        ;
                end
                HOLD: begin
                    wgt_addr <= wgt_addr ;
                    read_en  <= 1        ;
                    count    <= 0        ;
                    size     <= (wgt_addr + KERNEL_SIZE * KERNEL_SIZE * NO_CHANNEL * SYSTOLIC_SIZE > MAX_ADDR) ? NO_FILTER_REMAINING : SYSTOLIC_SIZE;
                end
                ADDRESSING: begin
                    wgt_addr <= wgt_addr + size ;
                    read_en  <= 1               ;
                    count    <= count + 1       ;
                end  
                UPDATE: begin
                    wgt_addr <= wgt_addr + size ;
                    read_en  <= 0               ;
                    count    <= 0               ;                    
                end
            endcase
        end
    end

endmodule