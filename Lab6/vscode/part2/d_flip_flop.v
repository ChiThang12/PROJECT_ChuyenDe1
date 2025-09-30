module D_flip_flop(
    input clk,
    input reset_n,   // reset bất đồng bộ, active low
    input D,
    output Q,
    output Qn
);

    wire n1;

    // master latch (hoạt động khi clk = 0)
    D_latch master_latch(
        .clk(~clk),
        .reset_n(reset_n),
        .D(D),
        .Q(n1),
        .Qn()
    );

    // slave latch (hoạt động khi clk = 1)
    D_latch slave_latch(
        .clk(clk),
        .reset_n(reset_n),
        .D(n1),
        .Q(Q),
        .Qn(Qn)
    );

endmodule


module D_latch(
    input clk,
    input reset_n,
    input D,
    output Q,
    output Qn
);
    wire r1, s1, Dn;

    not (Dn, D);
    and (r1, clk, Dn);
    and (s1, clk, D);

    SR_latch sr_latch(
        .S(s1),
        .R(r1),
        .reset_n(reset_n),
        .Q(Q),
        .Qn(Qn)
    );
endmodule


module SR_latch(
    input S,
    input R,
    input reset_n,
    output reg Q,
    output Qn
);
    // SR latch có reset để tránh trạng thái bất định
    always @(*) begin
        if (!reset_n) Q = 0;        // reset về 0
        else if (S & ~R) Q = 1;     // set
        else if (~S & R) Q = 0;     // reset
        // nếu S=R=0 → giữ Q
        // nếu S=R=1 → trạng thái cấm (giữ nguyên Q để tránh 'x')
    end

    assign Qn = ~Q;
endmodule


`timescale 1ns/1ps

module D_flip_flop_tb;

    reg clk;
    reg reset_n;
    reg D;
    wire Q;
    wire Qn;

    // Instantiate the D flip-flop
    D_flip_flop uut (
        .clk(clk),
        .reset_n(reset_n),
        .D(D),
        .Q(Q),
        .Qn(Qn)
    );

    // Generate clock: toggle every 5ns (period = 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Dump waveform
    initial begin
        $dumpfile("D_flip_flop_tb.vcd");
        $dumpvars(0, D_flip_flop_tb);
    end

    // Stimulus
    initial begin
        $display("Time\tclk\tD\tQ\tQn");
        $monitor("%4t\t%b\t%b\t%b\t%b", $time, clk, D, Q, Qn);

        // Khởi tạo
        reset_n = 0; D = 0;
        #12 reset_n = 1; // nhả reset ở thời điểm clk đang chạy

        // Test vector
        D = 0; #10;
        D = 1; #10;
        D = 0; #10;
        D = 1; #10;
        D = 0; #10;

        $finish;
    end

endmodule
