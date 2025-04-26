module controller #(
    parameter SYSTOLIC_SIZE = 16,
    parameter BUFFER_SIZE = 9,
    parameter BUFFER_COUNT = 16,
    parameter IFM_SIZE = 64,
    parameter IFM_CHANNEL = 3,
    parameter WEIGHT_SIZE = 3,
    parameter WEIGHT_FILTER = 16
) (
    input clk,
    input rst_n,
    input data_valid,
    output reg ifm_read_en, weight_read_en,
    output reg [BUFFER_COUNT - 1 : 0] ifm_in_valid, weight_in_valid,
    output reg                        ofm_in_valid,
    output reg [(SYSTOLIC_SIZE - 1) * 2 : 0] set_reg_compute,
    output reg [SYSTOLIC_SIZE - 2 : 0] set_reg_write,
    output reg ofm_write_en,
    output reg sel_mux,
    output reg reset_pe,
    output reg done
);

    localparam OFM_SIZE       = IFM_SIZE - WEIGHT_SIZE + 1;
    localparam LOAD_SIZE      = BUFFER_COUNT * BUFFER_SIZE;
    localparam NUMBER_LOAD_1C = ( (OFM_SIZE * OFM_SIZE) * (WEIGHT_SIZE * WEIGHT_SIZE) + LOAD_SIZE - 1 ) / LOAD_SIZE;
    localparam NUMBER_LOAD    = NUMBER_LOAD_1C * (WEIGHT_FILTER / 16) * IFM_CHANNEL;

    parameter IDLE       = 3'b000;
    parameter LOAD_DATA  = 3'b001;
    parameter COMPUTE    = 3'b010;
    parameter WRITE_DATA = 3'b011;
    parameter CLEAR      = 3'b100;

    reg [2:0] current_state, next_state;

    reg [3:0] count_input;
    reg [4:0] count_write;
    reg [5:0] count_compute;
    reg [9:0] count_clear;
 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:       if (data_valid)                             next_state = LOAD_DATA;
            LOAD_DATA:  if (count_input == BUFFER_SIZE)             next_state = COMPUTE;
            COMPUTE:    if (count_compute == SYSTOLIC_SIZE * 3 - 1) next_state = WRITE_DATA;
            WRITE_DATA: if (count_write == SYSTOLIC_SIZE)           next_state = CLEAR;
            CLEAR: begin
                if (count_clear < NUMBER_LOAD) next_state = LOAD_DATA;
                else                           next_state = IDLE; 
            end
            default: next_state = IDLE;
        endcase
    end

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_input     <= 0;
            count_compute   <= 0;
            count_write     <= 0;
            count_clear     <= 0;
            ifm_read_en     <= 0;
            weight_read_en  <= 0;
            ifm_in_valid    <= 0; 
            weight_in_valid <= 0;
            ofm_in_valid    <= 0;
            set_reg_compute <= 0;
            set_reg_write   <= 0;
            ofm_write_en    <= 0;
            sel_mux         <= 0;
            reset_pe        <= 1;
            done            <= 0;
        end
        else begin
          case (next_state)
            IDLE: begin
                count_input     <= 0;
                count_compute   <= 0;
                count_write     <= 0;
                count_clear     <= 0;
                ifm_read_en     <= 0;
                weight_read_en  <= 0;
                ifm_in_valid    <= 0; 
                weight_in_valid <= 0;
                ofm_in_valid    <= 0;
                set_reg_compute <= 0;
                set_reg_write   <= 0;
                ofm_write_en    <= 0;
                sel_mux         <= 0;
                reset_pe        <= 1;
                done            <= 0;              
            end
            LOAD_DATA: begin
                count_input     <= count_input + 1;
                ifm_read_en     <= 1;
                weight_read_en  <= (count_clear % NUMBER_LOAD_1C == 0) ? 1 : 0;
                ifm_in_valid    <= 1;
                weight_in_valid <= 1;
                ofm_in_valid    <= 0;
                set_reg_compute <= 0;
                set_reg_write   <= 0;
                ofm_write_en    <= 0;
                sel_mux         <= 0;
                reset_pe        <= 1;
                done            <= 0;  
            end 
            COMPUTE: begin
                count_input     <= 0;
                count_compute   <= count_compute + 1;
                ifm_read_en     <= 0;
                weight_read_en  <= 0;
                for (i = 0; i < BUFFER_COUNT; i = i + 1) begin
                  ifm_in_valid    [i] <= (count_compute >= i) ? 1 : 0;
                  weight_in_valid [i] <= (count_compute >= i) ? 1 : 0;
                end
                ofm_in_valid    <= 0;
                for (i = 0; i <= (SYSTOLIC_SIZE - 1) * 2; i = i + 1) begin
                  set_reg_compute [i] <= ( (i + 1 <= count_compute) && (count_compute <= i + BUFFER_SIZE) ) ? 1 : 0;
                end
                set_reg_write   <= 0;
                ofm_write_en    <= 0;
                sel_mux         <= 0;
                reset_pe        <= 1;
                done            <= 0;  
            end 
            WRITE_DATA: begin
                count_compute   <= 0;
                count_write     <= count_write + 1;
                ifm_read_en     <= 0;
                weight_read_en  <= 0;
                ifm_in_valid    <= 0;
                weight_in_valid <= 0;
                ofm_in_valid    <= 1;
                set_reg_compute <= 0;
                for (i = 0; i < SYSTOLIC_SIZE - 1; i = i + 1) begin
                  set_reg_write [i] <= (count_write <= i) ? 1 : 0;
                end
                ofm_write_en    <= 1;
                sel_mux         <= 1;
                reset_pe        <= 1;
                done            <= 0;  
            end 
            CLEAR: begin
                count_write     <= 0;
                count_clear     <= count_clear + 1;
                ifm_read_en     <= 0;
                weight_read_en  <= 0;
                ifm_in_valid    <= 0;
                weight_in_valid <= 0;
                ofm_in_valid    <= 0;
                set_reg_compute <= 0;
                set_reg_write   <= 0;
                ofm_write_en    <= 0;
                sel_mux         <= 0;
                reset_pe        <= 0;
                done            <= (count_clear == NUMBER_LOAD) ? 1 : 0;  
            end 
          endcase
        end
    end
endmodule
