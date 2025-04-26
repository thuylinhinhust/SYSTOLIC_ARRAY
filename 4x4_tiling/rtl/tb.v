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

	parameter M_SIZE = 12;
	parameter N_SIZE = 12;
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
reg [7:0] matrix_B [(K_SIZE*N_SIZE)*3-1:0];
reg [7:0] matrix_C [M_SIZE*N_SIZE:0];
reg [7:0] golden_matrix [M_SIZE*N_SIZE - 1:0];

reg [15:0] matrix_1 [15:0];
reg [15:0] matrix_2 [15:0];
reg [15:0] matrix_3 [15:0];
reg [15:0] matrix_4 [15:0];
reg [15:0] matrix_5 [15:0];
reg [15:0] matrix_6 [15:0];
reg [15:0] matrix_7 [15:0];
reg [15:0] matrix_8 [15:0];
reg [15:0] matrix_9 [15:0];
reg [4:0] counter;
always @(posedge !(top.reset_register) or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end else
	if(!(top.reset_register)) begin
		counter <= counter + 1;
	end
end

always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 0)) begin
		matrix_1[0]  = top.buffer_row_C1.buffer[0];
		matrix_1[4]  = top.buffer_row_C1.buffer[1];
		matrix_1[8]  = top.buffer_row_C1.buffer[2];
		matrix_1[12]  = top.buffer_row_C1.buffer[3];
		matrix_1[1]  = top.buffer_row_C2.buffer[0];
		matrix_1[5]  = top.buffer_row_C2.buffer[1];
		matrix_1[9]  = top.buffer_row_C2.buffer[2];
		matrix_1[13]  = top.buffer_row_C2.buffer[3];
		matrix_1[2]  = top.buffer_row_C3.buffer[0];
		matrix_1[6]  = top.buffer_row_C3.buffer[1];
		matrix_1[10] = top.buffer_row_C3.buffer[2];
		matrix_1[14] = top.buffer_row_C3.buffer[3];
		matrix_1[3] = top.buffer_row_C4.buffer[0];
		matrix_1[7] = top.buffer_row_C4.buffer[1];
		matrix_1[11] = top.buffer_row_C4.buffer[2];
		matrix_1[15] = top.buffer_row_C4.buffer[3];
	end
end
always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 1)) begin
		matrix_2[0]  = top.buffer_row_C1.buffer[0];
		matrix_2[4]  = top.buffer_row_C1.buffer[1];
		matrix_2[8]  = top.buffer_row_C1.buffer[2];
		matrix_2[12]  = top.buffer_row_C1.buffer[3];
		matrix_2[1]  = top.buffer_row_C2.buffer[0];
		matrix_2[5]  = top.buffer_row_C2.buffer[1];
		matrix_2[9]  = top.buffer_row_C2.buffer[2];
		matrix_2[13]  = top.buffer_row_C2.buffer[3];
		matrix_2[2]  = top.buffer_row_C3.buffer[0];
		matrix_2[6]  = top.buffer_row_C3.buffer[1];
		matrix_2[10] = top.buffer_row_C3.buffer[2];
		matrix_2[14] = top.buffer_row_C3.buffer[3];
		matrix_2[3] = top.buffer_row_C4.buffer[0];
		matrix_2[7] = top.buffer_row_C4.buffer[1];
		matrix_2[11] = top.buffer_row_C4.buffer[2];
		matrix_2[15] = top.buffer_row_C4.buffer[3];
	end
end
always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 2)) begin
		matrix_3[0]  = top.buffer_row_C1.buffer[0];
		matrix_3[4]  = top.buffer_row_C1.buffer[1];
		matrix_3[8]  = top.buffer_row_C1.buffer[2];
		matrix_3[12]  = top.buffer_row_C1.buffer[3];
		matrix_3[1]  = top.buffer_row_C2.buffer[0];
		matrix_3[5]  = top.buffer_row_C2.buffer[1];
		matrix_3[9]  = top.buffer_row_C2.buffer[2];
		matrix_3[13]  = top.buffer_row_C2.buffer[3];
		matrix_3[2]  = top.buffer_row_C3.buffer[0];
		matrix_3[6]  = top.buffer_row_C3.buffer[1];
		matrix_3[10] = top.buffer_row_C3.buffer[2];
		matrix_3[14] = top.buffer_row_C3.buffer[3];
		matrix_3[3] = top.buffer_row_C4.buffer[0];
		matrix_3[7] = top.buffer_row_C4.buffer[1];
		matrix_3[11] = top.buffer_row_C4.buffer[2];
		matrix_3[15] = top.buffer_row_C4.buffer[3];
	end
