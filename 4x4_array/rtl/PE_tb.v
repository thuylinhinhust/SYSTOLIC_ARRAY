`timescale 1ns / 1ps

module PE_tb;
    parameter DATA_WIDTH = 8;

    reg clk;
    reg rst_n;
    reg [DATA_WIDTH - 1 : 0] top_in;
    reg [DATA_WIDTH - 1 : 0] left_in;
    wire [DATA_WIDTH - 1 : 0] right_out;
    wire [DATA_WIDTH - 1 : 0] bottom_out;
    wire [DATA_WIDTH*2 - 1 : 0] result;

    PE #(.DATA_WIDTH (DATA_WIDTH)) dut (
        .clk (clk),
        .rst_n (rst_n),
        .top_in (top_in),
        .left_in (left_in),
        .right_out (right_out),
        .bottom_out (bottom_out),
        .result (result)
    );

    always #5 clk = ~clk;

    reg [DATA_WIDTH - 1 : 0] test_top_in [3:0];
    reg [DATA_WIDTH - 1 : 0] test_left_in [3:0]; 
    reg [DATA_WIDTH*2 - 1 : 0] golden_result [3:0];

    integer i;

    initial begin
        clk = 0;
        rst_n = 0;
        top_in = 0;
        left_in = 0;

        test_top_in[0] = 8'd2;  test_left_in[0] = 8'd3;   golden_result[0] = 16'd6;
        test_top_in[1] = 8'd4;  test_left_in[1] = 8'd5;   golden_result[1] = 16'd26; // 6+20
        test_top_in[2] = 8'd1;  test_left_in[2] = 8'd10;  golden_result[2] = 16'd36; // 26+10
        test_top_in[3] = 8'd7;  test_left_in[3] = 8'd2;   golden_result[3] = 16'd50; // 36+14

        #20 rst_n = 1;  

        for (i = 0; i < 4; i = i + 1) begin
            top_in = test_top_in[i];
            left_in = test_left_in[i];

            #10;
            
            if (result !== golden_result[i]) 
                $display("Test %d FAILED: top_in=%d, left_in=%d, Expected=%d, Got=%d", 
                    i, top_in, left_in, golden_result[i], result);
            else 
                $display("Test %d PASSED: top_in=%d, left_in=%d, Result=%d", 
                    i, top_in, left_in, result);
        end

        #50 $finish;
    end

endmodule