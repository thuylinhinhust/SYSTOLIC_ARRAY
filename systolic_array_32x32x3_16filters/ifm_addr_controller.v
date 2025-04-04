module ifm_addr_controller #(
    parameter KERNEL_SIZE = 3  ,
    parameter IFM_SIZE    = 34 ,
    parameter IFM_CHANNEL = 3  ,
    parameter ADDR_WIDTH  = 12
) (
    input                           clk        ,
    input                           rst_n      ,
    input                           load       ,
    output reg [ADDR_WIDTH - 1 : 0] ifm_addr   ,
    output reg                      addr_valid
);

    parameter IDLE         = 3'b000 ;
    parameter NEXT_PIXEL   = 3'b001 ;
    parameter NEXT_LINE    = 3'b010 ;
    parameter NEXT_CHANNEL = 3'b011 ;
    parameter NEXT_TILING  = 3'b100 ;

    reg [2:0] current_state, next_state;
    
    reg [ADDR_WIDTH - 1 : 0] base_addr;
    
    reg [1 :0] count_pixel_in_row;
    reg [3 :0] count_pixel_in_window;
    reg [12:0] count_pixel_in_channel;

    reg [1 :0] count_line;
    reg [10:0] count_channel;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE: if (load) next_state = NEXT_PIXEL;
            NEXT_PIXEL: begin
                if      (count_pixel_in_channel == IFM_CHANNEL * KERNEL_SIZE * (KERNEL_SIZE - 1)) next_state = NEXT_TILING;   
                else if (count_pixel_in_window  == KERNEL_SIZE * (KERNEL_SIZE - 1))               next_state = NEXT_CHANNEL;  
                else if (count_pixel_in_row     == KERNEL_SIZE - 1)                               next_state = NEXT_LINE;
            end 
            NEXT_LINE:    next_state = NEXT_PIXEL;
            NEXT_CHANNEL: next_state = NEXT_PIXEL;
            NEXT_TILING:  next_state = IDLE;
            default:      next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) addr_valid <= 0;
        else begin
          case (next_state)
            IDLE:         addr_valid <= 0 ;
            NEXT_PIXEL:   addr_valid <= 1 ;
            NEXT_LINE:    addr_valid <= 1 ;
            NEXT_CHANNEL: addr_valid <= 1 ;
            NEXT_TILING:  addr_valid <= 1 ;
          endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ifm_addr               <= 0 ;
            base_addr              <= 0 ;
            count_pixel_in_row     <= 1 ;
            count_pixel_in_window  <= 1 ;
            count_pixel_in_channel <= 1 ;
            count_line             <= 1 ;
            count_channel          <= 1 ;
        end
        else begin
            case (current_state)
                IDLE: begin
                    ifm_addr               <= base_addr ;
                    count_pixel_in_row     <= 1         ;
                    count_pixel_in_window  <= 1         ;
                    count_pixel_in_channel <= 1         ;
                    count_line             <= 1         ;
                    count_channel          <= 1         ;
                end 
                NEXT_PIXEL: begin
                    ifm_addr               <= ifm_addr + 1               ;
                    count_pixel_in_row     <= count_pixel_in_row + 1     ;
                    count_pixel_in_window  <= count_pixel_in_window + 1  ;
                    count_pixel_in_channel <= count_pixel_in_channel + 1 ;
                end
                NEXT_LINE: begin
                    ifm_addr           <= base_addr + (count_channel - 1) * IFM_SIZE * IFM_SIZE + count_line * IFM_SIZE ;
                    count_line         <= count_line + 1                                                                ;
                    count_pixel_in_row <= 1                                                                             ;
                end
                NEXT_CHANNEL: begin
                    ifm_addr              <= base_addr + count_channel * IFM_SIZE * IFM_SIZE ;
                    count_channel         <= count_channel + 1                               ;
                    count_line            <= 1                                               ; 
                    count_pixel_in_row    <= 1                                               ;
                    count_pixel_in_window <= 1                                               ;
                end
                NEXT_TILING: base_addr <= ( (base_addr + 18) == (IFM_SIZE * (IFM_SIZE - 2) ) ) ? 0 : ( ((base_addr + 18) % IFM_SIZE == 0) ? (base_addr + 18) : (base_addr + 16) ) ;
            endcase
        end
    end

endmodule