end
always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 3)) begin
		matrix_4[0]  = top.buffer_row_C1.buffer[0];
		matrix_4[4]  = top.buffer_row_C1.buffer[1];
		matrix_4[8]  = top.buffer_row_C1.buffer[2];
		matrix_4[12]  = top.buffer_row_C1.buffer[3];
		matrix_4[1]  = top.buffer_row_C2.buffer[0];
		matrix_4[5]  = top.buffer_row_C2.buffer[1];
		matrix_4[9]  = top.buffer_row_C2.buffer[2];
		matrix_4[13]  = top.buffer_row_C2.buffer[3];
		matrix_4[2]  = top.buffer_row_C3.buffer[0];
		matrix_4[6]  = top.buffer_row_C3.buffer[1];
		matrix_4[10] = top.buffer_row_C3.buffer[2];
		matrix_4[14] = top.buffer_row_C3.buffer[3];
		matrix_4[3] = top.buffer_row_C4.buffer[0];
		matrix_4[7] = top.buffer_row_C4.buffer[1];
		matrix_4[11] = top.buffer_row_C4.buffer[2];
		matrix_4[15] = top.buffer_row_C4.buffer[3];
	end
end
always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 4)) begin
		matrix_5[0]  = top.buffer_row_C1.buffer[0];
		matrix_5[4]  = top.buffer_row_C1.buffer[1];
		matrix_5[8]  = top.buffer_row_C1.buffer[2];
		matrix_5[12]  = top.buffer_row_C1.buffer[3];
		matrix_5[1]  = top.buffer_row_C2.buffer[0];
		matrix_5[5]  = top.buffer_row_C2.buffer[1];
		matrix_5[9]  = top.buffer_row_C2.buffer[2];
		matrix_5[13]  = top.buffer_row_C2.buffer[3];
		matrix_5[2]  = top.buffer_row_C3.buffer[0];
		matrix_5[6]  = top.buffer_row_C3.buffer[1];
		matrix_5[10] = top.buffer_row_C3.buffer[2];
		matrix_5[14] = top.buffer_row_C3.buffer[3];
		matrix_5[3] = top.buffer_row_C4.buffer[0];
		matrix_5[7] = top.buffer_row_C4.buffer[1];
		matrix_5[11] = top.buffer_row_C4.buffer[2];
		matrix_5[15] = top.buffer_row_C4.buffer[3];
	end
end
always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 5)) begin
		matrix_6[0]  = top.buffer_row_C1.buffer[0];
		matrix_6[4]  = top.buffer_row_C1.buffer[1];
		matrix_6[8]  = top.buffer_row_C1.buffer[2];
		matrix_6[12]  = top.buffer_row_C1.buffer[3];
		matrix_6[1]  = top.buffer_row_C2.buffer[0];
		matrix_6[5]  = top.buffer_row_C2.buffer[1];
		matrix_6[9]  = top.buffer_row_C2.buffer[2];
		matrix_6[13]  = top.buffer_row_C2.buffer[3];
		matrix_6[2]  = top.buffer_row_C3.buffer[0];
		matrix_6[6]  = top.buffer_row_C3.buffer[1];
		matrix_6[10] = top.buffer_row_C3.buffer[2];
		matrix_6[14] = top.buffer_row_C3.buffer[3];
		matrix_6[3] = top.buffer_row_C4.buffer[0];
		matrix_6[7] = top.buffer_row_C4.buffer[1];
		matrix_6[11] = top.buffer_row_C4.buffer[2];
		matrix_6[15] = top.buffer_row_C4.buffer[3];
	end
end
always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 6)) begin
		matrix_7[0]  = top.buffer_row_C1.buffer[0];
		matrix_7[4]  = top.buffer_row_C1.buffer[1];
		matrix_7[8]  = top.buffer_row_C1.buffer[2];
		matrix_7[12]  = top.buffer_row_C1.buffer[3];
		matrix_7[1]  = top.buffer_row_C2.buffer[0];
		matrix_7[5]  = top.buffer_row_C2.buffer[1];
		matrix_7[9]  = top.buffer_row_C2.buffer[2];
		matrix_7[13]  = top.buffer_row_C2.buffer[3];
		matrix_7[2]  = top.buffer_row_C3.buffer[0];
		matrix_7[6]  = top.buffer_row_C3.buffer[1];
		matrix_7[10] = top.buffer_row_C3.buffer[2];
		matrix_7[14] = top.buffer_row_C3.buffer[3];
		matrix_7[3] = top.buffer_row_C4.buffer[0];
		matrix_7[7] = top.buffer_row_C4.buffer[1];
		matrix_7[11] = top.buffer_row_C4.buffer[2];
		matrix_7[15] = top.buffer_row_C4.buffer[3];
	end
