module part1#(
    parameter n = 8,
    parameter k = 10
)(
    input clk,
    input rst,
    output reg [n-1:0] count
);

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            count <= 0;
        end else if(count == k-1) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
        
    end

endmodule

// module top (
//     input  wire [1:0] KEY,      // KEY0 = reset_n, KEY1 = clock
//     output wire [7:0] LEDR      // hiển thị Q trên LED
// );

//     wire clock = KEY[1];
//     wire reset_n = KEY[0];

//     counter_modk #(8, 10) u0 (   // 8-bit, modulo-10
//         .clock(clock),
//         .reset_n(reset_n),
//         .Q(LEDR)
//     );

// endmodule

`timescale 1ns/1ps

module tb_part1;

    // Tham số test
    parameter N = 8;
    parameter K = 10;

    // Tín hiệu kết nối
    reg  clock;
    reg  reset_n;
    wire [N-1:0] Q;

    // Instantiate DUT (Device Under Test)
    part1 #(N, K) uut (
        .clk(clock),
        .rst(reset_n),
        .count(Q)
    );

    // Tạo clock 10ns chu kỳ (100 MHz)
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // toggle mỗi 5ns
    end

    initial begin
        $dumpfile("tb_part1.vcd");
        $dumpvars(0, tb_part1);    
    end

    // Stimulus
    initial begin
        $display("=== Testbench for modulo-%0d counter ===", K);

        // Reset ban đầu
        reset_n = 0;
        #12;                // giữ reset vài chu kỳ
        reset_n = 1;

        // Để counter chạy đủ nhiều để thấy nó quay về 0
        #200;

        // Kích hoạt reset giữa chừng
        reset_n = 0;
        #10;
        reset_n = 1;

        #100;

        $finish;  // kết thúc mô phỏng
    end

    // Monitor giá trị counter
    initial begin
        $monitor("Time=%0t | reset_n=%b | Q=%0d", $time, reset_n, Q);
    end

endmodule
