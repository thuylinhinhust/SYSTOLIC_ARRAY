module tb;
	reg clk               ;
	reg rst_n                 ;
	reg data_valid            ;
	reg start_compute         ;
	wire [7:0] data_in_A;
	wire [7:0] data_in_B;
	wire done;
	wire read_data;
  reg [3:0] in_valid_A;
  reg [3:0] in_valid_B;

	parameter M_SIZE = 4;
	parameter N_SIZE = 4;
	parameter K_SIZE = 16;

TOP #(.DATA_WIDTH (8), .WIDTH(4), .HEIGHT(4), .BUFFER_SIZE(4), .M_SIZE(M_SIZE), .N_SIZE(N_SIZE), .K_SIZE(K_SIZE)) top (
	.clk           (clk          ),
	.rst_n         (rst_n        ),
	.data_valid    (data_valid   ),
	.start_compute (start_compute),
  .data_in_A     (data_in_A    ),
  .data_in_B     (data_in_B    ),
	.done          (done         ),
	.read_data     (read_data    )        
);

initial begin
	$dumpfile("syntolic.VCD");
	$dumpvars(0, tb);
end
always #5 clk = ~clk;
initial begin
	clk = 0;
  rst_n = 0;
	#10 rst_n = 1;
	#40 data_valid = 1;
	#10 data_valid = 0;
end
reg [7:0] matrix_A [M_SIZE*K_SIZE-1:0];
reg [7:0] matrix_B [K_SIZE*N_SIZE-1:0];
reg [7:0] matrix_C [M_SIZE*N_SIZE:0];
reg [7:0] golden_matrix [M_SIZE*K_SIZE:0];
initial begin
	$readmemb("./script/matrix_C_bin.txt",golden_matrix);
end
initial begin
	$readmemb("./script/matrix_A_bin.txt",matrix_A);
end
initial begin
	$readmemb("./script/matrix_B_bin.txt",matrix_B);
end

// COMPARE 2 MATRIX
task compare;
	integer  i;
	begin
		for(i = 0; i < 16 ; i = i + 1) begin
			$display (" matrix C : %d", matrix_C[i]);
			$display (" matrix golden : %d", golden_matrix[i]);
			if(matrix_C[i] != golden_matrix[i]) begin
				$display("NO PASS in %d", i);
				disable compare;
			end
		end
		$display("PASS TEST");
	end
endtask

always @(posedge done) begin
	if(done) begin
		compare();
	end
end
initial begin
	#10000 $finish;
end
integer i;
reg [6:0] add_A_cnt;
reg [6:0] add_B_cnt;
reg read_reg;
reg read_reg_1;
always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      add_B_cnt  <= 0;
      read_reg_1  <= 0;
    end
    else
    begin
     read_reg_1 <= read_data;
      if ((start_compute) || add_B_cnt == N_SIZE*K_SIZE)
        add_B_cnt   <= 0;
      else if (read_data)
        add_B_cnt   <= add_B_cnt + 1;
      else
        add_B_cnt   <= add_B_cnt;
    end
  end
always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      add_A_cnt  <= 0;
      read_reg  <= 0;
    end
    else
    begin
     read_reg <= read_data;
      if ((start_compute) || add_A_cnt == M_SIZE*K_SIZE)
        add_A_cnt   <= 0;
      else if (read_data)
        add_A_cnt   <= add_A_cnt + 1;
      else
        add_A_cnt   <= add_A_cnt;
    end
  end
assign data_in_A = (read_reg   == 1)? matrix_A[add_A_cnt - 1] : 0; 
assign data_in_B = (read_reg_1 == 1)? matrix_B[add_B_cnt - 1] : 0; 

integer j;
integer file; 
initial begin
    wait(done); 
    matrix_C[0] = top.pe00.result;
    matrix_C[1] = top.pe01.result;
    matrix_C[2] = top.pe02.result;
    matrix_C[3] = top.pe03.result;
    matrix_C[4] = top.pe10.result;
    matrix_C[5] = top.pe11.result;
    matrix_C[6] = top.pe12.result;
    matrix_C[7] = top.pe13.result;
    matrix_C[8] = top.pe20.result;
    matrix_C[9] = top.pe21.result;
    matrix_C[10] = top.pe22.result;
    matrix_C[11] = top.pe23.result;
    matrix_C[12] = top.pe30.result;
    matrix_C[13] = top.pe31.result;
    matrix_C[14] = top.pe32.result;
    matrix_C[15] = top.pe33.result;

    // Ghi giá trị ra tệp
    file = $fopen("output_matrix.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_C[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
end
endmodule

