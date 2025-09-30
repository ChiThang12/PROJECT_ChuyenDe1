`timescale 1ns/1ps
`include "part5.v"
module tb_part5;

    // Input
    reg  [15:0] SW;
    reg  [1:0]  KEY;

    // Output
    wire [6:0] HEX7, HEX6, HEX5, HEX4;
    wire [6:0] HEX3, HEX2, HEX1, HEX0;

    // Instantiate DUT
    part5 uut (
        .SW(SW),
        .KEY(KEY),
        .HEX7(HEX7),
        .HEX6(HEX6),
        .HEX5(HEX5),
        .HEX4(HEX4),
        .HEX3(HEX3),
        .HEX2(HEX2),
        .HEX1(HEX1),
        .HEX0(HEX0)
    );

    // Clock (KEY1 làm clock, active khi =1)
    always #5 KEY[1] = ~KEY[1];

    initial begin
        // Khởi tạo
        SW  = 16'd0;
        KEY = 2'b11;   // KEY0=1 (reset ko active), KEY1=1 (clock idle)

        // Reset
        #10 KEY[0] = 0;  // nhấn reset
        #10 KEY[0] = 1;  // thả reset

        // Đặt giá trị A = 1234 (decimal)
        SW = 16'd1234;
        #10;

        // Tạo xung clock để chốt A
        #10 KEY[1] = 0;
        #10 KEY[1] = 1;

        // Giữ một chút
        #20;

        // Đặt giá trị B = 5678 (decimal)
        SW = 16'd5678;
        #20;

        // Đặt giá trị B > 9999 để test "8888"
        SW = 16'd12345;
        #20;

        $finish;
    end

    initial begin
        $dumpfile("tb_part5.vcd");
        $dumpvars(0,tb_part5);
    end

endmodule
