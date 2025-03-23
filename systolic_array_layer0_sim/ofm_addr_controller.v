module ofm_addr_controller #(
    parameter SYSTOLIC_SIZE = 16  ,
    parameter OFM_SIZE      = 414 ,
    parameter ADDR_WIDTH    = 22 

) (
    input                           clk       ,
    input                           rst_n     ,
    input                           write     ,
    output reg [ADDR_WIDTH - 1 : 0] ofm_addr  ,
    output reg                      addr_valid
);

    parameter IDLE             = 2'b00 ;
    parameter NEXT_CHANNEL     = 2'b01 ;
    parameter UPDATE_BASE_ADDR = 2'b10 ;

    reg [2:0] current_state, next_state;
    
    reg [ADDR_WIDTH - 1 : 0] base_addr;

    reg [4:0] count_channel;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:         if (write)                          next_state = NEXT_CHANNEL;
            NEXT_CHANNEL: if (count_channel == SYSTOLIC_SIZE) next_state = UPDATE_BASE_ADDR;
            UPDATE_BASE_ADDR: next_state = IDLE; 
            default:          next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_channel <= 0 ;
            base_addr     <= 0 ;
            ofm_addr      <= 0 ;
            addr_valid    <= 0 ;
        end
        else begin
            case (next_state)
                IDLE: begin
                    count_channel <= 0         ;
                    ofm_addr      <= base_addr ;
                    addr_valid    <= 0         ;
                end
                NEXT_CHANNEL: begin
                    count_channel <= count_channel + 1 ;
                    ofm_addr      <= base_addr + (count_channel + 1) * OFM_SIZE * OFM_SIZE ; 
                    addr_valid    <= 1 ;
                end
                UPDATE_BASE_ADDR: begin
                    base_addr  <= base_addr + 16;  
                    addr_valid <= 0;
                end
            endcase
        end
    end

endmodule