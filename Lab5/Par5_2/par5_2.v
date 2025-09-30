// Top module
module par5_2(
    input  [15:0] SW,
    output [6:0]  HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,
    output [15:0] LEDR
);
    wire [7:0] A = SW[15:8];
    wire [7:0] B = SW[7:0];
    wire [7:0] sum;
    wire C_out;
    wire [3:0] dis_hex2;

    // Bộ cộng BCD 2 chữ số
    bcd_2digit_adder adder(
        .A(A),
        .B(B),
        .sum(sum),
        .C_out(C_out)
    );

    assign dis_hex2 = (C_out==1'b1) ? 4'b0001 : 4'b0000;

    // Hiển thị kết quả
    char_7seg display_0 (.C(sum[3:0]), .Display(HEX0)); // S0
    char_7seg display_1 (.C(sum[7:4]), .Display(HEX1)); // S1
    char_7seg display_2 (.C(dis_hex2), .Display(HEX2)); // Carry

    // Hiển thị input
    char_7seg display_A0 (.C(B[3:0]), .Display(HEX4));  // B0
    char_7seg display_A1 (.C(B[7:4]), .Display(HEX5));  // B1
    char_7seg display_B0 (.C(A[3:0]), .Display(HEX6));  // A0
    char_7seg display_B1 (.C(A[7:4]), .Display(HEX7));  // A1

endmodule


// BCD adder 1 digit
module bcd_adder(
    input  [3:0] A,
    input  [3:0] B,
    input        C_in,
    output [3:0] sum,
    output       C_out
);
    wire [4:0] temp;   // 4bit + carry
    wire [4:0] corr;

    assign temp = A + B + C_in;
    assign corr = (temp > 9) ? (temp + 6) : temp;

    assign sum   = corr[3:0];
    assign C_out = corr[4];
endmodule


// BCD adder 2 digits
module bcd_2digit_adder(
    input  [7:0] A,
    input  [7:0] B,
    output [7:0] sum,
    output       C_out
);
    wire [3:0] sum0, sum1;
    wire c0, c1;

    // cộng hàng đơn vị
    bcd_adder adder0(
        .A(A[3:0]),
        .B(B[3:0]),
        .C_in(0),
        .sum(sum0),
        .C_out(c0)
    );

    // cộng hàng chục (có carry từ đơn vị)
    bcd_adder adder1(
        .A(A[7:4]),
        .B(B[7:4]),
        .C_in(c0),
        .sum(sum1),
        .C_out(c1)
    );

    assign sum   = {sum1, sum0};
    assign C_out = c1;
endmodule


// Hiển thị LED 7 đoạn
module char_7seg(
    input  [3:0] C,
    output reg [6:0] Display
);
    always @(*) begin
        case (C)
            4'b0000 : Display = 7'b1000000;  // 0
            4'b0001 : Display = 7'b1111001;  // 1
            4'b0010 : Display = 7'b0100100;  // 2
            4'b0011 : Display = 7'b0110000;  // 3
            4'b0100 : Display = 7'b0011001;  // 4
            4'b0101 : Display = 7'b0010010;  // 5
            4'b0110 : Display = 7'b0000010;  // 6
            4'b0111 : Display = 7'b1111000;  // 7
            4'b1000 : Display = 7'b0000000;  // 8
            4'b1001 : Display = 7'b0010000;  // 9
            default : Display = 7'b1111111;  // blank
        endcase
    end
endmodule
