`timescale 1ns/1ps
`include "part1.v"
module tb_part1;
    reg clk, R, S;
    wire Q;

    // DUT
    part1 uut (
        .clk(clk),
        .R(R),
        .S(S),
        .Q(Q)
    );

    // Clock 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        $dumpfile("tb_part1.vcd");  // dùng cho GTKWave
        $dumpvars(0, tb_part1);

        // Init
        R = 0; S = 0;

        // giữ cả R và S = 0
        #20;

        // Set = 1
        S = 1; R = 0;
        #20;

        // Reset = 1
        S = 0; R = 1;
        #20;

        // R = S = 0 (hold state)
        R = 0; S = 0;
        #20;

        // Trường hợp không xác định R=1, S=1
        R = 1; S = 1;
        #20;

        // Quay về hold
        R = 0; S = 0;
        #20;

        $finish;
    end
endmodule
