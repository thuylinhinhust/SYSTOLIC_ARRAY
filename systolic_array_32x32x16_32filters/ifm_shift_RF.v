module ifm_shift_RF #(parameter DATA_WIDTH = 8, BUFFER_SIZE = 27) (
	input                           clk               ,
	input                           rst_n             ,
    input                           ifm_demux         ,
	input                           ifm_mux           ,
    input                           ifm_RF_shift_en_1 ,
    input                           ifm_RF_shift_en_2 ,    
	input      [DATA_WIDTH - 1 : 0] data_in           ,
	output reg [DATA_WIDTH - 1 : 0] data_out
);

	reg [DATA_WIDTH - 1 : 0] buffer_1 [0 : BUFFER_SIZE - 1] ;
	reg [DATA_WIDTH - 1 : 0] buffer_2 [0 : BUFFER_SIZE - 1] ;

	integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
			data_out        <= 0;
			for (i = 0; i < BUFFER_SIZE; i = i + 1) begin
				buffer_1[i] <= 0;
                buffer_2[i] <= 0;
			end
        end
        else begin
            data_out <= (ifm_mux == 0) ? ((ifm_RF_shift_en_1) ? buffer_1[BUFFER_SIZE - 1] : data_out) : ((ifm_RF_shift_en_2) ? buffer_2[BUFFER_SIZE - 1] : data_out);
            for (i = BUFFER_SIZE - 1; i > 0; i = i - 1) begin
                buffer_1[i] <= (ifm_RF_shift_en_1) ? buffer_1[i-1] : buffer_1[i];
                buffer_2[i] <= (ifm_RF_shift_en_2) ? buffer_2[i-1] : buffer_2[i];
            end
            buffer_1[0] <= (ifm_RF_shift_en_1) ? ((ifm_demux == 0) ? data_in : 0) : buffer_1[0];
            buffer_2[0] <= (ifm_RF_shift_en_2) ? ((ifm_demux == 1) ? data_in : 0) : buffer_2[0];
        end 
    end

endmodule