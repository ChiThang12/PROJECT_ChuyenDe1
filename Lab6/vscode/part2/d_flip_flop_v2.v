module D_flip_flop(
    input clk,
    input D,
    output Q,
    output Qn
);

    wire n1;

    // master latch (hoạt động khi clk = 0)
    D_latch master_latch(
        .clk(~clk),
        .D(D),
        .Q(n1),
        .Qn()
    );

    // slave latch (hoạt động khi clk = 1)
    D_latch slave_latch(
        .clk(clk),
        .D(n1),
        .Q(Q),
        .Qn(Qn)
    );

endmodule


module D_latch(
    input clk,
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
        .Q(Q),
        .Qn(Qn)
    );
endmodule


module SR_latch(
    input S,
    input R,
    output Q,
    output Qn
);
    wire n1, n2;

    nand(n1, R, n2);  // Q = n1
    nand(n2, S, n1);  // Qn = n2

    assign Q = n1;
    assign Qn = n2;
endmodule


`timescale 1ns/1ps

module D_flip_flop_tb;

    reg clk;
    reg D;
    wire Q;
    wire Qn;

    // Instantiate the D flip-flop
    D_flip_flop uut (
        .clk(clk),
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

        D = 0; #12;  // đang trong pha clk = 1 → dữ liệu này sẽ không được lấy ngay
    D = 1; #10;
    D = 0; #10;
    D = 1; #10;

        $finish;
    end

endmodule
