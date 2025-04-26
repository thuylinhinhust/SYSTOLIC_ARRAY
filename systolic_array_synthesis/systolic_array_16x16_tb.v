`timescale 1ns / 1ps

module systolic_array_16x16_tb;
    parameter DATA_WIDTH = 8, SIZE = 16;

    reg clk;
    reg rst_n;
    reg [SIZE * DATA_WIDTH - 1 : 0] top_in;
    reg [SIZE * DATA_WIDTH - 1 : 0] left_in;
    reg [7 : 0] sel;
    wire [DATA_WIDTH*2 - 1 : 0] result_out;

    systolic_array_16x16 #(.DATA_WIDTH(DATA_WIDTH), .SIZE(SIZE)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .top_in(top_in),
        .left_in(left_in),
        .sel(sel),
        .result_out(result_out)
    );

    always #5 clk = ~clk;

    reg [DATA_WIDTH*2 - 1 : 0] golden_result [SIZE * SIZE - 1 : 0];

    integer i, j, t;

    initial begin
        clk = 0;
        rst_n = 0;
        top_in = 0;
        left_in = 0;
        sel = 0;

        #20 rst_n = 1;

        for (t = 25; t <= 325; t = t + 10) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                if (t <= 175) begin
                    top_in[i * DATA_WIDTH +: DATA_WIDTH] = (i < ((t - 25) / 10) + 1) ? ((t - 25) / 10) + 1 : 0;
                end else begin
                    top_in[i * DATA_WIDTH +: DATA_WIDTH] = (i < ((t - 185) / 10) + 1) ? 0 : ((t - 175) / 10) + 16;
                end
            end

            for (j = 0; j < SIZE; j = j + 1) begin
                if (t <= 175) begin
                    left_in[j * DATA_WIDTH +: DATA_WIDTH] = (j < ((t - 25) / 10) + 1) ? 31 - ((t - 25) / 10) : 0;
                end else begin
                    left_in[j * DATA_WIDTH +: DATA_WIDTH] = (j < ((t - 185) / 10) + 1) ? 0 : 16 - ((t - 175) / 10);
                end
            end

            #10;
        end

        top_in = 128'b0;
        left_in = 128'b0;

        #200;

        for (i = 0; i < SIZE * SIZE; i = i + 1) begin
            sel = i;
            #10;

            golden_result[i] = compute_golden_result(i);

            if (result_out !== golden_result[i]) begin
                $display("ERROR: PE[%0d] Expected=%d, Got=%d", i, golden_result[i], result_out);
            end else begin
                $display("PASS: PE[%0d] Result=%d", i, result_out);
            end
        end

        #50 $finish;
    end

    function [DATA_WIDTH*2 - 1 : 0] compute_golden_result;
        input integer index;
        integer row, col, t;
        reg [DATA_WIDTH - 1 : 0] mac_top, mac_left;
        reg [DATA_WIDTH*2 - 1 : 0] result_acc;
        
        begin
            row = index / SIZE;  
            col = index % SIZE; 
            result_acc = 0;

            for (t = 25; t <= 325; t = t + 10) begin
                if (t <= 175) begin
                    mac_top  = (col < ((t - 25) / 10) + 1) ? ((t - 25) / 10) + 1 : 0;
                    mac_left = (row < ((t - 25) / 10) + 1) ? 31 - ((t - 25) / 10) : 0;
                end else begin
                    mac_top  = (col < ((t - 185) / 10) + 1) ? 0 : ((t - 175) / 10) + 16;
                    mac_left = (row < ((t - 185) / 10) + 1) ? 0 : 16 - ((t - 175) / 10);
                end

                result_acc = result_acc + (mac_top * mac_left);
            end

            compute_golden_result = result_acc;
        end
    endfunction

    initial begin
		$dumpfile ("systolic_array.VCD");
		$dumpvars (0, systolic_array_16x16_tb); 
    end

endmodule