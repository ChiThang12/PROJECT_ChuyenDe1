
module tb_dff;
    reg clk;
    reg rst;
    reg d;
    wire q;

    // Instance DFF
    dff uut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );

    // Clock gen: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Dump waveform
    initial begin
        $dumpfile("dff.vcd");
        $dumpvars(0, tb_dff);
    end

    // Stimulus
    initial begin
        rst = 0; d = 0; #12;   // giữ reset
        rst = 1; #10;          // thả reset

        d = 1; #10;            // q sẽ nhận 1 sau 1 cạnh clk
        d = 0; #10;            // q sẽ nhận 0 sau 1 cạnh clk
        d = 1; #15;            // đổi dữ liệu
        d = 0; #10;

        #20;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | d=%b -> q=%b", $time, d, q);
    end

endmodule
