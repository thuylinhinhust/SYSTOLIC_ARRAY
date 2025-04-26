module PE #( parameter DATA_WIDTH = 8) (
	input clk,
	input rst_n,
	input  [DATA_WIDTH - 1 : 0]  top_in,
	input  [DATA_WIDTH - 1 : 0]  left_in,
	output reg [DATA_WIDTH - 1 : 0]  right_out,
	output reg [DATA_WIDTH - 1 : 0]  bottom_out
);

reg  [DATA_WIDTH*2 - 1 : 0] result;
wire [DATA_WIDTH*2 - 1 : 0] sum;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		result <= 16'b0;
		right_out  <= 8'b0;
		bottom_out <= 8'b0;
	end
	else begin
		result     <= sum;
		right_out  <= left_in;
		bottom_out <= top_in;
	end
end
assign sum = top_in * left_in;
endmodule
	
	


