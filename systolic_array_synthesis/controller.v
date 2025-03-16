module controller #(parameter BUFFER_SIZE = 9, WIDTH = 16, HEIGHT = 16, M_SIZE = 16, N_SIZE = 16, K_SIZE = 27) (
	input clk                   ,
	input rst_n                 ,
	input data_valid            ,
	output reg [15:0] in_valid_A , // matrix A 
	output reg [15:0] in_valid_B , // matrix B 
	output reg read_data        ,
	output reg done
);
	localparam TILING = (K_SIZE + BUFFER_SIZE - 1) / BUFFER_SIZE;

	parameter IDLE        = 3'b000 ;
	parameter LOAD_DATA	  = 3'b001 ;
	parameter COMPUTE     = 3'b010 ;
	parameter DONE_TILING = 3'b011 ;

	reg start_compute       ;
	reg [1:0] current_state ;
	reg [1:0] next_state    ;
	reg [5:0] counter       ;
	reg [8:0] counter_input ;
	reg [2:0] counter_tiling;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			current_state <= IDLE;
		end else begin 
			current_state <= next_state;
		end
	end

	always @(*) begin
		case (current_state)
			IDLE:        if (data_valid)                 next_state = LOAD_DATA  ;
			LOAD_DATA:   if (start_compute)              next_state = COMPUTE    ;
			COMPUTE:     if (counter == (WIDTH * 3 - 1)) next_state = DONE_TILING;
			DONE_TILING: next_state = (counter_tiling < TILING) ? LOAD_DATA : DONE_TILING;
			default:     next_state = IDLE;
		endcase
	end

    integer i;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			counter               <= 0;
			counter_input         <= 0;
			counter_tiling        <= 0;
			start_compute         <= 0;
			in_valid_A            <= 0;
			in_valid_B            <= 0;
			read_data             <= 0;	
			done                  <= 0;
		end else begin
			case (next_state)
				IDLE: begin 
					counter        <= 0;
					counter_input  <= 0;
					start_compute  <= 0;
				end
				LOAD_DATA: begin
					in_valid_A     <= {16{1'b1}};
					in_valid_B     <= {16{1'b1}};
					done           <= 0;
					counter_input  <= counter_input + 1;
					counter_tiling <= (counter_input == BUFFER_SIZE - 1) ? counter_tiling + 1 : counter_tiling;
					read_data      <= (counter_input < BUFFER_SIZE)  ? 1 : 0;
					start_compute  <= (counter_input == BUFFER_SIZE) ? 1 : 0;
				end
				COMPUTE: begin
					counter_input <= 0;
					counter       <= counter + 1;
					read_data     <= 0; 
                    for (i = 0; i < 16; i = i + 1) begin
                        in_valid_A[i] <= (counter >= i);
                        in_valid_B[i] <= (counter >= i);
                    end
				end
				DONE_TILING: begin	
					counter <= 0;
					done    <= (counter_tiling == TILING) ? 1 : 0;
				end
			endcase
		end
	end
endmodule