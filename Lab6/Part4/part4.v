// =============================
// 1. Transparent D Latch (clk level)
// =============================
module D_latch (
    input D,
    input clk,
    output reg Q
);
    always @(*) begin
        if (clk) Q = D;   // khi clk=1 → truyền thẳng
        // khi clk=0 → giữ Q (ko gán, tức là giữ nguyên)
    end
endmodule


// =============================
// 2. D Flip-Flop posedge
// =============================
module D_ff_pos (
    input D,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        Q <= D;   // chốt tại cạnh lên
    end
endmodule


// =============================
// 3. D Flip-Flop negedge
// =============================
module D_ff_neg (
    input D,
    input clk,
    output reg Q
);
    always @(negedge clk) begin
        Q <= D;   // chốt tại cạnh xuống
    end
endmodule


// =============================
// Top module gom 3 DFF
// =============================
module part4 (
	input [1:0] SW,
	output [1:0] LEDR,
	output [2:0] LEDG
   // FF negedge
);   
	 
	 wire D = SW[1];
	 wire clk = SW[0];
	
    D_latch u1 (
        .D(D),
        .clk(clk),
        .Q(Q_latch)
    );

    D_ff_pos u2 (
        .D(D),
        .clk(clk),
        .Q(Q_pos)
    );

    D_ff_neg u3 (
        .D(D),
        .clk(clk),
        .Q(Q_neg)
    );
	 
	 assign LEDG[0] = Q_latch;
	 assign LEDG[1] = Q_pos;
	 assign LEDG[2] = Q_neg;

endmodule
