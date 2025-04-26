module main_controller #(
    parameter NO_FILTER     = 16 ,
    parameter KERNEL_SIZE   = 3  ,
    parameter IFM_SIZE      = 34 ,
    parameter OFM_SIZE      = 32 ,
    parameter IFM_CHANNEL   = 3  ,
    parameter SYSTOLIC_SIZE = 16 , 
    parameter STRIDE        = 2
) (
    input                              clk                                  , 
    input                              rst_n                                ,
    input                              start                                ,
    input      [4:0]                   wgt_size                             ,       
    output reg                         load_ifm, load_wgt                   ,
    output reg                         ifm_demux, ifm_mux                   ,
    output reg                         ifm_RF_shift_en_1, ifm_RF_shift_en_2 ,
    output reg [SYSTOLIC_SIZE - 1 : 0] wgt_RF_shift_en                      ,
    output reg                         select_wgt                           ,
    output reg                         reset_pe                             ,
    output reg                         write_out_pe_en                      ,
    output reg                         write_ofm_en                         ,
    output reg [6:0]                   count_filter                         ,
    output reg                         fifo_rd_clr                          ,
    output reg                         fifo_wr_clr                          ,
    output reg                         fifo_rd_en                           ,
    output reg                         fifo_wr_en                           ,
    output reg                         done
);

    localparam NO_CYCLE_LOAD      = KERNEL_SIZE * KERNEL_SIZE * IFM_CHANNEL;
    localparam NO_CYCLE_COMPUTE   = NO_CYCLE_LOAD + SYSTOLIC_SIZE*2 - 1;
    localparam NO_LOAD_FILTER     = (NO_FILTER + SYSTOLIC_SIZE - 1) / SYSTOLIC_SIZE;
    localparam NO_TILING_PER_LINE = (OFM_SIZE  + SYSTOLIC_SIZE - 1) / SYSTOLIC_SIZE;
    localparam NO_TILING          = NO_TILING_PER_LINE * OFM_SIZE;

    parameter IDLE               = 3'b000 ;
    parameter LOAD_WEIGHT        = 3'b001 ;
    parameter LOAD_COMPUTE       = 3'b010 ;
    parameter LOAD_COMPUTE_WRITE = 3'b011 ; 
    parameter COMPUTE_WRITE      = 3'b100 ;
    parameter WRITE              = 3'b101 ;
    parameter LAST_POOL          = 3'b110 ;

    reg [2:0] current_state, next_state;

    reg [12:0] count_load      ;
    reg [12:0] count_compute_1 ;
    reg [12:0] count_compute_2 ;
    reg [4 :0] count_write     ;
    reg [13:0] count_tiling    ;
    reg [4 :0] count_pool      ;

    reg sel_write_out_1;
    reg sel_write_out_2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:               if (start)                                             next_state = LOAD_WEIGHT;
            LOAD_WEIGHT:        if (count_load == NO_CYCLE_LOAD + 2)                   next_state = LOAD_COMPUTE;
            LOAD_COMPUTE:       if (count_compute_1 == NO_CYCLE_COMPUTE + 1)           next_state = LOAD_COMPUTE_WRITE;
            LOAD_COMPUTE_WRITE: if (count_tiling == NO_TILING && count_compute_2 == 0) next_state = COMPUTE_WRITE;   //414*26=10764, 32*2=64
            COMPUTE_WRITE:      if (count_compute_1 == NO_CYCLE_COMPUTE + 1)           next_state = WRITE;
            WRITE: begin 
                if (STRIDE == 1 && count_write == SYSTOLIC_SIZE + 1) next_state = LAST_POOL;
                else begin
                    if      (count_write == SYSTOLIC_SIZE + 1 && count_filter < NO_LOAD_FILTER) next_state = LOAD_WEIGHT;
                    else if (count_write == SYSTOLIC_SIZE + 1)                                  next_state = IDLE;
                end
            end
            LAST_POOL: begin
                    if      (count_pool == SYSTOLIC_SIZE + 1 && count_filter < NO_LOAD_FILTER) next_state = LOAD_WEIGHT;
                    else if (count_pool == SYSTOLIC_SIZE + 1)                                  next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                    count_load        <= 0 ;
                    count_compute_1   <= 0 ;
                    count_compute_2   <= 0 ;
                    count_write       <= 0 ;
                    count_tiling      <= 0 ;
                    count_filter      <= 0 ;
                    count_pool        <= 0 ;
                    sel_write_out_1   <= 0 ;
                    sel_write_out_2   <= 0 ;
                    load_ifm          <= 0 ;
                    load_wgt          <= 0 ;
                    ifm_demux         <= 0 ;
                    ifm_mux           <= 1 ;
                    ifm_RF_shift_en_1 <= 0 ;
                    ifm_RF_shift_en_2 <= 0 ;
                    wgt_RF_shift_en   <= 0 ;
                    select_wgt        <= 1 ;
                    reset_pe          <= 0 ;
                    write_out_pe_en   <= 0 ;
                    write_ofm_en      <= 0 ;
                    fifo_rd_clr       <= 1 ;
                    fifo_wr_clr       <= 1 ;
                    fifo_rd_en        <= 0 ;
                    fifo_wr_en        <= 0 ;
                    done              <= 0 ; 
        end
        else begin
            case (next_state)
                IDLE: begin
                    count_load        <= 0 ;
                    count_compute_1   <= 0 ;
                    count_compute_2   <= 0 ;
                    count_write       <= 0 ;
                    count_tiling      <= 0 ;
                    count_filter      <= 0 ;
                    count_pool        <= 0 ;
                    sel_write_out_1   <= 0 ;
                    sel_write_out_2   <= 0 ;
                    load_ifm          <= 0 ;
                    load_wgt          <= 0 ;
                    ifm_demux         <= 0 ;
                    ifm_mux           <= 1 ;
                    ifm_RF_shift_en_1 <= 0 ;
                    ifm_RF_shift_en_2 <= 0 ;
                    wgt_RF_shift_en   <= 0 ;
                    select_wgt        <= 1 ;
                    reset_pe          <= 0 ;
                    write_out_pe_en   <= 0 ;
                    write_ofm_en      <= 0 ;
                    fifo_rd_clr       <= 1 ;
                    fifo_wr_clr       <= 1 ;
                    fifo_rd_en        <= 0 ;
                    fifo_wr_en        <= 0 ;
                    done              <= 0 ;
                end 
                LOAD_WEIGHT: begin
                    count_write       <= 0;
                    count_pool        <= 0;

                    count_load        <= count_load + 1;
                    count_tiling      <= (count_load == NO_CYCLE_LOAD - 1) ? count_tiling + 1 : count_tiling;
                    count_filter      <= (count_load == NO_CYCLE_LOAD - 1) ? count_filter + 1 : count_filter;
                    sel_write_out_1   <= 0 ;
                    sel_write_out_2   <= 0 ;
                    
                    load_ifm          <= 1 ;
                    load_wgt          <= (count_load < NO_CYCLE_LOAD - 1) ? 1 : 0 ;
                    ifm_demux         <= 0 ;
                    ifm_mux           <= 1 ;
                    ifm_RF_shift_en_1 <= 1 ;
                    ifm_RF_shift_en_2 <= 0 ;
                    wgt_RF_shift_en   <= {SYSTOLIC_SIZE{1'b1}};
                    select_wgt        <= 1 ;
                    reset_pe          <= 0 ;
                    write_out_pe_en   <= 0 ;
                    write_ofm_en      <= 0 ;
                    fifo_rd_clr       <= 1 ;
                    fifo_wr_clr       <= 1 ;
                    fifo_rd_en        <= 0 ;
                    fifo_wr_en        <= 0 ;
                    done              <= 0 ;
                end
                LOAD_COMPUTE: begin
                    count_load        <= 0;

                    count_compute_1   <= count_compute_1 + 1;
                    count_tiling      <= (count_compute_1 == NO_CYCLE_LOAD - 1) ? count_tiling + 1 : count_tiling;
                    sel_write_out_1   <= 0 ;
                    sel_write_out_2   <= 0 ;

                    load_ifm          <= (count_compute_1 <= NO_CYCLE_LOAD - 1) ? 1 : 0;
                    load_wgt          <= 0 ;
                    ifm_demux         <= 1 ;
                    ifm_mux           <= 0 ;
                    ifm_RF_shift_en_1 <= 1 ;
                    ifm_RF_shift_en_2 <= (count_compute_1 <= NO_CYCLE_LOAD + 1) ? 1 : 0;

                    for (i = 0; i < SYSTOLIC_SIZE; i = i + 1) begin
                        wgt_RF_shift_en[i] <= (count_compute_1 >= i && count_compute_1 < NO_CYCLE_LOAD + i) ? 1 : 0 ;
                    end
                    
                    select_wgt        <= 0 ;
                    reset_pe          <= (count_compute_1 == NO_CYCLE_COMPUTE) ? 1 : 0;
                    write_out_pe_en   <= 0 ;
                    write_ofm_en      <= 0 ;
                    fifo_rd_clr       <= 1 ;
                    fifo_wr_clr       <= 1 ;
                    fifo_rd_en        <= 0 ;
                    fifo_wr_en        <= 0 ;
                    done              <= 0 ;
                end
                LOAD_COMPUTE_WRITE: begin
                    count_compute_1   <= 0;

                    count_compute_2   <= (count_compute_2 == NO_CYCLE_COMPUTE) ? 0 : count_compute_2 + 1;
                    count_tiling      <= (count_compute_2 == NO_CYCLE_LOAD - 1 ) ? count_tiling + 1 : count_tiling;
                    sel_write_out_1   <= (count_compute_2 == NO_CYCLE_COMPUTE - 1) ? 1 : sel_write_out_1;
                    sel_write_out_2   <= (count_compute_2 == NO_CYCLE_COMPUTE - 1) ? ~sel_write_out_2 : sel_write_out_2;

                    load_ifm          <= (count_compute_2 <= NO_CYCLE_LOAD - 1) ? 1 : 0;
                    load_wgt          <= 0;
                    ifm_demux         <= (count_compute_2 == 0) ? ~ifm_demux : ifm_demux;
                    ifm_mux           <= (count_compute_2 == 0) ? ~ifm_mux   : ifm_mux;
                    ifm_RF_shift_en_1 <= (ifm_demux == 0) ? ((count_compute_2 <= NO_CYCLE_LOAD + 1) ? 1 : 0) : 1;
                    ifm_RF_shift_en_2 <= (ifm_demux == 1) ? ((count_compute_2 <= NO_CYCLE_LOAD + 1) ? 1 : 0) : 1;

                    for (i = 0; i < SYSTOLIC_SIZE; i = i + 1) begin
                        wgt_RF_shift_en[i] <= (count_compute_2 >= i && count_compute_2 < NO_CYCLE_LOAD + i) ? 1 : 0 ;
                    end

                    select_wgt        <= 0;
                    reset_pe          <= (count_compute_2 == NO_CYCLE_COMPUTE) ? 1 : 0;
                    write_out_pe_en   <= (count_compute_2 <= wgt_size - 1) ? 1 : 0;
                    write_ofm_en      <= (STRIDE == 1) ? ((count_compute_2 <= wgt_size - 1) && (sel_write_out_1 == 1) ? 1 : 0) : ((count_compute_2 <= wgt_size - 1) && (sel_write_out_2 == 1) ? 1 : 0);
                    fifo_rd_clr       <= (STRIDE == 1) ? ((count_compute_2 <= wgt_size - 2 || count_compute_2 == NO_CYCLE_COMPUTE) && (sel_write_out_1 == 1) ? 0 : 1) : ((count_compute_2 <= wgt_size - 2 || count_compute_2 == NO_CYCLE_COMPUTE) && (sel_write_out_2 == 1) ? 0 : 1);
                    fifo_wr_clr       <= (count_compute_2 <= wgt_size - 1) ? 0 : 1 ;
                    fifo_rd_en        <= (STRIDE == 1) ? ((count_compute_2 <= wgt_size - 2 || count_compute_2 == NO_CYCLE_COMPUTE) && (sel_write_out_1 == 1) ? 1 : 0) : ((count_compute_2 <= wgt_size - 2 || count_compute_2 == NO_CYCLE_COMPUTE) && (sel_write_out_2 == 1) ? 1 : 0);
                    fifo_wr_en        <= (count_compute_2 <= wgt_size - 1) ? 1 : 0 ;
                    done              <= 0;
                end
                COMPUTE_WRITE: begin
                    count_compute_2   <= 0 ;
                    count_tiling      <= 0 ;

                    count_compute_1   <= count_compute_1 + 1;
                    sel_write_out_2   <= (count_compute_1 == NO_CYCLE_COMPUTE - 1) ? ~sel_write_out_2 : sel_write_out_2;

                    load_ifm          <= 0 ;
                    load_wgt          <= 0 ;
                    ifm_demux         <= (count_compute_1 == 0) ? ~ifm_demux : ifm_demux;
                    ifm_mux           <= (count_compute_1 == 0) ? ~ifm_mux   : ifm_mux;
                    ifm_RF_shift_en_1 <= 1 ;
                    ifm_RF_shift_en_2 <= 1 ;

                    for (i = 0; i < SYSTOLIC_SIZE; i = i + 1) begin
                        wgt_RF_shift_en[i] <= (count_compute_1 >= i && count_compute_1 < NO_CYCLE_LOAD + i) ? 1 : 0 ;
                    end

                    select_wgt        <= 0;
                    reset_pe          <= 0;
                    write_out_pe_en   <= (count_compute_1 <= wgt_size - 1) ? 1 : 0;
                    write_ofm_en      <= (STRIDE == 1) ? ((count_compute_1 <= wgt_size - 1) ? 1 : 0) : ((count_compute_1 <= wgt_size - 1) && (sel_write_out_2 == 1) ? 1 : 0);
                    fifo_rd_clr       <= (STRIDE == 1) ? ((count_compute_1 <= wgt_size - 2 || count_compute_1 == NO_CYCLE_COMPUTE) ? 0 : 1) : ((count_compute_1 <= wgt_size - 2 || count_compute_1 == NO_CYCLE_COMPUTE) && (sel_write_out_2 == 1) ? 0 : 1);
                    fifo_wr_clr       <= (count_compute_1 <= wgt_size - 1) ? 0 : 1 ;
                    fifo_rd_en        <= (STRIDE == 1) ? ((count_compute_1 <= wgt_size - 2 || count_compute_1 == NO_CYCLE_COMPUTE) ? 1 : 0) : ((count_compute_1 <= wgt_size - 2 || count_compute_1 == NO_CYCLE_COMPUTE) && (sel_write_out_2 == 1) ? 1 : 0);
                    fifo_wr_en        <= (count_compute_1 <= wgt_size - 1) ? 1 : 0 ;
                    done              <= 0;
                end
                WRITE: begin
                    count_compute_1   <= 0;
                    count_write       <= count_write + 1;

                    load_ifm          <= 0 ;
                    load_wgt          <= 0 ;
                    ifm_demux         <= 0 ;
                    ifm_mux           <= 1 ;
                    ifm_RF_shift_en_1 <= 0 ;
                    ifm_RF_shift_en_2 <= 0 ;
                    wgt_RF_shift_en   <= 0 ;
                    select_wgt        <= 0 ;
                    reset_pe          <= 1 ;
                    write_out_pe_en   <= (count_write <= wgt_size - 1) ? 1 : 0 ;
                    write_ofm_en      <= (STRIDE == 1) ? ((count_write <= wgt_size - 1) ? 1 : 0) : ((count_write <= wgt_size - 1) && (sel_write_out_2 == 1) ? 1 : 0);
                    fifo_rd_clr       <= (STRIDE == 1) ? ((count_write <= wgt_size - 2 || count_write == SYSTOLIC_SIZE) ? 0 : 1) : ((count_write <= wgt_size - 2) && (sel_write_out_2 == 1) ? 0 : 1);
                    fifo_wr_clr       <= (count_write <= wgt_size - 1) ? 0 : 1 ;
                    fifo_rd_en        <= (STRIDE == 1) ? ((count_write <= wgt_size - 2 || count_write == SYSTOLIC_SIZE) ? 1 : 0) : ((count_write <= wgt_size - 2) && (sel_write_out_2 == 1) ? 1 : 0);
                    fifo_wr_en        <= (count_write <= wgt_size - 1) ? 1 : 0 ;
                    if (STRIDE != 1 && count_write == SYSTOLIC_SIZE && count_filter == NO_LOAD_FILTER) done <= 1;
                end
                LAST_POOL: begin
                    count_write       <= 0 ;
                    count_pool        <= count_pool + 1;

                    load_ifm          <= 0 ;
                    load_wgt          <= 0 ;
                    ifm_demux         <= 0 ;
                    ifm_mux           <= 1 ;
                    ifm_RF_shift_en_1 <= 0 ;
                    ifm_RF_shift_en_2 <= 0 ;
                    wgt_RF_shift_en   <= 0 ;
                    select_wgt        <= 0 ;
                    reset_pe          <= 1 ;
                    write_out_pe_en   <= 0 ;
                    write_ofm_en      <= (count_pool <= wgt_size - 1) ? 1 : 0;
                    fifo_rd_clr       <= (count_pool <= wgt_size - 2) ? 0 : 1 ;
                    fifo_wr_clr       <= 1 ;
                    fifo_rd_en        <= (count_pool <= wgt_size - 2) ? 1 : 0 ;
                    fifo_wr_en        <= 0 ;
                    if (count_pool == SYSTOLIC_SIZE && count_filter == NO_LOAD_FILTER) done <= 1;
                end
            endcase
        end
    end

endmodule