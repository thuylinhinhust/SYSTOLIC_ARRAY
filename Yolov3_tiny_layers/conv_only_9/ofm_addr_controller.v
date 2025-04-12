module ofm_addr_controller #(
    parameter SYSTOLIC_SIZE  = 16 ,
    parameter OFM_SIZE       = 32 ,
    parameter ADDR_WIDTH     = 14 ,
    parameter MAXPOOL_MODE   = 1  ,
    parameter MAXPOOL_STRIDE = 2  ,
    parameter UPSAMPLE_MODE  = 0
) (
    input                           clk          ,
    input                           rst_n        ,
    input                           write        ,
    input      [4:0]                wgt_size     ,
    input      [6:0]                count_filter , 
    output reg [ADDR_WIDTH - 1 : 0] ofm_addr     ,
    output reg [4:0]                ofm_size   
);

    parameter IDLE             = 2'b00 ;
    parameter NEXT_CHANNEL     = 2'b01 ;
    parameter UPDATE_BASE_ADDR = 2'b10 ;

    reg [1:0] current_state, next_state;
    
    reg [ADDR_WIDTH - 1 : 0] base_addr;
    reg [ADDR_WIDTH - 1 : 0] start_window_addr;

    reg [4:0] count_channel;
    reg [8:0] count_height ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:         if (write)                         next_state = NEXT_CHANNEL;
            NEXT_CHANNEL: if (count_channel == wgt_size - 1) next_state = UPDATE_BASE_ADDR;
            UPDATE_BASE_ADDR: next_state = IDLE; 
            default:          next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                    ofm_addr          <= 0                                                                                                                                                                                                                           ;                    
                    ofm_size          <= (UPSAMPLE_MODE == 1) ? ((OFM_SIZE/2 < SYSTOLIC_SIZE) ? OFM_SIZE/2 : SYSTOLIC_SIZE) : ((MAXPOOL_MODE == 1) ? ((MAXPOOL_STRIDE == 1) ? OFM_SIZE : SYSTOLIC_SIZE/2) : ((OFM_SIZE < SYSTOLIC_SIZE) ? OFM_SIZE : SYSTOLIC_SIZE)) ;
                    base_addr         <= 0                                                                                                                                                                                                                           ;
                    start_window_addr <= 0                                                                                                                                                                                                                           ; 
                    count_channel     <= 0                                                                                                                                                                                                                           ;
                    count_height      <= 0                                                                                                                                                                                                                           ; 
        end 
        else begin
            case (next_state)
                IDLE: begin
                    ofm_addr      <= start_window_addr ;
                    count_channel <= 0                 ;
                end
                NEXT_CHANNEL: begin
                    ofm_addr      <= start_window_addr + (count_channel + 1) * OFM_SIZE * OFM_SIZE ;  
                    count_channel <= count_channel + 1                                             ;
                end
                UPDATE_BASE_ADDR: begin
                    count_height      <= (UPSAMPLE_MODE == 1) ? ((count_height == OFM_SIZE/2 - 1) ? 0 : count_height + 1) : ((count_height == OFM_SIZE - 1) ? 0 : count_height + 1)                                                                                                                                                                                                                                                                                         ;
                    base_addr         <= (UPSAMPLE_MODE == 1) ? (((start_window_addr + ofm_size*2 + OFM_SIZE*3) % (OFM_SIZE * OFM_SIZE) == 0) ? OFM_SIZE * OFM_SIZE * wgt_size * count_filter : ((count_height == OFM_SIZE/2 - 2) ? base_addr + ofm_size*2 : base_addr)) : (((start_window_addr + ofm_size + OFM_SIZE) % (OFM_SIZE * OFM_SIZE) == 0) ? OFM_SIZE * OFM_SIZE * wgt_size * count_filter : ((count_height == OFM_SIZE - 2) ? base_addr + ofm_size : base_addr)) ;                                                            
                    start_window_addr <= (UPSAMPLE_MODE == 1) ? ((count_height == OFM_SIZE/2 - 1) ? base_addr : start_window_addr + OFM_SIZE*2) : ((count_height == OFM_SIZE - 1) ? base_addr : start_window_addr + OFM_SIZE)                                                                                                                                                                                                                                               ;                            
                    ofm_size          <= (UPSAMPLE_MODE == 1) ? ((base_addr % OFM_SIZE) + ofm_size*2 >= OFM_SIZE ? (OFM_SIZE - (base_addr % OFM_SIZE))/2 : ((OFM_SIZE/2 < SYSTOLIC_SIZE) ? OFM_SIZE/2 : SYSTOLIC_SIZE)) : ((base_addr % OFM_SIZE) + ofm_size >= OFM_SIZE ? (OFM_SIZE - (base_addr % OFM_SIZE)) : ((MAXPOOL_MODE == 1) ? ((MAXPOOL_STRIDE == 1) ? OFM_SIZE : SYSTOLIC_SIZE/2) : ((OFM_SIZE < SYSTOLIC_SIZE) ? OFM_SIZE : SYSTOLIC_SIZE)))                    ; 
                end
            endcase
        end
    end

endmodule