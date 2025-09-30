module part1 (
    input  [2:0] SW,
    output [2:0] LEDR,
    output reg   LEDG
);
    wire clk = SW[2];
    wire R   = SW[1];
    wire S   = SW[0];

    assign LEDR = SW;

    always @(*) begin
        if (clk) begin
            case ({R,S})
                2'b01: LEDG = 1;   // set
                2'b10: LEDG = 0;   // reset
                2'b00: LEDG = LEDG; // hold
                2'b11: LEDG = 1'bx; // invalid
            endcase
        end
    end
endmodule
