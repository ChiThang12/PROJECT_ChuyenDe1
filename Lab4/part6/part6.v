/*
SW17 	SW16 	SW15 Character pattern
0		0		0 		H E L L O
0		0		1 		H E L L O
0		1		0 		H E L L O
0		1		1 		H E L L O
1		0		0 		E L L O H
1		0		1 		L L O H E
1		1		0 		L O H E L
1		1		1 		O H E L L
*/
/*
module part6 (
    input [17:0] SW,       // Switches SW17-SW0 to control rotation
    output reg [6:0] HEX7,
    output reg [6:0] HEX6,
    output reg [6:0] HEX5,
    output reg [6:0] HEX4,
    output reg [6:0] HEX3,
    output reg [6:0] HEX2,
    output reg [6:0] HEX1,
    output reg [6:0] HEX0,
    output [17:0] LEDR     // LEDR output assignment
);

    // Assign SW to LEDR
    assign LEDR = SW;

    // Display character values for 'HELLO'
    reg [6:0] Display [0:4];  // Array to store character values for HELLO

    always @(*) begin
        // Character values: H, E, L, L, O
        Display[0] = 7'b1001000; // H
        Display[1] = 7'b0110000; // E
        Display[2] = 7'b1110001; // L
        Display[3] = 7'b1110001; // L
        Display[4] = 7'b0000001; // O

        // Default display values for HELLO
         HEX4 = SW[14:12]; // H:000
			HEX3 = SW[11:9];  // E:001
			HEX2 = SW[8:6];   // L:010
			HEX1 = SW[5:3];   // L:010
			HEX0 = SW[2:0];   // O:011
			HEX7 = 7'b1111111; // Blank
			HEX6 = 7'b1111111; // Blank
			HEX5 = 7'b1111111; // Blank

        // Rotate based on SW[17:15]
        case (SW[17:15])
            3'b000: begin
                // No rotation, display HELLO normally
                HEX7 = 7'b1111111;
                HEX6 = 7'b1111111;
                HEX5 = 7'b1111111;
                HEX4 = Display[0];
                HEX3 = Display[1];
                HEX2 = Display[2];
                HEX1 = Display[3];
                HEX0 = Display[4];
            end
            3'b001: begin
                HEX7 = 7'b1111111;
                HEX6 = 7'b1111111;
                HEX5 = Display[0];
                HEX4 = Display[1];
                HEX3 = Display[2];
                HEX2 = Display[3];
                HEX1 = Display[4];
                HEX0 =7'b1111111;
            end
            3'b010: begin
                HEX7 = 7'b1111111;
                HEX6 = Display[0];
                HEX5 = Display[1];
                HEX4 = Display[2];
                HEX3 = Display[3];
                HEX2 = Display[4];
                HEX1 = 7'b1111111;
                HEX0 = 7'b1111111;
            end
            3'b011: begin
                HEX7 = Display[0];
                HEX6 = Display[1];
                HEX5 = Display[2];
                HEX4 = Display[3];
                HEX3 = Display[4];
                HEX2 =7'b1111111;
                HEX1 = 7'b1111111;
                HEX0 = 7'b1111111;
            end
            3'b100: begin
                HEX7 = Display[1];
                HEX6 = Display[2];
                HEX5 = Display[3];
                HEX4 = Display[4];
                HEX3 = 7'b1111111;
                HEX2 = 7'b1111111;
                HEX1 = 7'b1111111;
                HEX0 = Display[0];
            end
            3'b101: begin
                HEX7 = Display[2];
                HEX6 = Display[3];
                HEX5 = Display[4];
                HEX4 = 7'b1111111;
                HEX3 = 7'b1111111;
                HEX2 = 7'b1111111;
                HEX1 = Display[0];
                HEX0 = Display[1];
            end
            3'b110: begin
                HEX7 = Display[3];
                HEX6 = Display[4];
                HEX5 = 7'b1111111;
                HEX4 = 7'b1111111;
                HEX3 = 7'b1111111;
                HEX2 = Display[0];
                HEX1 = Display[1];
                HEX0 = Display[2];
            end
            3'b111: begin
                HEX7 = Display[4];
                HEX6 = 7'b1111111;
                HEX5 = 7'b1111111;
                HEX4 = 7'b1111111;
                HEX3 = Display[0];
                HEX2 = Display[1];
                HEX1 = Display[2];
                HEX0 = Display[3];
            end
            default: begin
                // Blank displays in case of invalid rotation code
                HEX7 = 7'b1111111;
                HEX6 = 7'b1111111;
                HEX5 = 7'b1111111;
                HEX4 = 7'b1111111;
                HEX3 = 7'b1111111;
                HEX2 = 7'b1111111;
                HEX1 = 7'b1111111;
                HEX0 = 7'b1111111;
            end
        endcase
    end
endmodule
*/


