`timescale 1ns/1ps
`include "d_flip_flop.v"
module tb_d_flip_flop;

    reg D, CLK;
    wire Q, Qn;

    // Khởi tạo DUT (Device Under Test)
    d_flip_flop uut (
        .D(D),
        .CLK(CLK),
        .Q(Q),
        .Qn(Qn)
    );

    // Sinh xung clock (10ns chu kỳ)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; // Toggle mỗi 5ns => clock 10ns period
    end

    initial begin
        $dumpfile("tb_d_flip_flop.vcd");
        $dumpvars(0,tb_d_flip_flop);
    end


    // Tạo stimulus
    initial begin
        // Hiển thị tiêu đề
        $display("Time\tCLK\tD\tQ\tQn");
        $monitor("%g\t%b\t%b\t%b\t%b", $time, CLK, D, Q, Qn);

        // Khởi tạo D
        D = 0;
        #12;   // Sau 12ns

        D = 1; // Thay đổi D
        #10;

        D = 0;
        #10;

        D = 1;
        #10;

        D = 1;
        #10;

        D = 0;
        #10;

        $finish; // Kết thúc mô phỏng
    end

endmodule
