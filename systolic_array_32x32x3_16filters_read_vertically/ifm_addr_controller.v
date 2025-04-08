module ifm_addr_controller #(
    parameter SYSTOLIC_SIZE = 16 ,
    parameter KERNEL_SIZE   = 3  ,
    parameter IFM_SIZE      = 34 ,
    parameter IFM_CHANNEL   = 3  ,
    parameter ADDR_WIDTH    = 12
) (
    input                           clk      ,
    input                           rst_n    ,
    input                           load     ,
    output reg [ADDR_WIDTH - 1 : 0] ifm_addr ,
    output reg                      read_en  ,
    output reg [4:0]                size     
);

    localparam OFM_SIZE = IFM_SIZE - KERNEL_SIZE + 1;

    parameter IDLE         = 3'b000 ;
    parameter HOLD         = 3'b001 ;
    parameter NEXT_PIXEL   = 3'b010 ;
    parameter NEXT_LINE    = 3'b011 ;
    parameter NEXT_CHANNEL = 3'b100 ;
    parameter NEXT_TILING  = 3'b101 ;

    reg [2:0] current_state, next_state;
    
    reg [ADDR_WIDTH - 1 : 0] base_addr;
    reg [ADDR_WIDTH - 1 : 0] start_window_addr;
    
    reg [1 :0] count_pixel_in_row;
    reg [3 :0] count_pixel_in_window;
    reg [12:0] count_pixel_in_channel;

    reg [1 :0] count_line;
    reg [10:0] count_channel;

    reg [8 :0] count_height; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE: if (load) next_state = HOLD;
            HOLD: begin
                if (KERNEL_SIZE == 1) next_state = NEXT_CHANNEL;
                else                  next_state = NEXT_PIXEL;
            end            
            NEXT_PIXEL: begin
                if      (count_pixel_in_channel == IFM_CHANNEL * KERNEL_SIZE * (KERNEL_SIZE - 1)) next_state = NEXT_TILING;   
                else if (count_pixel_in_window  == KERNEL_SIZE * (KERNEL_SIZE - 1))               next_state = NEXT_CHANNEL;  
                else if (count_pixel_in_row     == KERNEL_SIZE - 1)                               next_state = NEXT_LINE;
            end 
            NEXT_LINE: next_state = NEXT_PIXEL;
            NEXT_CHANNEL: begin
                if      (KERNEL_SIZE != 1)                                     next_state = NEXT_PIXEL;
                else if (KERNEL_SIZE == 1 && count_channel == IFM_CHANNEL - 1) next_state = NEXT_TILING;
            end 
            NEXT_TILING: next_state = IDLE;
            default:     next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                    ifm_addr               <= 0             ;
                    read_en                <= 0             ;
                    size                   <= SYSTOLIC_SIZE ;
                    base_addr              <= 0             ;
                    start_window_addr      <= 0             ;
                    count_pixel_in_row     <= 0             ;
                    count_pixel_in_window  <= 0             ;
                    count_pixel_in_channel <= 0             ;
                    count_line             <= 0             ;
                    count_channel          <= 0             ;
                    count_height           <= 0             ;
        end
        else begin
            case (next_state)
                IDLE: begin
                    ifm_addr               <= start_window_addr ;
                    read_en                <= 0                 ;
                    count_pixel_in_row     <= 0                 ;
                    count_pixel_in_window  <= 0                 ;
                    count_pixel_in_channel <= 0                 ;
                    count_line             <= 0                 ;
                    count_channel          <= 0                 ;
                end 
                HOLD: begin
                    ifm_addr <= ifm_addr ;
                    read_en  <= 1        ;
                end
                NEXT_PIXEL: begin
                    ifm_addr               <= ifm_addr + 1               ;
                    read_en                <= 1                          ;
                    count_pixel_in_row     <= count_pixel_in_row + 1     ;
                    count_pixel_in_window  <= count_pixel_in_window + 1  ;
                    count_pixel_in_channel <= count_pixel_in_channel + 1 ;
                end
                NEXT_LINE: begin
                    ifm_addr           <= start_window_addr + count_channel * IFM_SIZE * IFM_SIZE + (count_line + 1) * IFM_SIZE ;
                    read_en            <= 1                                                                                     ;
                    count_line         <= count_line + 1                                                                        ;
                    count_pixel_in_row <= 0                                                                                     ;
                end
                NEXT_CHANNEL: begin
                    ifm_addr              <= start_window_addr + (count_channel + 1) * IFM_SIZE * IFM_SIZE ;
                    read_en               <= 1                                                             ;
                    count_channel         <= count_channel + 1                                             ;
                    count_line            <= 0                                                             ; 
                    count_pixel_in_row    <= 0                                                             ;
                    count_pixel_in_window <= 0                                                             ;
                end
                NEXT_TILING: begin
                    read_en           <= 0 ;
                    size              <= (base_addr + SYSTOLIC_SIZE + KERNEL_SIZE - 1 > IFM_SIZE) ? (IFM_SIZE - base_addr - KERNEL_SIZE + 1) : SYSTOLIC_SIZE ; 
                    count_height      <= (count_height == OFM_SIZE - 1) ? 0 : count_height + 1 ;
                    base_addr         <= (start_window_addr + size + KERNEL_SIZE - 1 == IFM_SIZE * (IFM_SIZE - KERNEL_SIZE)) ? 0 : ((count_height == OFM_SIZE - 2) ? base_addr + SYSTOLIC_SIZE : base_addr) ;
                    start_window_addr <= (count_height == OFM_SIZE - 1) ? base_addr : start_window_addr + IFM_SIZE ;  
                end
            endcase
        end
    end

endmodule