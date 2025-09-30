/* 
module part2(
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
*/
// D_latch
module part2 (
	
	input [2:0]	SW,
	output [2:0] LEDR,
	output [1:0] LEDG
);

	 
	 wire clk = SW[0];
	 wire reset_n = SW[1];
	 wire D = SW[2];
	 
    wire r1, s1, Dn;
	 
	 assign Dn = ~D;
	 assign r1 = clk & Dn;
	 assign s1 = clk & D;

    SR_latch sr_latch(
        .S(s1),
        .R(r1),
        .reset_n(reset_n),
        .Q(Q),
        .Qn(Qn)
    );
	 assign LEDR = SW;
	 assign LEDG[0]= Q;
	 assign LEDG[1] = Qn;
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
