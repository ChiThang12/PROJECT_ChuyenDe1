module Par2_2(
	input [3:0]SW,
	output [3:0]LEDR,
	output [6:0]HEX1,HEX0
);

	wire z;
	wire [3:0]M;
	wire [3:0]Z;
	binary_to_decimal b_t_d(SW[3:0],M[3:0],z);
	
	assign Z[3:0] = (z==1'b1)?4'b0001:4'b0000;
	
	char_7seg H0(M[3:0],HEX0);
	char_7seg H1(Z[3:0],HEX1);
	
	assign LEDR = SW;
endmodule

module binary_to_decimal(
	input [3:0]V,
	output [3:0]M,
	output z
);

assign z = (V>=4'b1010)? 1'b1:1'b0;
assign M[3:0] = (V>=4'b1010) ? (V-4'b1010) : V;
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