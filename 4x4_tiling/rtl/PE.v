module PE #( parameter DATA_WIDTH = 8) (
	input                                  clk        ,
	input                                  rst_n      ,
	input                                  set_reg    ,
	input                                  sel_mux    ,
	input       [DATA_WIDTH - 1   : 0 ]    top_in     ,
	input       [DATA_WIDTH - 1   : 0 ]    left_in    ,
	input       [DATA_WIDTH*2 - 1 : 0 ]    psum_in    ,
	output reg  [DATA_WIDTH - 1   : 0 ]    right_out  ,
	output reg  [DATA_WIDTH - 1   : 0 ]    bottom_out ,
	output wire [DATA_WIDTH*2 - 1 : 0 ]    psum_out
);

reg  [DATA_WIDTH*2 - 1 : 0] result;
wire [DATA_WIDTH*2 - 1 : 0] sum   ;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		result     <= 16'b0;
		right_out  <= 8'b0 ;
		bottom_out <= 8'b0 ;
	end
	else begin
		result     <= (set_reg) ? (sel_mux) ? psum_in : (result + sum) : result;
		right_out  <= left_in;
		bottom_out <= top_in ;
	end
end
assign psum_out = result;
assign sum = top_in * left_in;
endmodule
	
	


