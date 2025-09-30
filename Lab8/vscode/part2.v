module part2 #(
    parameter WIDTH = 10,
    parameter N = 999,
    parameter COUNT_1S = 26'd50_000_000
)(
    input  CLOCK_50,
    input  [0:0] KEY,
    output [6:0] HEX0, HEX1, HEX2,
    output [6:0] LEDG
);

    wire rst_n = KEY[0];
    wire clk   = CLOCK_50;

    reg [WIDTH-1:0] counter;

    reg [25:0] sec_counter;
    reg max_tick;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec_counter <= 0;
            max_tick <= 0;
        end else if (sec_counter == COUNT_1S - 1) begin
            sec_counter <= 0;
            max_tick <= 1;
        end else begin
            sec_counter <= sec_counter + 1;
            max_tick <= 0;
        end
    end

    // Counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 0;
        else if (max_tick) begin
            if (counter == N)
                counter <= 0;
            else
                counter <= counter + 1;
        end
        
    end


    // BCD
    wire [3:0] d1, d2, d3; // d3 d2 d1
    bin2bcd #(.WIDTH(WIDTH)) conv (.bin(counter), .bcd1(d1), .bcd2(d2), .bcd3(d3), .bcd4(), .bcd5());

    // 7-seg
    char_7seg h0 (.C(d1), .Display(HEX0));
    char_7seg h1 (.C(d2), .Display(HEX1));
    char_7seg h2 (.C(d3), .Display(HEX2));

    assign LEDG[0] = KEY[0]

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
