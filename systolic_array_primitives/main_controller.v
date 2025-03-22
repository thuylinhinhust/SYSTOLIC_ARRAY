module main_controller #(
    parameter NO_FILTER = 16,
    parameter KERNEL_SIZE = 3,
    parameter NO_CHANNEL = 3 ,
    parameter SYSTOLIC_SIZE = 16
) (
    input clk, 
    input rst_n,
    input start,
    output reg load_wgt, load_ifm,
    output reg ifm_RF_valid_1, ifm_RF_valid_2;
    output reg [SYSTOLIC_SIZE - 1 : 0] wgt_RF_valid;
    output reg reset_pe;
    output reg select_wgt;
    output reg select_mux_ifm, select_demux_ifm;
);

    localparam NO_CYCLE_LOAD = KERNEL_SIZE * KERNEL_SIZE * NO_CHANNEL;
    localparam NO_CYCLE_COMPUTE = NO_CYCLE_LOAD + (SYSTOLIC_SIZE - 1) * 2;
    localparam NO_LOAD_FILTER = (NO_FILTER + SYSTOLIC_SIZE - 1) / SYSTOLIC_SIZE;

    parameter IDLE = 3'b000;
    parameter LOAD_WEIGHT = 3'b001;
    parameter LOAD_COMPUTE = 3'b010;
    parameter LOAD_COMPUTE_WRITE = 3'b011;
    parameter COMPUTE_WRITE = 3'b100;
    parameter WRITE = 3'b101;

    reg [2:0] current_state, next_state;

    reg [13:0] count_tiling;
    reg [3:0] count_filter;
    reg [4:0] count_load;
    reg [5:0] count_compute_1;
    reg [5:0] count_compute_2;
    reg [4:0] count_write;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE: if (start) next_state = LOAD_WEIGHT;
            LOAD_WEIGHT: if (count_load == NO_CYCLE_LOAD) next_state = LOAD_COMPUTE;
            LOAD_COMPUTE: if (count_compute_1 == NO_CYCLE_COMPUTE) next_state = LOAD_COMPUTE_WRITE;
            LOAD_COMPUTE_WRITE: if (count_tiling == 10764) next_state = COMPUTE_WRITE;
            COMPUTE_WRITE: if (count_compute_1 == NO_CYCLE_COMPUTE) next_state = WRITE;
            WRITE: begin 
                if (count_write == SYSTOLIC_SIZE && count_filter < NO_LOAD_FILTER) next_state = LOAD_WEIGHT;
                else if (count_write == SYSTOLIC_SIZE) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_tiling <= 0;
            count_filter <= 0;
            count_load <= 0;
            count_compute_1 <= 0;
            count_compute_2 <= 0;
            count_write <= 0;
            load_ifm <= 0;
            load_wgt <= 0;
            reset_pe <= 0;
            select_wgt <= 0;
        end
        else begin
            case (next_state)
                IDLE: begin
                    count_tiling <= 0;
                    count_filter <= 0;
                    count_load <= 0;
                    count_compute_1 <= 0;
                    count_compute_2 <= 0; 
                    count_write <= 0;
                end 
                LOAD_WEIGHT: begin
                    count_write <= 0;
                    count_filter <= (count_load == NO_CYCLE_LOAD - 1) ? count_filter + 1 : count_filter;
                    count_tiling <= (count_load == NO_CYCLE_LOAD - 1) ? count_tiling + 1 : count_tiling;
                    count_load <= count_load + 1;

                    load_wgt <= 1;
                    load_ifm <= 1;
                    select_demux_ifm <= 0;
                    ifm_RF_valid_1 <= 1;

                    select_wgt <= 1; // tu RAM

                end
                LOAD_COMPUTE: begin
                    count_load <= 0;
                    count_compute_1 <= count_compute_1 + 1;
                    count_tiling <= (count_compute_1 == NO_CYCLE_COMPUTE - 1) ? count_tiling + 1 : count_tiling;

                    load_wgt <= 0;
                    load_ifm <= (count_compute_1 <= NO_CYCLE_COMPUTE) ? 1 : 0;
                    select_demux_ifm <= 1;
                    select_mux_ifm <= 0;
                    ifm_RF_valid_1 <= 1;
                    ifm_RF_valid_2 <= (count_compute_1 <= NO_CYCLE_COMPUTE) ? 1 : 0;
                    reset_pe <= (count_compute_1 == NO_CYCLE_COMPUTE - 1) ? 1 : 0;
                    select_wgt <= 0;

                end
                LOAD_COMPUTE_WRITE: begin
                    count_compute_1 <= 0;
                    count_compute_2 = (count_compute_2 == NO_CYCLE_COMPUTE) ? 0 : count_compute_2 + 1;
                    count_tiling <= (count_compute_2 == NO_CYCLE_COMPUTE - 1) ? count_tiling + 1 : count_tiling;
                    load_wgt <= 0;
                    load_ifm <= (count_compute_2 <= NO_CYCLE_COMPUTE) ? 1 : 0;

                    select_demux_ifm <= (count_compute_1 == NO_CYCLE_COMPUTE || count_compute_2 == NO_CYCLE_COMPUTE - 1) ? ~select_demux_ifm : select_demux_ifm;
                    select_mux_ifm <= (count_compute_1 == NO_CYCLE_COMPUTE || count_compute_2 == NO_CYCLE_COMPUTE - 1) ? ~select_mux_ifm : select_mux_ifm;
                    
                    ifm_RF_valid_1 <= (select_demux_ifm == 0) ? ((count_compute_2 <= NO_CYCLE_LOAD) ? 1 : 0) : 1;
                    ifm_RF_valid_2 <= (select_demux_ifm == 1) ? ((count_compute_2 <= NO_CYCLE_LOAD) ? 1 : 0) : 1;

                    reset_pe <= (count_compute_2 == NO_CYCLE_COMPUTE - 1) ? 1 : 0;
                    select_wgt <= 0;
                
                end
                COMPUTE_WRITE: begin
                    count_compute_1 <= count_compute_1 + 1;    
                    select_mux_ifm <= ~select_mux_ifm;              
                    ifm_RF_valid_1 <= 1;
                    ifm_RF_valid_2 <= 1;

                end
                WRITE: begin
                    count_compute_1 <= 0;
                    count_write <= count_write + 1;
                    ifm_RF_valid_1 <= 0;
                    ifm_RF_valid_2 <= 0;
                    reset_pe <= (count_compute_1 == NO_CYCLE_COMPUTE - 1) ? 1 : 0;

                end
            endcase
        end
    end

endmodule