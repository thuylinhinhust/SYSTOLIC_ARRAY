module controller #( parameter ROW_NUM = 4, WIDTH = 4, HEIGHT = 4) (
	input clk                   ,
	input rst_n                 ,
	input data_valid            ,
	output reg [3:0] mux_select ,
	output reg [3:0] in_valid_A , // matrix A 
	output reg [3:0] in_valid_B , // matrix B 
	output reg set_reg_path_1   ,
	output reg set_reg_path_2   ,
	output reg set_reg_path_3   ,
	output reg set_reg_path_4   ,
	output reg set_reg_path_5   ,
	output reg set_reg_path_6   ,
	output reg set_reg_path_7   ,
	output reg read_data        ,
	output reg done
);

parameter IDLE        = 3'b000;
parameter LOAD_DATA	  = 3'b001;
parameter COMPUTE     = 3'b010;
parameter DONE        = 3'b011;

reg start_compute       ;
reg [1:0] current_state ;
reg [1:0] next_state    ;
reg [4:0] counter       ;
reg [4:0] counter_pixel ;
reg [4:0] counter_input ;
reg [4:0] counter_buffer;


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		current_state <= IDLE;
	end else begin 
		current_state <= next_state;
	end
end

always @(*) begin
	case(current_state)
		IDLE:        if (data_valid) next_state = LOAD_DATA        ;
		LOAD_DATA:   if (start_compute) next_state = COMPUTE       ;
		COMPUTE:     if (counter_pixel == 12) next_state = DONE    ;
		default: next_state = IDLE                                 ;
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter        <= 0;
		counter_pixel  <= 0;
		counter_input  <= 0;
		counter_buffer <= 0;
    in_valid_A     <= 0;
    in_valid_B     <= 0;	
		done           <= 0;
	end else begin
		case(next_state)
			IDLE: begin 
		    counter        <= 0;
		    counter_pixel  <= 0;
		    counter_input  <= 0;
		    counter_buffer <= 0;
		    start_compute  <= 0;
			end
			LOAD_DATA: begin
				read_data <= 1'b1;
		    counter_input <= counter_input + 1;
				counter_buffer <= counter_buffer + 1;
				start_compute <= (counter_input == HEIGHT * WIDTH + 2) ? 1 : 0;
				in_valid_A[3] <= ((1 <= counter_input) & (counter_input < 5 )) ? 1 : 0; 
				in_valid_A[2] <= ((5 <= counter_input) & (counter_input < 9 )) ? 1 : 0; 
				in_valid_A[1] <= ((9 <= counter_input) & (counter_input < 13)) ? 1 : 0; 
				in_valid_A[0] <= ((13 <=counter_input) & (counter_input < 17)) ? 1 : 0; 
				in_valid_B[3] <= ((1 <= counter_input) & (counter_input < 5 )) ? 1 : 0; 
				in_valid_B[2] <= ((5 <= counter_input) & (counter_input < 9 )) ? 1 : 0; 
				in_valid_B[1] <= ((9 <= counter_input) & (counter_input < 13)) ? 1 : 0; 
				in_valid_B[0] <= ((13 <=counter_input) & (counter_input < 17)) ? 1 : 0; 
			end
			COMPUTE: begin
				counter <= counter + 1;
				counter_pixel <= counter_pixel + 1;
        in_valid_A[3] <= 1;
				in_valid_A[2] <= (counter >= 1);
				in_valid_A[1] <= (counter >= 2);
				in_valid_A[0] <= (counter >= 3);
        in_valid_B[3] <= 1;
				in_valid_B[2] <= (counter >= 1);
				in_valid_B[1] <= (counter >= 2);
				in_valid_B[0] <= (counter >= 3);
  			read_data <= 1'b0;
        set_reg_path_1 <= (( 1 <= counter ) & ( counter <= 4 )) ? 1 : 0;   
        set_reg_path_2 <= (( 2 <= counter ) & ( counter <= 5 )) ? 1 : 0;    
        set_reg_path_3 <= (( 3 <= counter ) & ( counter <= 6 )) ? 1 : 0;   
        set_reg_path_4 <= (( 4 <= counter ) & ( counter <= 7 )) ? 1 : 0;   
        set_reg_path_5 <= (( 5 <= counter ) & ( counter <= 8 )) ? 1 : 0;   
        set_reg_path_6 <= (( 6 <= counter ) & ( counter <= 9 )) ? 1 : 0;   
        set_reg_path_7 <= (( 7 <= counter ) & ( counter <= 10)) ? 1 : 0;   
			end
		  DONE: begin	
		    counter <= 0;
		    counter_pixel <= 0;
				done <= 1'd1;
			end
		endcase
	end
end
endmodule
