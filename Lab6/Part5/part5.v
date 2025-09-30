module part5 (
    input  [1:0] KEY,         // KEY[0] = reset_n (active low), KEY[1] = clock
    input  [15:0] SW,         // switches
    output [6:0] HEX7, HEX6, HEX5, HEX4, // hiển thị A (BCD)
    output [6:0] HEX3, HEX2, HEX1, HEX0, // hiển thị B (BCD)
    output [15:0] LEDR
);

    wire rst_n = KEY[0];
    wire clk   = KEY[1];

    reg [15:0] A_reg;
    wire [15:0] B;
    assign B = SW;

    // Lưu A khi có cạnh lên KEY1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            A_reg <= 16'h0000;
        else 
            A_reg <= SW;
    end

    assign LEDR = SW; // debug

    // Convert A và B sang BCD
    wire [3:0] A_d1, A_d2, A_d3, A_d4, A_d5;
    wire [3:0] B_d1, B_d2, B_d3, B_d4, B_d5;

    bin2bcd convA (.bin(A_reg), .bcd1(A_d1), .bcd2(A_d2), .bcd3(A_d3), .bcd4(A_d4), .bcd5(A_d5));
    bin2bcd convB (.bin(B),     .bcd1(B_d1), .bcd2(B_d2), .bcd3(B_d3), .bcd4(B_d4), .bcd5(B_d5));

    // Nếu >9999 thì hiện 8888
    wire overflow_A = (A_d5 != 4'd0);
    wire overflow_B = (B_d5 != 4'd0);

    // Hiển thị A
    char_7seg hA3 (.C(overflow_A ? 4'd8 : A_d4), .Display(HEX7));
    char_7seg hA2 (.C(overflow_A ? 4'd8 : A_d3), .Display(HEX6));
    char_7seg hA1 (.C(overflow_A ? 4'd8 : A_d2), .Display(HEX5));
    char_7seg hA0 (.C(overflow_A ? 4'd8 : A_d1), .Display(HEX4));

    // Hiển thị B
    char_7seg hB3 (.C(overflow_B ? 4'd8 : B_d4), .Display(HEX3));
    char_7seg hB2 (.C(overflow_B ? 4'd8 : B_d3), .Display(HEX2));
    char_7seg hB1 (.C(overflow_B ? 4'd8 : B_d2), .Display(HEX1));
    char_7seg hB0 (.C(overflow_B ? 4'd8 : B_d1), .Display(HEX0));

endmodule


// Binary (16-bit) -> 5 BCD digits
module bin2bcd (
    input  [15:0] bin,
    output [3:0] bcd5, // chục nghìn
    output [3:0] bcd4, // nghìn
    output [3:0] bcd3, // trăm
    output [3:0] bcd2, // chục
    output [3:0] bcd1  // đơn vị
);
    integer i;
    reg [35:0] shift;

    always @(*) begin
        shift = 0;
        shift[15:0] = bin;
        for (i = 0; i < 16; i = i + 1) begin
            if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 3;
            if (shift[23:20] >= 5) shift[23:20] = shift[23:20] + 3;
            if (shift[27:24] >= 5) shift[27:24] = shift[27:24] + 3;
            if (shift[31:28] >= 5) shift[31:28] = shift[31:28] + 3;
            if (shift[35:32] >= 5) shift[35:32] = shift[35:32] + 3;
            shift = shift << 1;
        end
    end

    assign bcd1 = shift[19:16];
    assign bcd2 = shift[23:20];
    assign bcd3 = shift[27:24];
    assign bcd4 = shift[31:28];
    assign bcd5 = shift[35:32];
endmodule


// Decoder 0-9 -> 7 segment (active low cho DE2)
module char_7seg(
    input  [3:0] C,
    output reg [6:0] Display
);
    always @(*) begin
        case (C)
            4'd0: Display = 7'b1000000;
            4'd1: Display = 7'b1111001;
            4'd2: Display = 7'b0100100;
            4'd3: Display = 7'b0110000;
            4'd4: Display = 7'b0011001;
            4'd5: Display = 7'b0010010;
            4'd6: Display = 7'b0000010;
            4'd7: Display = 7'b1111000;
            4'd8: Display = 7'b0000000;
            4'd9: Display = 7'b0010000;
            default: Display = 7'b1111111; // blank
        endcase
    end
endmodule
