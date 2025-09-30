`timescale 1ns/1ps
`include "part4.v"
module part4_tb;
    reg clk;
    reg D;
    wire Q_latch, Q_pos, Q_neg;

    // Instantiate DUT
    part4 uut (
        .D(D),
        .clk(clk),
        .Q_latch(Q_latch),
        .Q_pos(Q_pos),
        .Q_neg(Q_neg)
    );

    // Tạo clock 10ns chu kỳ
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100MHz
    end

    // Sinh stimulus cho D
    initial begin
        D = 0;
        #7  D = 1;   // thay đổi không khớp biên clk
        #8  D = 0;
        #10 D = 1;
        #10 D = 0;
        #12 D = 1;
        #8  D = 0;
        #15 D = 1;
        #20 D = 0;
        #15 D = 1;
        #10 D = 0;
        #20 $finish;
    end

    // Ghi log ra console
    initial begin
        $monitor("t=%0t | clk=%b D=%b | Q_latch=%b Q_pos=%b Q_neg=%b",
                 $time, clk, D, Q_latch, Q_pos, Q_neg);
    end

    // Dump file để xem waveform
    initial begin
        $dumpfile("part4_tb.vcd");
        $dumpvars(0, part4_tb);
    end
endmodule
