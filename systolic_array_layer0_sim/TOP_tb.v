module TOP_tb();

parameter SYSTOLIC_SIZE = 16 ;
parameter BUFFER_COUNT  = 16 ;
parameter BUFFER_SIZE   = 27 ;
parameter DATA_WIDTH    = 8  ;
parameter INOUT_WIDTH   = 128;

reg                       clk        ;
reg                       rst_n      ;
reg                       start       ;
reg                      ifm_we_a ;
reg                      wgt_we_a ;
//reg                      ofm_we_b ;

TOP #(
    .SYSTOLIC_SIZE ( SYSTOLIC_SIZE ) ,
    .BUFFER_COUNT  ( BUFFER_COUNT  ) ,
    .BUFFER_SIZE  ( BUFFER_SIZE  ) ,
    .DATA_WIDTH  ( DATA_WIDTH  ) ,
    .INOUT_WIDTH  ( INOUT_WIDTH  ) 
) dut (
    .clk        ( clk        ) ,
    .rst_n      ( rst_n      ) ,
    .start       ( start       ) ,
    .ifm_we_a   ( ifm_we_a   ) ,
    .wgt_we_a ( wgt_we_a ) 
    //.ofm_we_b ( ofm_we_b ) 
    
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    start = 0;
    ifm_we_a = 0;
    wgt_we_a = 0;
    //ofm_we_b = 1;

    #30 rst_n = 1; 

end

    initial begin
        $readmemb ("./ifm_bin_c3xh416xw416.txt", dut.dpram_ifm.mem);
    end

    initial begin
        $readmemb ("./weight_bin_co16xci3xk3xk3.txt", dut.dpram_wgt.mem);
    end

    integer i, j;
    integer file;

    initial begin
        wait (dut.done)
        file = $fopen("output_matrix_1.txt", "w");
            for (i = 0; i < 414*16 ; i = i + 1) begin
                for (j = 0; j < 414; j = j + 1) begin
                    $fwrite(file, "%0d ", dut.dpram_ofm.mem[i * 414 + j]);
                end
                $fwrite(file, "\n");
                if((i % 414) == 0) $fwrite(file, "\n");
            end
            $fclose(file);
    end


  /*dut.dpram_ifm.mem[0]  = 8'b00000011;
  dut.dpram_ifm.mem[1]  = 8'b00000001;
  dut.dpram_ifm.mem[2]  = 8'b00001001;
  dut.dpram_ifm.mem[3]  = 8'b00000001;
  dut.dpram_ifm.mem[4]  = 8'b00000011;
  dut.dpram_ifm.mem[5]  = 8'b00000001;
  dut.dpram_ifm.mem[6]  = 8'b11111110;
  dut.dpram_ifm.mem[7]  = 8'b00000000;
  dut.dpram_ifm.mem[8]  = 8'b00001000;
  dut.dpram_ifm.mem[9]  = 8'b11111011;
  dut.dpram_ifm.mem[10] = 8'b00000010;
  dut.dpram_ifm.mem[11] = 8'b00000111;
  dut.dpram_ifm.mem[12] = 8'b00000101;
  dut.dpram_ifm.mem[13] = 8'b00000001;
  dut.dpram_ifm.mem[14] = 8'b11111101;
  dut.dpram_ifm.mem[15] = 8'b00000000;
  dut.dpram_ifm.mem[16] = 8'b00000101;
  dut.dpram_ifm.mem[17] = 8'b00000000;

  dut.dpram_ifm.mem[416] = 8'b00000011;
  dut.dpram_ifm.mem[417] = 8'b11111101;
  dut.dpram_ifm.mem[418] = 8'b11111100;
  dut.dpram_ifm.mem[419] = 8'b00000011;
  dut.dpram_ifm.mem[420] = 8'b00000100;
  dut.dpram_ifm.mem[421] = 8'b00001000;
  dut.dpram_ifm.mem[422] = 8'b00000100;
  dut.dpram_ifm.mem[423] = 8'b00000101;
  dut.dpram_ifm.mem[424] = 8'b00001001;
  dut.dpram_ifm.mem[425] = 8'b00000110;
  dut.dpram_ifm.mem[426] = 8'b00000000;
  dut.dpram_ifm.mem[427] = 8'b11111100;
  dut.dpram_ifm.mem[428] = 8'b11111110;
  dut.dpram_ifm.mem[429] = 8'b11111101;
  dut.dpram_ifm.mem[430] = 8'b00000100;
  dut.dpram_ifm.mem[431] = 8'b11111101;
  dut.dpram_ifm.mem[432] = 8'b00000101;
  dut.dpram_ifm.mem[433] = 8'b11111011;

  dut.dpram_ifm.mem[832] = 8'b11111110;
  dut.dpram_ifm.mem[833] = 8'b00000110;
  dut.dpram_ifm.mem[834] = 8'b00000100;
  dut.dpram_ifm.mem[835] = 8'b11111100;
  dut.dpram_ifm.mem[836] = 8'b00001000;
  dut.dpram_ifm.mem[837] = 8'b00000100;
  dut.dpram_ifm.mem[838] = 8'b00000001;
  dut.dpram_ifm.mem[839] = 8'b00001000;
  dut.dpram_ifm.mem[840] = 8'b11111111;
  dut.dpram_ifm.mem[841] = 8'b11111100;
  dut.dpram_ifm.mem[842] = 8'b11111101;
  dut.dpram_ifm.mem[843] = 8'b00000100;
  dut.dpram_ifm.mem[844] = 8'b00000101;
  dut.dpram_ifm.mem[845] = 8'b00000111;
  dut.dpram_ifm.mem[846] = 8'b00000100;
  dut.dpram_ifm.mem[847] = 8'b00000010;
  dut.dpram_ifm.mem[848] = 8'b00000101;
  dut.dpram_ifm.mem[849] = 8'b11111100;


  dut.dpram_ifm.mem[173056] = 8'b00000000;
  dut.dpram_ifm.mem[173057] = 8'b11111101;
  dut.dpram_ifm.mem[173058] = 8'b00000111;
  dut.dpram_ifm.mem[173059] = 8'b00000000;
  dut.dpram_ifm.mem[173060] = 8'b11111101;
  dut.dpram_ifm.mem[173061] = 8'b00000100;
  dut.dpram_ifm.mem[173062] = 8'b11111101;
  dut.dpram_ifm.mem[173063] = 8'b00001001;
  dut.dpram_ifm.mem[173064] = 8'b00001000;
  dut.dpram_ifm.mem[173065] = 8'b00000010;
  dut.dpram_ifm.mem[173066] = 8'b00000111;
  dut.dpram_ifm.mem[173067] = 8'b11111110;
  dut.dpram_ifm.mem[173068] = 8'b00000001;
  dut.dpram_ifm.mem[173069] = 8'b11111111;
  dut.dpram_ifm.mem[173070] = 8'b11111100;
  dut.dpram_ifm.mem[173071] = 8'b00000000;
  dut.dpram_ifm.mem[173072] = 8'b00001000;
  dut.dpram_ifm.mem[173073] = 8'b00000110;

  dut.dpram_ifm.mem[173472] = 8'b00001000;
  dut.dpram_ifm.mem[173473] = 8'b00001000;
  dut.dpram_ifm.mem[173474] = 8'b00001000;
  dut.dpram_ifm.mem[173475] = 8'b11111101;
  dut.dpram_ifm.mem[173476] = 8'b00000111;
  dut.dpram_ifm.mem[173477] = 8'b00000100;
  dut.dpram_ifm.mem[173478] = 8'b00000000;
  dut.dpram_ifm.mem[173479] = 8'b00001001;
  dut.dpram_ifm.mem[173480] = 8'b00000111;
  dut.dpram_ifm.mem[173481] = 8'b11111111;
  dut.dpram_ifm.mem[173482] = 8'b00000100;
  dut.dpram_ifm.mem[173483] = 8'b00000010;
  dut.dpram_ifm.mem[173484] = 8'b11111100;
  dut.dpram_ifm.mem[173485] = 8'b00000001;
  dut.dpram_ifm.mem[173486] = 8'b00000110;
  dut.dpram_ifm.mem[173487] = 8'b11111011;
  dut.dpram_ifm.mem[173488] = 8'b00000100;
  dut.dpram_ifm.mem[173489] = 8'b00001001;

  dut.dpram_ifm.mem[173888] = 8'b00000101;
  dut.dpram_ifm.mem[173889] = 8'b00000001;
  dut.dpram_ifm.mem[173890] = 8'b11111101;
  dut.dpram_ifm.mem[173891] = 8'b00000010;
  dut.dpram_ifm.mem[173892] = 8'b00000111;
  dut.dpram_ifm.mem[173893] = 8'b00000010;
  dut.dpram_ifm.mem[173894] = 8'b00001001;
  dut.dpram_ifm.mem[173895] = 8'b11111011;
  dut.dpram_ifm.mem[173896] = 8'b00001000;
  dut.dpram_ifm.mem[173897] = 8'b00000010;
  dut.dpram_ifm.mem[173898] = 8'b11111101;
  dut.dpram_ifm.mem[173899] = 8'b11111011;
  dut.dpram_ifm.mem[173900] = 8'b00000001;
  dut.dpram_ifm.mem[173901] = 8'b11111101;
  dut.dpram_ifm.mem[173902] = 8'b11111111;
  dut.dpram_ifm.mem[173903] = 8'b00001000;
  dut.dpram_ifm.mem[173904] = 8'b00000001;
  dut.dpram_ifm.mem[173905] = 8'b00000011;


  dut.dpram_ifm.mem[346112] = 8'b00000011;
  dut.dpram_ifm.mem[346113] = 8'b00000010;
  dut.dpram_ifm.mem[346114] = 8'b11111100;
  dut.dpram_ifm.mem[346115] = 8'b00000001;
  dut.dpram_ifm.mem[346116] = 8'b00000111;
  dut.dpram_ifm.mem[346117] = 8'b00000001;
  dut.dpram_ifm.mem[346118] = 8'b00000001;
  dut.dpram_ifm.mem[346119] = 8'b11111100;
  dut.dpram_ifm.mem[346120] = 8'b00000010;
  dut.dpram_ifm.mem[346121] = 8'b00000111;
  dut.dpram_ifm.mem[346122] = 8'b11111011;
  dut.dpram_ifm.mem[346123] = 8'b11111100;
  dut.dpram_ifm.mem[346124] = 8'b11111101;
  dut.dpram_ifm.mem[346125] = 8'b11111100;
  dut.dpram_ifm.mem[346126] = 8'b00000001;
  dut.dpram_ifm.mem[346127] = 8'b00000010;
  dut.dpram_ifm.mem[346128] = 8'b11111100;
  dut.dpram_ifm.mem[346129] = 8'b00000111;

  dut.dpram_ifm.mem[346528] = 8'b00000001;
  dut.dpram_ifm.mem[346529] = 8'b00000110;
  dut.dpram_ifm.mem[346530] = 8'b00000000;
  dut.dpram_ifm.mem[346531] = 8'b11111100;
  dut.dpram_ifm.mem[346532] = 8'b11111101;
  dut.dpram_ifm.mem[346533] = 8'b00000110;
  dut.dpram_ifm.mem[346534] = 8'b11111111;
  dut.dpram_ifm.mem[346535] = 8'b00000110;
  dut.dpram_ifm.mem[346536] = 8'b00000001;
  dut.dpram_ifm.mem[346537] = 8'b00000001;
  dut.dpram_ifm.mem[346538] = 8'b11111011;
  dut.dpram_ifm.mem[346539] = 8'b00000011;
  dut.dpram_ifm.mem[346540] = 8'b00000001;
  dut.dpram_ifm.mem[346541] = 8'b00000001;
  dut.dpram_ifm.mem[346542] = 8'b00000110;
  dut.dpram_ifm.mem[346543] = 8'b11111011;
  dut.dpram_ifm.mem[346544] = 8'b00000100;
  dut.dpram_ifm.mem[346545] = 8'b11111011;

  dut.dpram_ifm.mem[346944] = 8'b00000001;
  dut.dpram_ifm.mem[346945] = 8'b00000011;
  dut.dpram_ifm.mem[346946] = 8'b00000011;
  dut.dpram_ifm.mem[346947] = 8'b11111110;
  dut.dpram_ifm.mem[346948] = 8'b00000111;
  dut.dpram_ifm.mem[346949] = 8'b00000000;
  dut.dpram_ifm.mem[346950] = 8'b11111101;
  dut.dpram_ifm.mem[346951] = 8'b00000101;
  dut.dpram_ifm.mem[346952] = 8'b00000101;
  dut.dpram_ifm.mem[346953] = 8'b00000010;
  dut.dpram_ifm.mem[346954] = 8'b00000110;
  dut.dpram_ifm.mem[346955] = 8'b11111110;
  dut.dpram_ifm.mem[346956] = 8'b00000000;
  dut.dpram_ifm.mem[346957] = 8'b00000010;
  dut.dpram_ifm.mem[346958] = 8'b11111101;
  dut.dpram_ifm.mem[346959] = 8'b00000000;
  dut.dpram_ifm.mem[346960] = 8'b00000100;
  dut.dpram_ifm.mem[346961] = 8'b00000011;


  dut.dpram_wgt.mem[0]   = 8'b00000000;
  dut.dpram_wgt.mem[1]   = 8'b11111101;
  dut.dpram_wgt.mem[2]   = 8'b00000100;
  dut.dpram_wgt.mem[3]   = 8'b11111010;
  dut.dpram_wgt.mem[4]   = 8'b00000100;
  dut.dpram_wgt.mem[5]   = 8'b11111101;
  dut.dpram_wgt.mem[6]   = 8'b11111111;
  dut.dpram_wgt.mem[7]   = 8'b11111110;
  dut.dpram_wgt.mem[8]   = 8'b11111010;
  dut.dpram_wgt.mem[9]   = 8'b00001000;
  dut.dpram_wgt.mem[10]  = 8'b00000111;
  dut.dpram_wgt.mem[11]  = 8'b11111110;
  dut.dpram_wgt.mem[12]  = 8'b00000110;
  dut.dpram_wgt.mem[13]  = 8'b11111011;
  dut.dpram_wgt.mem[14]  = 8'b00001000;
  dut.dpram_wgt.mem[15]  = 8'b00000001;

  dut.dpram_wgt.mem[16]  = 8'b00000111;
  dut.dpram_wgt.mem[17]  = 8'b00000010;
  dut.dpram_wgt.mem[18]  = 8'b11111111;
  dut.dpram_wgt.mem[19]  = 8'b11111011;
  dut.dpram_wgt.mem[20]  = 8'b11111011;
  dut.dpram_wgt.mem[21]  = 8'b00000001;
  dut.dpram_wgt.mem[22]  = 8'b11111100;
  dut.dpram_wgt.mem[23]  = 8'b11111101;
  dut.dpram_wgt.mem[24]  = 8'b11111100;
  dut.dpram_wgt.mem[25]  = 8'b11111110;
  dut.dpram_wgt.mem[26]  = 8'b00000101;
  dut.dpram_wgt.mem[27]  = 8'b11111100;
  dut.dpram_wgt.mem[28]  = 8'b11111011;
  dut.dpram_wgt.mem[29]  = 8'b00001000;
  dut.dpram_wgt.mem[30]  = 8'b11111101;
  dut.dpram_wgt.mem[31]  = 8'b11111110;

  dut.dpram_wgt.mem[32]  = 8'b00000100;
  dut.dpram_wgt.mem[33]  = 8'b11111011;
  dut.dpram_wgt.mem[34]  = 8'b00000011;
  dut.dpram_wgt.mem[35]  = 8'b11111010;
  dut.dpram_wgt.mem[36]  = 8'b00000111;
  dut.dpram_wgt.mem[37]  = 8'b11111100;
  dut.dpram_wgt.mem[38]  = 8'b11111111;
  dut.dpram_wgt.mem[39]  = 8'b00000100;
  dut.dpram_wgt.mem[40]  = 8'b00000100;
  dut.dpram_wgt.mem[41]  = 8'b00000101;
  dut.dpram_wgt.mem[42]  = 8'b11111100;
  dut.dpram_wgt.mem[43]  = 8'b11111010;
  dut.dpram_wgt.mem[44]  = 8'b11111011;
  dut.dpram_wgt.mem[45]  = 8'b11111011;
  dut.dpram_wgt.mem[46]  = 8'b00000001;
  dut.dpram_wgt.mem[47]  = 8'b11111100;
  
  dut.dpram_wgt.mem[48]  = 8'b00000101;
  dut.dpram_wgt.mem[49]  = 8'b00001000;
  dut.dpram_wgt.mem[50]  = 8'b00000001;
  dut.dpram_wgt.mem[51]  = 8'b11111110;
  dut.dpram_wgt.mem[52]  = 8'b00000010;
  dut.dpram_wgt.mem[53]  = 8'b11111011;
  dut.dpram_wgt.mem[54]  = 8'b00000101;
  dut.dpram_wgt.mem[55]  = 8'b11111110;
  dut.dpram_wgt.mem[56]  = 8'b00000011;
  dut.dpram_wgt.mem[57]  = 8'b11111100;
  dut.dpram_wgt.mem[58]  = 8'b00000010;
  dut.dpram_wgt.mem[59]  = 8'b00000111;
  dut.dpram_wgt.mem[60]  = 8'b00000101;
  dut.dpram_wgt.mem[61]  = 8'b00000110;
  dut.dpram_wgt.mem[62]  = 8'b00000110;
  dut.dpram_wgt.mem[63]  = 8'b00000110;

  dut.dpram_wgt.mem[64]  = 8'b00000111;
  dut.dpram_wgt.mem[65]  = 8'b11111100;
  dut.dpram_wgt.mem[66]  = 8'b00000101;
  dut.dpram_wgt.mem[67]  = 8'b00000001;
  dut.dpram_wgt.mem[68]  = 8'b00000000;
  dut.dpram_wgt.mem[69]  = 8'b11111101;
  dut.dpram_wgt.mem[70]  = 8'b00000000;
  dut.dpram_wgt.mem[71]  = 8'b00000110;
  dut.dpram_wgt.mem[72]  = 8'b11111100;
  dut.dpram_wgt.mem[73]  = 8'b00000000;
  dut.dpram_wgt.mem[74]  = 8'b11111011;
  dut.dpram_wgt.mem[75]  = 8'b00000100;
  dut.dpram_wgt.mem[76]  = 8'b00000111;
  dut.dpram_wgt.mem[77]  = 8'b00000111;
  dut.dpram_wgt.mem[78]  = 8'b00000000;
  dut.dpram_wgt.mem[79]  = 8'b11111101;

  dut.dpram_wgt.mem[80]  = 8'b11111010;
  dut.dpram_wgt.mem[81]  = 8'b00000011;
  dut.dpram_wgt.mem[82]  = 8'b11111100;
  dut.dpram_wgt.mem[83]  = 8'b11111100;
  dut.dpram_wgt.mem[84]  = 8'b11111100;
  dut.dpram_wgt.mem[85]  = 8'b11111011;
  dut.dpram_wgt.mem[86]  = 8'b11111011;
  dut.dpram_wgt.mem[87]  = 8'b00000110;
  dut.dpram_wgt.mem[88]  = 8'b00000100;
  dut.dpram_wgt.mem[89]  = 8'b00000010;
  dut.dpram_wgt.mem[90]  = 8'b00000011;
  dut.dpram_wgt.mem[91]  = 8'b11111110;
  dut.dpram_wgt.mem[92]  = 8'b00000010;
  dut.dpram_wgt.mem[93]  = 8'b11111011;
  dut.dpram_wgt.mem[94]  = 8'b00000111;
  dut.dpram_wgt.mem[95]  = 8'b11111010;

  dut.dpram_wgt.mem[96]  = 8'b00001000;
  dut.dpram_wgt.mem[97]  = 8'b11111011;
  dut.dpram_wgt.mem[98]  = 8'b11111010;
  dut.dpram_wgt.mem[99]  = 8'b11111101;
  dut.dpram_wgt.mem[100] = 8'b00000111;
  dut.dpram_wgt.mem[101] = 8'b00000100;
  dut.dpram_wgt.mem[102] = 8'b11111101;
  dut.dpram_wgt.mem[103] = 8'b00000111;
  dut.dpram_wgt.mem[104] = 8'b11111011;
  dut.dpram_wgt.mem[105] = 8'b11111011;
  dut.dpram_wgt.mem[106] = 8'b00000100;
  dut.dpram_wgt.mem[107] = 8'b00001000;
  dut.dpram_wgt.mem[108] = 8'b00000101;
  dut.dpram_wgt.mem[109] = 8'b00000011;
  dut.dpram_wgt.mem[110] = 8'b00000001;
  dut.dpram_wgt.mem[111] = 8'b00000010;

  dut.dpram_wgt.mem[112] = 8'b00000011;
  dut.dpram_wgt.mem[113] = 8'b00000110;
  dut.dpram_wgt.mem[114] = 8'b11111111;
  dut.dpram_wgt.mem[115] = 8'b00000111;
  dut.dpram_wgt.mem[116] = 8'b11111110;
  dut.dpram_wgt.mem[117] = 8'b11111101;
  dut.dpram_wgt.mem[118] = 8'b11111010;
  dut.dpram_wgt.mem[119] = 8'b00000011;
  dut.dpram_wgt.mem[120] = 8'b11111111;
  dut.dpram_wgt.mem[121] = 8'b00001000;
  dut.dpram_wgt.mem[122] = 8'b00000010;
  dut.dpram_wgt.mem[123] = 8'b00000101;
  dut.dpram_wgt.mem[124] = 8'b00000111;
  dut.dpram_wgt.mem[125] = 8'b00000110;
  dut.dpram_wgt.mem[126] = 8'b00000110;
  dut.dpram_wgt.mem[127] = 8'b11111010;

  dut.dpram_wgt.mem[128] = 8'b11111110;
  dut.dpram_wgt.mem[129] = 8'b00000100;
  dut.dpram_wgt.mem[130] = 8'b11111011;
  dut.dpram_wgt.mem[131] = 8'b11111100;
  dut.dpram_wgt.mem[132] = 8'b00000111;
  dut.dpram_wgt.mem[133] = 8'b11111101;
  dut.dpram_wgt.mem[134] = 8'b00000010;
  dut.dpram_wgt.mem[135] = 8'b00000101;
  dut.dpram_wgt.mem[136] = 8'b00000000;
  dut.dpram_wgt.mem[137] = 8'b11111100;
  dut.dpram_wgt.mem[138] = 8'b00000100;
  dut.dpram_wgt.mem[139] = 8'b11111101;
  dut.dpram_wgt.mem[140] = 8'b00000100;
  dut.dpram_wgt.mem[141] = 8'b00000110;
  dut.dpram_wgt.mem[142] = 8'b11111110;
  dut.dpram_wgt.mem[143] = 8'b00000011;

  dut.dpram_wgt.mem[144] = 8'b00000101;
  dut.dpram_wgt.mem[145] = 8'b00000011;
  dut.dpram_wgt.mem[146] = 8'b11111011;
  dut.dpram_wgt.mem[147] = 8'b11111100;
  dut.dpram_wgt.mem[148] = 8'b11111010;
  dut.dpram_wgt.mem[149] = 8'b11111100;
  dut.dpram_wgt.mem[150] = 8'b00000100;
  dut.dpram_wgt.mem[151] = 8'b00000000;
  dut.dpram_wgt.mem[152] = 8'b00000011;
  dut.dpram_wgt.mem[153] = 8'b00000011;
  dut.dpram_wgt.mem[154] = 8'b00001000;
  dut.dpram_wgt.mem[155] = 8'b00000011;
  dut.dpram_wgt.mem[156] = 8'b00000111;
  dut.dpram_wgt.mem[157] = 8'b00000110;
  dut.dpram_wgt.mem[158] = 8'b00000111;
  dut.dpram_wgt.mem[159] = 8'b00000000;

  dut.dpram_wgt.mem[160] = 8'b00000011;
  dut.dpram_wgt.mem[161] = 8'b00000000;
  dut.dpram_wgt.mem[162] = 8'b00000010;
  dut.dpram_wgt.mem[163] = 8'b00000101;
  dut.dpram_wgt.mem[164] = 8'b00000011;
  dut.dpram_wgt.mem[165] = 8'b11111010;
  dut.dpram_wgt.mem[166] = 8'b00000010;
  dut.dpram_wgt.mem[167] = 8'b00000001;
  dut.dpram_wgt.mem[168] = 8'b11111111;
  dut.dpram_wgt.mem[169] = 8'b11111110;
  dut.dpram_wgt.mem[170] = 8'b00000001;
  dut.dpram_wgt.mem[171] = 8'b11111100;
  dut.dpram_wgt.mem[172] = 8'b11111111;
  dut.dpram_wgt.mem[173] = 8'b11111101;
  dut.dpram_wgt.mem[174] = 8'b11111100;
  dut.dpram_wgt.mem[175] = 8'b00000001;

  dut.dpram_wgt.mem[176] = 8'b11111101;
  dut.dpram_wgt.mem[177] = 8'b11111110;
  dut.dpram_wgt.mem[178] = 8'b00000001;
  dut.dpram_wgt.mem[179] = 8'b00000000;
  dut.dpram_wgt.mem[180] = 8'b00000011;
  dut.dpram_wgt.mem[181] = 8'b00000001;
  dut.dpram_wgt.mem[182] = 8'b00000010;
  dut.dpram_wgt.mem[183] = 8'b00001000;
  dut.dpram_wgt.mem[184] = 8'b00000100;
  dut.dpram_wgt.mem[185] = 8'b00001000;
  dut.dpram_wgt.mem[186] = 8'b00000011;
  dut.dpram_wgt.mem[187] = 8'b00000010;
  dut.dpram_wgt.mem[188] = 8'b11111010;
  dut.dpram_wgt.mem[189] = 8'b00000101;
  dut.dpram_wgt.mem[190] = 8'b00000110;
  dut.dpram_wgt.mem[191] = 8'b00000110;

  dut.dpram_wgt.mem[192] = 8'b00000011;
  dut.dpram_wgt.mem[193] = 8'b11111100;
  dut.dpram_wgt.mem[194] = 8'b11111110;
  dut.dpram_wgt.mem[195] = 8'b00000011;
  dut.dpram_wgt.mem[196] = 8'b00000111;
  dut.dpram_wgt.mem[197] = 8'b00000111;
  dut.dpram_wgt.mem[198] = 8'b00000111;
  dut.dpram_wgt.mem[199] = 8'b11111011;
  dut.dpram_wgt.mem[200] = 8'b00000000;
  dut.dpram_wgt.mem[201] = 8'b00000011;
  dut.dpram_wgt.mem[202] = 8'b11111101;
  dut.dpram_wgt.mem[203] = 8'b00000100;
  dut.dpram_wgt.mem[204] = 8'b00000000;
  dut.dpram_wgt.mem[205] = 8'b11111111;
  dut.dpram_wgt.mem[206] = 8'b11111110;
  dut.dpram_wgt.mem[207] = 8'b11111101;

  dut.dpram_wgt.mem[208] = 8'b00000001;
  dut.dpram_wgt.mem[209] = 8'b00000011;
  dut.dpram_wgt.mem[210] = 8'b00000011;
  dut.dpram_wgt.mem[211] = 8'b11111101;
  dut.dpram_wgt.mem[212] = 8'b00000111;
  dut.dpram_wgt.mem[213] = 8'b11111010;
  dut.dpram_wgt.mem[214] = 8'b00000100;
  dut.dpram_wgt.mem[215] = 8'b11111010;
  dut.dpram_wgt.mem[216] = 8'b00000101;
  dut.dpram_wgt.mem[217] = 8'b11111011;
  dut.dpram_wgt.mem[218] = 8'b11111101;
  dut.dpram_wgt.mem[219] = 8'b11111010;
  dut.dpram_wgt.mem[220] = 8'b00000010;
  dut.dpram_wgt.mem[221] = 8'b00000100;
  dut.dpram_wgt.mem[222] = 8'b00000100;
  dut.dpram_wgt.mem[223] = 8'b00000001;

  dut.dpram_wgt.mem[224] = 8'b11111010;
  dut.dpram_wgt.mem[225] = 8'b00000000;
  dut.dpram_wgt.mem[226] = 8'b11111010;
  dut.dpram_wgt.mem[227] = 8'b11111111;
  dut.dpram_wgt.mem[228] = 8'b00000011;
  dut.dpram_wgt.mem[229] = 8'b00000110;
  dut.dpram_wgt.mem[230] = 8'b11111010;
  dut.dpram_wgt.mem[231] = 8'b11111011;
  dut.dpram_wgt.mem[232] = 8'b11111110;
  dut.dpram_wgt.mem[233] = 8'b00000101;
  dut.dpram_wgt.mem[234] = 8'b00000001;
  dut.dpram_wgt.mem[235] = 8'b00000010;
  dut.dpram_wgt.mem[236] = 8'b00000111;
  dut.dpram_wgt.mem[237] = 8'b00000110;
  dut.dpram_wgt.mem[238] = 8'b11111110;
  dut.dpram_wgt.mem[239] = 8'b00001000;

  dut.dpram_wgt.mem[240] = 8'b11111011;
  dut.dpram_wgt.mem[241] = 8'b00000011;
  dut.dpram_wgt.mem[242] = 8'b11111111;
  dut.dpram_wgt.mem[243] = 8'b00000111;
  dut.dpram_wgt.mem[244] = 8'b11111011;
  dut.dpram_wgt.mem[245] = 8'b00000100;
  dut.dpram_wgt.mem[246] = 8'b00000100;
  dut.dpram_wgt.mem[247] = 8'b00000010;
  dut.dpram_wgt.mem[248] = 8'b11111011;
  dut.dpram_wgt.mem[249] = 8'b00000010;
  dut.dpram_wgt.mem[250] = 8'b00000011;
  dut.dpram_wgt.mem[251] = 8'b00000001;
  dut.dpram_wgt.mem[252] = 8'b00000010;
  dut.dpram_wgt.mem[253] = 8'b00000100;
  dut.dpram_wgt.mem[254] = 8'b11111100;
  dut.dpram_wgt.mem[255] = 8'b00000110;

  dut.dpram_wgt.mem[256] = 8'b11111100;
  dut.dpram_wgt.mem[257] = 8'b11111101;
  dut.dpram_wgt.mem[258] = 8'b00000111;
  dut.dpram_wgt.mem[259] = 8'b00000110;
  dut.dpram_wgt.mem[260] = 8'b11111101;
  dut.dpram_wgt.mem[261] = 8'b00000101;
  dut.dpram_wgt.mem[262] = 8'b00000111;
  dut.dpram_wgt.mem[263] = 8'b00000000;
  dut.dpram_wgt.mem[264] = 8'b00000011;
  dut.dpram_wgt.mem[265] = 8'b00000111;
  dut.dpram_wgt.mem[266] = 8'b00000100;
  dut.dpram_wgt.mem[267] = 8'b11111100;
  dut.dpram_wgt.mem[268] = 8'b00000011;
  dut.dpram_wgt.mem[269] = 8'b11111101;
  dut.dpram_wgt.mem[270] = 8'b00000001;
  dut.dpram_wgt.mem[271] = 8'b00000011;

  dut.dpram_wgt.mem[272] = 8'b11111111;
  dut.dpram_wgt.mem[273] = 8'b00001000;
  dut.dpram_wgt.mem[274] = 8'b11111011;
  dut.dpram_wgt.mem[275] = 8'b00000001;
  dut.dpram_wgt.mem[276] = 8'b00000001;
  dut.dpram_wgt.mem[277] = 8'b11111110;
  dut.dpram_wgt.mem[278] = 8'b11111100;
  dut.dpram_wgt.mem[279] = 8'b11111111;
  dut.dpram_wgt.mem[280] = 8'b11111011;
  dut.dpram_wgt.mem[281] = 8'b11111010;
  dut.dpram_wgt.mem[282] = 8'b00000010;
  dut.dpram_wgt.mem[283] = 8'b11111110;
  dut.dpram_wgt.mem[284] = 8'b00000000;
  dut.dpram_wgt.mem[285] = 8'b00000001;
  dut.dpram_wgt.mem[286] = 8'b00000100;
  dut.dpram_wgt.mem[287] = 8'b00000000;

  dut.dpram_wgt.mem[288] = 8'b11111111;
  dut.dpram_wgt.mem[289] = 8'b00000111;
  dut.dpram_wgt.mem[290] = 8'b11111100;
  dut.dpram_wgt.mem[291] = 8'b11111010;
  dut.dpram_wgt.mem[292] = 8'b11111100;
  dut.dpram_wgt.mem[293] = 8'b11111011;
  dut.dpram_wgt.mem[294] = 8'b11111011;
  dut.dpram_wgt.mem[295] = 8'b00000101;
  dut.dpram_wgt.mem[296] = 8'b11111101;
  dut.dpram_wgt.mem[297] = 8'b11111100;
  dut.dpram_wgt.mem[298] = 8'b00000101;
  dut.dpram_wgt.mem[299] = 8'b00001000;
  dut.dpram_wgt.mem[300] = 8'b00000011;
  dut.dpram_wgt.mem[301] = 8'b00001000;
  dut.dpram_wgt.mem[302] = 8'b00001000;
  dut.dpram_wgt.mem[303] = 8'b11111111;

  dut.dpram_wgt.mem[304] = 8'b00000011;
  dut.dpram_wgt.mem[305] = 8'b00000110;
  dut.dpram_wgt.mem[306] = 8'b11111010;
  dut.dpram_wgt.mem[307] = 8'b11111011;
  dut.dpram_wgt.mem[308] = 8'b00000000;
  dut.dpram_wgt.mem[309] = 8'b00000010;
  dut.dpram_wgt.mem[310] = 8'b00001000;
  dut.dpram_wgt.mem[311] = 8'b11111010;
  dut.dpram_wgt.mem[312] = 8'b00000000;
  dut.dpram_wgt.mem[313] = 8'b00000011;
  dut.dpram_wgt.mem[314] = 8'b00000000;
  dut.dpram_wgt.mem[315] = 8'b11111011;
  dut.dpram_wgt.mem[316] = 8'b00000100;
  dut.dpram_wgt.mem[317] = 8'b00000100;
  dut.dpram_wgt.mem[318] = 8'b00000010;
  dut.dpram_wgt.mem[319] = 8'b00000011;

  dut.dpram_wgt.mem[320] = 8'b00000000;
  dut.dpram_wgt.mem[321] = 8'b00001000;
  dut.dpram_wgt.mem[322] = 8'b11111110;
  dut.dpram_wgt.mem[323] = 8'b00000110;
  dut.dpram_wgt.mem[324] = 8'b00000110;
  dut.dpram_wgt.mem[325] = 8'b00001000;
  dut.dpram_wgt.mem[326] = 8'b11111111;
  dut.dpram_wgt.mem[327] = 8'b00000011;
  dut.dpram_wgt.mem[328] = 8'b00000011;
  dut.dpram_wgt.mem[329] = 8'b11111011;
  dut.dpram_wgt.mem[330] = 8'b11111110;
  dut.dpram_wgt.mem[331] = 8'b11111010;
  dut.dpram_wgt.mem[332] = 8'b11111110;
  dut.dpram_wgt.mem[333] = 8'b11111110;
  dut.dpram_wgt.mem[334] = 8'b11111110;
  dut.dpram_wgt.mem[335] = 8'b00000110;

  dut.dpram_wgt.mem[336] = 8'b00000100;
  dut.dpram_wgt.mem[337] = 8'b00000000;
  dut.dpram_wgt.mem[338] = 8'b00000011;
  dut.dpram_wgt.mem[339] = 8'b00000011;
  dut.dpram_wgt.mem[340] = 8'b00000111;
  dut.dpram_wgt.mem[341] = 8'b11111101;
  dut.dpram_wgt.mem[342] = 8'b00000011;
  dut.dpram_wgt.mem[343] = 8'b00000010;
  dut.dpram_wgt.mem[344] = 8'b00000100;
  dut.dpram_wgt.mem[345] = 8'b00000101;
  dut.dpram_wgt.mem[346] = 8'b00000010;
  dut.dpram_wgt.mem[347] = 8'b00000100;
  dut.dpram_wgt.mem[348] = 8'b11111100;
  dut.dpram_wgt.mem[349] = 8'b00000001;
  dut.dpram_wgt.mem[350] = 8'b00000111;
  dut.dpram_wgt.mem[351] = 8'b00000010;

  dut.dpram_wgt.mem[352] = 8'b00000010;
  dut.dpram_wgt.mem[353] = 8'b00000001;
  dut.dpram_wgt.mem[354] = 8'b00000110;
  dut.dpram_wgt.mem[355] = 8'b00001000;
  dut.dpram_wgt.mem[356] = 8'b00000011;
  dut.dpram_wgt.mem[357] = 8'b11111111;
  dut.dpram_wgt.mem[358] = 8'b00000001;
  dut.dpram_wgt.mem[359] = 8'b00000110;
  dut.dpram_wgt.mem[360] = 8'b00000010;
  dut.dpram_wgt.mem[361] = 8'b00000011;
  dut.dpram_wgt.mem[362] = 8'b00001000;
  dut.dpram_wgt.mem[363] = 8'b11111111;
  dut.dpram_wgt.mem[364] = 8'b00000001;
  dut.dpram_wgt.mem[365] = 8'b00000001;
  dut.dpram_wgt.mem[366] = 8'b11111011;
  dut.dpram_wgt.mem[367] = 8'b11111101;

  dut.dpram_wgt.mem[368] = 8'b11111011;
  dut.dpram_wgt.mem[369] = 8'b00000101;
  dut.dpram_wgt.mem[370] = 8'b00000001;
  dut.dpram_wgt.mem[371] = 8'b00001000;
  dut.dpram_wgt.mem[372] = 8'b00000100;
  dut.dpram_wgt.mem[373] = 8'b00001000;
  dut.dpram_wgt.mem[374] = 8'b11111100;
  dut.dpram_wgt.mem[375] = 8'b11111111;
  dut.dpram_wgt.mem[376] = 8'b00000110;
  dut.dpram_wgt.mem[377] = 8'b00000100;
  dut.dpram_wgt.mem[378] = 8'b11111101;
  dut.dpram_wgt.mem[379] = 8'b00000101;
  dut.dpram_wgt.mem[380] = 8'b00000111;
  dut.dpram_wgt.mem[381] = 8'b00000101;
  dut.dpram_wgt.mem[382] = 8'b11111011;
  dut.dpram_wgt.mem[383] = 8'b11111100;

  dut.dpram_wgt.mem[384] = 8'b11111110;
  dut.dpram_wgt.mem[385] = 8'b00000110;
  dut.dpram_wgt.mem[386] = 8'b11111100;
  dut.dpram_wgt.mem[387] = 8'b00000010;
  dut.dpram_wgt.mem[388] = 8'b11111011;
  dut.dpram_wgt.mem[389] = 8'b00000110;
  dut.dpram_wgt.mem[390] = 8'b00000000;
  dut.dpram_wgt.mem[391] = 8'b00000111;
  dut.dpram_wgt.mem[392] = 8'b11111010;
  dut.dpram_wgt.mem[393] = 8'b11111111;
  dut.dpram_wgt.mem[394] = 8'b00000010;
  dut.dpram_wgt.mem[395] = 8'b00000110;
  dut.dpram_wgt.mem[396] = 8'b00000001;
  dut.dpram_wgt.mem[397] = 8'b00000100;
  dut.dpram_wgt.mem[398] = 8'b00000011;
  dut.dpram_wgt.mem[399] = 8'b11111101;

  dut.dpram_wgt.mem[400] = 8'b00000001;
  dut.dpram_wgt.mem[401] = 8'b11111011;
  dut.dpram_wgt.mem[402] = 8'b00001000;
  dut.dpram_wgt.mem[403] = 8'b00000111;
  dut.dpram_wgt.mem[404] = 8'b11111111;
  dut.dpram_wgt.mem[405] = 8'b00000000;
  dut.dpram_wgt.mem[406] = 8'b11111011;
  dut.dpram_wgt.mem[407] = 8'b00000011;
  dut.dpram_wgt.mem[408] = 8'b00000101;
  dut.dpram_wgt.mem[409] = 8'b00000010;
  dut.dpram_wgt.mem[410] = 8'b11111011;
  dut.dpram_wgt.mem[411] = 8'b11111100;
  dut.dpram_wgt.mem[412] = 8'b11111111;
  dut.dpram_wgt.mem[413] = 8'b00000001;
  dut.dpram_wgt.mem[414] = 8'b00000010;
  dut.dpram_wgt.mem[415] = 8'b00000011;

  dut.dpram_wgt.mem[416] = 8'b00000100;
  dut.dpram_wgt.mem[417] = 8'b00000001;
  dut.dpram_wgt.mem[418] = 8'b11111010;
  dut.dpram_wgt.mem[419] = 8'b11111100;
  dut.dpram_wgt.mem[420] = 8'b00000111;
  dut.dpram_wgt.mem[421] = 8'b11111101;
  dut.dpram_wgt.mem[422] = 8'b11111100;
  dut.dpram_wgt.mem[423] = 8'b00001000;
  dut.dpram_wgt.mem[424] = 8'b00000100;
  dut.dpram_wgt.mem[425] = 8'b00000111;
  dut.dpram_wgt.mem[426] = 8'b00000111;
  dut.dpram_wgt.mem[427] = 8'b00000101;
  dut.dpram_wgt.mem[428] = 8'b00000100;
  dut.dpram_wgt.mem[429] = 8'b00000010;
  dut.dpram_wgt.mem[430] = 8'b11111101;
  dut.dpram_wgt.mem[431] = 8'b11111100;*/

initial begin
    #50 start = 1;
    #20 start = 0;

    #10000000 $finish;
end
initial begin 
    $monitor( " counter write = %d " , dut.main_control.count_write );
    $monitor( " counter filter = %d " , dut.main_control.count_filter );
end
initial begin
    $dumpfile ("TOPv2.VCD");
    $dumpvars (0, TOP_tb);
end

endmodule