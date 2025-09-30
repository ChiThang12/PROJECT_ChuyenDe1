module part2(
    input wire clk,
    input wire rst_n,
    input wire en,

    output wire [15:0] Q
);
    reg [15:0] Q_o;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q_o <= 16'b0;
        else if (en)
            Q_o <= Q_o + 1; // Đếm lên
    end

    assign Q = Q_o;


endmodule

`timescale 1ns/1ps

module tb_part2;

    // Inputs
    reg clk;
    reg rst_n;
    reg en;

    // Outputs
    wire [15:0] Q;

    // Instantiate the DUT
    part2 uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .Q(Q)
    );

    // Clock generation: 10ns period => 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;  // Toggle every 5ns
    
    initial begin
        $dumpfile("tb_part2.vcd");
        $dumpvars(0, tb_part2);
    end

    // Test stimulus
    initial begin
        // Initialize
        rst_n = 0;
        en = 0;

        // Apply reset
        #12;
        rst_n = 1;
        en = 1;  // Enable counting

        // Let counter run for a while
        #200;

        // Disable counting
        en = 0;
        #50;

        // Re-enable counting
        en = 1;
        #100;

        // Apply reset again
        rst_n = 0;
        #10;
        rst_n = 1;

        #200; // Observe counting after reset

        $finish;
    end

    // Monitor Q
    initial begin
        $monitor("Time=%0t | rst_n=%b en=%b | Q=%h", $time, rst_n, en, Q);
    end

endmodule
