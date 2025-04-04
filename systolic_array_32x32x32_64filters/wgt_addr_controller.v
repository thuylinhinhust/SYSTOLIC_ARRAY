module wgt_addr_controller #(
    parameter KERNEL_SIZE = 3 ,
    parameter NO_CHANNEL  = 3 ,
    parameter ADDR_WIDTH  = 9
) (
    input                           clk        ,
    input                           rst_n      ,
    input                           load       ,
    output reg [ADDR_WIDTH - 1 : 0] wgt_addr   ,
    output reg                      addr_valid
);

    parameter IDLE       = 1'b0 ;
    parameter ADDRESSING = 1'b1 ;

    reg current_state, next_state;

    reg [12:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:       if (load)                                            next_state = ADDRESSING;
            ADDRESSING: if (count == KERNEL_SIZE * KERNEL_SIZE * NO_CHANNEL) next_state = IDLE;
            default:    next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) addr_valid <= 0;
        else begin
          case (next_state)
            IDLE:       addr_valid <= 0 ;
            ADDRESSING: addr_valid <= 1 ;
          endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wgt_addr <= 0 ; 
            count    <= 1 ;
        end
        else begin
            case (current_state)
                IDLE: begin
                    wgt_addr <= wgt_addr ;
                    count    <= 1        ;
                end
                ADDRESSING: begin
                    wgt_addr <= wgt_addr + 16 ;
                    count    <= count + 1     ;
                end
            endcase
        end
    end

endmodule