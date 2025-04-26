module PE #(parameter DATA_WIDTH = 8) (
	input clk,
	input rst_n,
	input  [DATA_WIDTH - 1 : 0]  top_in,
	input  [DATA_WIDTH - 1 : 0]  left_in,
	output reg [DATA_WIDTH - 1 : 0]  right_out,
	output reg [DATA_WIDTH - 1 : 0]  bottom_out,
	output reg  [DATA_WIDTH*2 - 1 : 0] result
);

wire [DATA_WIDTH*2 - 1 : 0] mul;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		result     <= 16'b0;
		right_out  <= 8'b0 ;
		bottom_out <= 8'b0 ;
	end
	else begin
		result     <= result + mul;
		right_out  <= left_in;
		bottom_out <= top_in;
	end
end

assign mul = top_in * left_in;

endmodule