end
always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 7)) begin
		matrix_8[0]  = top.buffer_row_C1.buffer[0];
		matrix_8[4]  = top.buffer_row_C1.buffer[1];
		matrix_8[8]  = top.buffer_row_C1.buffer[2];
		matrix_8[12]  = top.buffer_row_C1.buffer[3];
		matrix_8[1]  = top.buffer_row_C2.buffer[0];
		matrix_8[5]  = top.buffer_row_C2.buffer[1];
		matrix_8[9]  = top.buffer_row_C2.buffer[2];
		matrix_8[13]  = top.buffer_row_C2.buffer[3];
		matrix_8[2]  = top.buffer_row_C3.buffer[0];
		matrix_8[6]  = top.buffer_row_C3.buffer[1];
		matrix_8[10] = top.buffer_row_C3.buffer[2];
		matrix_8[14] = top.buffer_row_C3.buffer[3];
		matrix_8[3] = top.buffer_row_C4.buffer[0];
		matrix_8[7] = top.buffer_row_C4.buffer[1];
		matrix_8[11] = top.buffer_row_C4.buffer[2];
		matrix_8[15] = top.buffer_row_C4.buffer[3];
	end
end
always @(posedge !(top.reset_register)) begin
	if(!(top.reset_register) & (counter == 8)) begin
		matrix_9[0]  = top.buffer_row_C1.buffer[0];
		matrix_9[4]  = top.buffer_row_C1.buffer[1];
		matrix_9[8]  = top.buffer_row_C1.buffer[2];
		matrix_9[12]  = top.buffer_row_C1.buffer[3];
		matrix_9[1]  = top.buffer_row_C2.buffer[0];
		matrix_9[5]  = top.buffer_row_C2.buffer[1];
		matrix_9[9]  = top.buffer_row_C2.buffer[2];
		matrix_9[13]  = top.buffer_row_C2.buffer[3];
		matrix_9[2]  = top.buffer_row_C3.buffer[0];
		matrix_9[6]  = top.buffer_row_C3.buffer[1];
		matrix_9[10] = top.buffer_row_C3.buffer[2];
		matrix_9[14] = top.buffer_row_C3.buffer[3];
		matrix_9[3] = top.buffer_row_C4.buffer[0];
		matrix_9[7] = top.buffer_row_C4.buffer[1];
		matrix_9[11] = top.buffer_row_C4.buffer[2];
		matrix_9[15] = top.buffer_row_C4.buffer[3];
	end
end

initial begin
	$readmemb("./script/matrix_C_bin.txt",golden_matrix);
end
initial begin
	$readmemb("./script/matrix_A_bin.txt",matrix_A);
end
initial begin
	$readmemb("./script/matrix_B_bin.txt",matrix_B);
end
integer k = 0;
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
		k = k + 1; 
		$display("PASS TEST");
	end
endtask

always @(posedge done) begin
	if(done) begin
		compare();
	end
end
initial begin
	#100000 $finish;
end
integer i;
reg [9:0] add_A_cnt;
reg [9:0] add_B_cnt;
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
      if ((start_compute) || add_B_cnt == N_SIZE*K_SIZE*3)
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
    matrix_C[k+0] = top.pe00.result;
    matrix_C[k+1] = top.pe01.result;
    matrix_C[k+2] = top.pe02.result;
    matrix_C[k+3] = top.pe03.result;
    matrix_C[k+4] = top.pe10.result;
    matrix_C[k+5] = top.pe11.result;
    matrix_C[k+6] = top.pe12.result;
    matrix_C[k+7] = top.pe13.result;
    matrix_C[k+8] = top.pe20.result;
    matrix_C[k+9] = top.pe21.result;
    matrix_C[k+10] = top.pe22.result;
    matrix_C[k+11] = top.pe23.result;
    matrix_C[k+12] = top.pe30.result;
    matrix_C[k+13] = top.pe31.result;
    matrix_C[k+14] = top.pe32.result;
    matrix_C[k+15] = top.pe33.result;



    file = $fopen("output_matrix_1.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_1[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
    file = $fopen("output_matrix_2.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_2[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
    file = $fopen("output_matrix_3.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_3[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
    file = $fopen("output_matrix_4.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_4[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
    file = $fopen("output_matrix_5.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_5[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
    file = $fopen("output_matrix_6.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_6[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
    file = $fopen("output_matrix_7.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_7[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
    file = $fopen("output_matrix_8.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_8[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
    file = $fopen("output_matrix_9.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_9[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
end
endmodule

