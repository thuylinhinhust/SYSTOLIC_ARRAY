module shift_reg #(parameter DATA_WIDTH = 8, BUFFER_SIZE = 9) (
	input clk,
	input rst_n,
	input read_en,
	input in_valid,
	input [DATA_WIDTH - 1 : 0] data_in,
	output reg [DATA_WIDTH - 1 : 0] data_out
);
	reg [DATA_WIDTH - 1 : 0] buffer [BUFFER_SIZE - 1 : 0];

	integer i;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_out      <= 0;
			for (i = 0; i < BUFFER_SIZE; i = i + 1) begin
				buffer[i] <= 0;
			end
		end
		else if (in_valid) begin 
			data_out      <= buffer[BUFFER_SIZE - 1];
			for (i = BUFFER_SIZE - 1; i > 0; i = i - 1) begin
				buffer[i] <= buffer[i - 1];
			end
			buffer[0]     <= (read_en) ? data_in : buffer[BUFFER_SIZE - 1];
		end
		else begin
			for (i = 0; i < BUFFER_SIZE; i = i + 1) begin
				buffer[i] <= buffer[i];
			end
		end
	end	
endmodule