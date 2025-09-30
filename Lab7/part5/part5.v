module part5 (
    input CLOCK_50,
    input [17:0] SW,
    output [17:0] LEDR,
    output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);

    // Character codes
    parameter CHAR_H = 3'b000;
    parameter CHAR_E = 3'b001;
    parameter CHAR_L = 3'b010;
    parameter CHAR_O = 3'b011;
    parameter CHAR_BLANK = 3'b111;

    // Counter for 1s interval
    parameter COUNT_1S = 26'd50_000_000;
    wire rst = SW[0];
    reg [25:0] counter;

    always @(posedge CLOCK_50 or negedge rst) begin
        if(!rst)
            counter <= 26'd0;
        else if(counter == COUNT_1S - 1)
            counter <= 26'd0;
        else
            counter <= counter + 1'b1;
    end

    // 8 registers, 1 cho mỗi 7-segment
    reg [2:0] r0, r1, r2, r3, r4, r5, r6, r7;

    // Circular shift logic
    always @(posedge CLOCK_50 or negedge rst) begin
        if(!rst) begin
            r0 <= CHAR_H;
            r1 <= CHAR_E;
            r2 <= CHAR_L;
            r3 <= CHAR_L;
            r4 <= CHAR_O;
            r5 <= CHAR_BLANK;
            r6 <= CHAR_BLANK;
            r7 <= CHAR_BLANK;
        end else if(counter == COUNT_1S - 1) begin
            // Circular shift: đưa ký tự đầu sang cuối
            reg [2:0] tmp;
            tmp = r0;
            r0 <= r1;
            r1 <= r2;
            r2 <= r3;
            r3 <= r4;
            r4 <= r5;
            r5 <= r6;
            r6 <= r7;
            r7 <= tmp;
        end
    end

    // Connect to 7-segment
    char_7seg c0 (.C(r0), .Display(HEX0));
    char_7seg c1 (.C(r1), .Display(HEX1));
    char_7seg c2 (.C(r2), .Display(HEX2));
    char_7seg c3 (.C(r3), .Display(HEX3));
    char_7seg c4 (.C(r4), .Display(HEX4));
    char_7seg c5 (.C(r5), .Display(HEX5));
    char_7seg c6 (.C(r6), .Display(HEX6));
    char_7seg c7 (.C(r7), .Display(HEX7));

    assign LEDR = SW;

endmodule


// 7-segment module
module char_7seg(input [2:0] C, output reg [0:6] Display);
    always @(*) begin
        case(C)
            3'b000: Display = 7'b1001000; // H
            3'b001: Display = 7'b0110000; // E
            3'b010: Display = 7'b1110001; // L
            3'b011: Display = 7'b0000001; // O
            3'b111: Display = 7'b1111111; // BLANK
            default: Display = 7'b1111111;
        endcase
    end
endmodule