module part6 (
    input [17:0] SW,
    output [17:0] LEDR,
    output [0:6] HEX7, HEX6, HEX5, HEX4,
    output [0:6] HEX3, HEX2, HEX1, HEX0
);
    wire [2:0] Ch_Sel;
    wire [2:0] Ch1, Ch2, Ch3, Ch4, Ch5, Blank;
    wire [2:0] H7_Ch, H6_Ch, H5_Ch, H4_Ch;
    wire [2:0] H3_Ch, H2_Ch, H1_Ch, H0_Ch;

    assign LEDR = SW;`
    assign Ch_Sel = SW[17:15]; 
    assign Ch1 = SW[14:12]; // H:000
    assign Ch2 = SW[11:9];  // E:001
    assign Ch3 = SW[8:6];   // L:010
    assign Ch4 = SW[5:3];   // L:010
    assign Ch5 = SW[2:0];   // O:011
    assign Blank = 3'b111;  // blank for 7-segment display

    // HEX7 -> HEX0 là "Blank Blank Blank H E L L O"
    mux_3bit_8to1 M7 (Ch_Sel, Blank, Blank, Blank, Ch1, Ch2, Ch3, Ch4, Ch5, H7_Ch); // 000
    mux_3bit_8to1 M6 (Ch_Sel, Blank, Blank, Ch1, Ch2, Ch3, Ch4, Ch5, Blank, H6_Ch); // 001
    mux_3bit_8to1 M5 (Ch_Sel, Blank, Ch1, Ch2, Ch3, Ch4, Ch5, Blank, Blank, H5_Ch); // 010
    mux_3bit_8to1 M4 (Ch_Sel, Ch1, Ch2, Ch3, Ch4, Ch5, Blank, Blank, Blank, H4_Ch); // 010
    mux_3bit_8to1 M3 (Ch_Sel, Ch2, Ch3, Ch4, Ch5, Blank, Blank, Blank, Ch1, H3_Ch); // 100
    mux_3bit_8to1 M2 (Ch_Sel, Ch3, Ch4, Ch5, Blank, Blank, Blank, Ch1, Ch2, H2_Ch); // 101 
    mux_3bit_8to1 M1 (Ch_Sel, Ch4, Ch5, Blank, Blank, Blank, Ch1, Ch2, Ch3, H1_Ch); // 110 
    mux_3bit_8to1 M0 (Ch_Sel, Ch5, Blank, Blank, Blank, Ch1, Ch2, Ch3, Ch4, H0_Ch); // 111

    // Instantiate char_7seg to drive the HEX displays
    char_7seg H7 (H7_Ch, HEX7);
    char_7seg H6 (H6_Ch, HEX6);
    char_7seg H5 (H5_Ch, HEX5);
    char_7seg H4 (H4_Ch, HEX4);
    char_7seg H3 (H3_Ch, HEX3);
    char_7seg H2 (H2_Ch, HEX2);
    char_7seg H1 (H1_Ch, HEX1);
    char_7seg H0 (H0_Ch, HEX0);

endmodule

module mux_3bit_8to1 (
    input [2:0] S,
    input [2:0] G1, G2, G3, G4, G5, G6, G7, G8,
    output reg [2:0] M
);
    always @(*) begin
        case(S)
            3'b000 : M = G1;
            3'b001 : M = G2;
            3'b010 : M = G3;
            3'b011 : M = G4;
            3'b100 : M = G5;
            3'b101 : M = G6;
            3'b110 : M = G7;
            3'b111 : M = G8;
            default: M = 3'b000;
        endcase
    end
endmodule

module char_7seg (C, Display);
    input [2:0] C;
    output reg [0:6] Display;

    always @(*) begin
        case(C)
            3'b000 : Display = 7'b1001000; // H
            3'b001 : Display = 7'b0110000; // E
            3'b010 : Display = 7'b1110001; // L
            3'b011 : Display = 7'b0000001; // O
            3'b111 : Display = 7'b1111111; // BLANK
            default: Display = 7'b1111111; 
        endcase
    end
endmodule



