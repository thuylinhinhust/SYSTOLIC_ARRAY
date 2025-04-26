module BUFFER #(parameter DATA_WIDTH = 8, BUFFER_SIZE = 4) (
	input clk,
	input rst_n,
	input in_valid,
	input [DATA_WIDTH-1:0] data_in,
	output reg [DATA_WIDTH-1:0] data_out
);
	reg [DATA_WIDTH - 1:0] buffer [BUFFER_SIZE - 1:0];

integer i;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_out <= 0;
    buffer[3] <= 0;   
    buffer[2] <= 0; 
    buffer[1] <= 0; 
    buffer[0] <= 0; 
	end
	else if (in_valid) begin 
		data_out    <= buffer[3]      ;
		buffer[3]   <= buffer[2]      ;
		buffer[2]   <= buffer[1]      ;
		buffer[1]   <= buffer[0]      ;
		buffer[0]   <= data_in;
	end
	else begin
		for(i = 0; i < 4 ; i = i + 1) begin
			buffer[i] <= buffer[i];
		end
	end
end	
endmodule
