module main_controller_tb();

parameter NO_FILTER     = 32 ;
parameter KERNEL_SIZE   = 3  ;
parameter NO_CHANNEL    = 3  ;
parameter SYSTOLIC_SIZE = 16 ;

reg                          clk                                  ;
reg                          rst_n                                ;
reg                          start                                ;
wire                         load_ifm, load_wgt                   ;
wire                         ifm_demux, ifm_mux                   ;
wire                         ifm_RF_shift_en_1, ifm_RF_shift_en_2 ;
wire [SYSTOLIC_SIZE - 1 : 0] wgt_RF_shift_en                      ;
wire                         select_wgt                           ;
wire                         reset_pe                             ;
wire                         write_out_en                         ;

main_controller #(
    .NO_FILTER     ( NO_FILTER     ) ,
    .KERNEL_SIZE   ( KERNEL_SIZE   ) ,
    .NO_CHANNEL    ( NO_CHANNEL    ) ,
    .SYSTOLIC_SIZE ( SYSTOLIC_SIZE )
) main_controller_dut (
    .clk               ( clk               ) ,
    .rst_n             ( rst_n             ) ,
    .start             ( start             ) ,
    .load_ifm          ( load_ifm          ) ,
    .load_wgt          ( load_wgt          ) ,
    .ifm_demux         ( ifm_demux         ) ,
    .ifm_mux           ( ifm_mux           ) ,
    .ifm_RF_shift_en_1 ( ifm_RF_shift_en_1 ) ,
    .ifm_RF_shift_en_2 ( ifm_RF_shift_en_2 ) ,
    .wgt_RF_shift_en   ( wgt_RF_shift_en   ) ,
    .select_wgt        ( select_wgt        ) ,
    .reset_pe          ( reset_pe          ) ,
    .write_out_en      ( write_out_en      )
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    start = 0;

    #30 rst_n = 1;
    #20 start = 1;
    #5000 $finish;
end

initial begin
    $dumpfile ("main_controller.VCD");
    $dumpvars (0, main_controller_tb);
end

endmodule