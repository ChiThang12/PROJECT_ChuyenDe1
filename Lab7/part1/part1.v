// ===========================
// T Flip-Flop
// ===========================
module t_ff(
    input  wire clk,
    input  wire rst_n,
    input  wire T,
    input  wire en,
    output reg  Q
);
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            Q <= 1'b0;
        else if(en)
            Q <= Q ^ T;
    end
endmodule


// ==============================
// 16-bit Ripple Counter + BCD + 7-Segment Display
// ==============================
module part1 (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en,

    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3
);

    // --------------------------
    // 16-bit TFF Counter
    // --------------------------
    wire [15:0] Q;
    wire [15:0] T_i;

    assign T_i[0] = 1'b1;
    assign T_i[1] = Q[0] & en;
    assign T_i[2] = Q[1] & Q[0] & en;
    assign T_i[3] = Q[2] & Q[1] & Q[0] & en;
    assign T_i[4] = Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[5] = Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[6] = Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[7] = Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[8] = Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[9] = Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[10]= Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[11]= Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[12]= Q[11]& Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[13]= Q[12]& Q[11]& Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[14]= Q[13]& Q[12]& Q[11]& Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[15]= Q[14]& Q[13]& Q[12]& Q[11]& Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;

    genvar i;
    generate
        for (i=0;i<16;i=i+1) begin : TFF_ARRAY
            t_ff tff_inst (
                .clk(clk),
                .rst_n(rst_n),
                .T(T_i[i]),
                .en(en),
                .Q(Q[i])
            );
        end
    endgenerate

    // --------------------------
    // Binary -> BCD Converter
    // --------------------------
    wire [3:0] seg0, seg1, seg2, seg3;

    bin2bcd16 bin2bcd_inst (
        .bin_in(Q),
        .bcd3(seg3),
        .bcd2(seg2),
        .bcd1(seg1),
        .bcd0(seg0)
    );

    // --------------------------
    // 7-Segment Display
    // --------------------------
    char_7seg disp0(.C(seg0), .Display(HEX0));
    char_7seg disp1(.C(seg1), .Display(HEX1));
    char_7seg disp2(.C(seg2), .Display(HEX2));
    char_7seg disp3(.C(seg3), .Display(HEX3));

endmodule


// ===========================
// Binary -> BCD 16-bit (Combinational)
// ===========================
module bin2bcd16(
    input  wire [15:0] bin_in,
    output wire [3:0] bcd3,
    output wire [3:0] bcd2,
    output wire [3:0] bcd1,
    output wire [3:0] bcd0
);
    integer i;
    reg [19:0] bcd;

    always @(*) begin
        bcd = 20'd0;
        for(i=15;i>=0;i=i-1) begin
            // add 3 nếu ≥5
            if(bcd[19:16] >= 5) bcd[19:16] = bcd[19:16]+3;
            if(bcd[15:12] >= 5) bcd[15:12] = bcd[15:12]+3;
            if(bcd[11:8]  >= 5) bcd[11:8]  = bcd[11:8]+3;
            if(bcd[7:4]   >= 5) bcd[7:4]   = bcd[7:4]+3;
            // shift left + bit mới
            bcd = {bcd[18:0], bin_in[i]};
        end
    end

    assign bcd3 = bcd[19:16];
    assign bcd2 = bcd[15:12];
    assign bcd1 = bcd[11:8];
    assign bcd0 = bcd[7:4];
endmodule

// ===========================
// 7-Segment Display Module
// ===========================
module char_7seg(
    input  wire [3:0] C,
    output reg  [6:0] Display
);
    always @(*) begin
        case(C)
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
            default: Display = 7'b1111111;
        endcase
    end
endmodule
