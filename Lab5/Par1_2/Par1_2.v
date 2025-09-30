module Par1_2(
    input [17:0] SW,
    output [17:0] LEDR,
    output [6:0] HEX0, HEX1, HEX2, HEX3
);
    wire [3:0] A, B, C, D;
    
    // Gán các tín hiệu 4 bit từ SW vào các tín hiệu A, B, C, D
    assign A = SW[15:12];
    assign B = SW[11:8];
    assign C = SW[7:4];
    assign D = SW[3:0];
    
    // Gọi module char_7seg để hiển thị các giá trị
    char_7seg char_7seg_A(A, HEX3);
    char_7seg char_7seg_B(B, HEX2);
    char_7seg char_7seg_C(C, HEX1);
    char_7seg char_7seg_D(D, HEX0);

    // Gán giá trị cho LEDR (nếu cần thiết)
    assign LEDR = SW;  // Ví dụ, gán LEDR bằng SW

endmodule


module char_7seg(
    input [3:0] C,
    output reg [6:0] Display
);

    always @(*) begin
        case (C)
            4'b0000 : Display = 7'b0111111;  // 0
            4'b0001 : Display = 7'b0000110;  // 1
            4'b0010 : Display = 7'b1011011;  // 2
            4'b0011 : Display = 7'b1001111;  // 3
            4'b0100 : Display = 7'b1100110;  // 4
            4'b0101 : Display = 7'b1101101;  // 5
            4'b0110 : Display = 7'b1111101;  // 6
            4'b0111 : Display = 7'b0000111;  // 7
            4'b1000 : Display = 7'b1111111;  // 8
            4'b1001 : Display = 7'b1101111;  // 9
            default : Display = 7'b0000000;  // Không hợp lệ
        endcase
    end

endmodule
