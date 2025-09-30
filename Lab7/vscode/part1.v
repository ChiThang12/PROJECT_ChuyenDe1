module part1 (
    input wire clk,
    input wire rst_n,
    input wire en,

    output [6:0] HEX0,HEX1,HEX2,HEX3 // Kết nối ra 4 7-segment display

);

    wire [15:0] Q; // Chân Qn của các TFF, không sử dụng trong module này
    wire [15:0] T_i;
    assign T_i[0]   = 1'b1; // T0 luôn là 1 để TFF0 toggle mỗi xung clock

   // Các bit tiếp theo
    assign T_i[1]  = Q[0] & en;
    assign T_i[2]  = Q[1] & Q[0] & en;
    assign T_i[3]  = Q[2] & Q[1] & Q[0] & en;
    assign T_i[4]  = Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[5]  = Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[6]  = Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[7]  = Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[8]  = Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[9]  = Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[10] = Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[11] = Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[12] = Q[11]& Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[13] = Q[12]& Q[11]& Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[14] = Q[13]& Q[12]& Q[11]& Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;
    assign T_i[15] = Q[14]& Q[13]& Q[12]& Q[11]& Q[10]& Q[9] & Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & en;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : TFF_ARRAY
            TFF tff_inst (
                .clk(clk),
                .T(T_i[i]),
                .rst_n(rst_n),
                .en(en),
                .Q(Q[i])
            );
        end
    endgenerate
	
	wire [3:0] seg_0,seg_1,seg_2,seg_3;
	
    bin2bcd16 bin2bcd_inst (
        .clk(clk),
        .rst_n(rst_n),
        .bin_in(Q),
        .start(en),
        .bcd3(seg_3), // Hàng nghìn
        .bcd2(seg_2), // Hàng trăm
        .bcd1(seg_1), // Hàng chục
        .bcd0(seg_0)  // Hàng đơn vị
    );
	 
	char_7seg seg0 (
        .C(seg_0),
        .Display(HEX0)
    );

    char_7seg seg1 (
        .C(seg_1),
        .Display(HEX1)
    );

    char_7seg seg2 (
        .C(seg_2),
        .Display(HEX2)
    );

    char_7seg seg3 (
        .C(seg_3),
        .Display(HEX3)
    );
    

endmodule

module TFF(
    input wire clk,
    input wire T,
    input wire rst_n,
    input wire en,

    output reg Q,
    output wire Qn
);

    assign Qn = ~Q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= 1'b0;
        else if (en)
            Q <= Q ^ T;  // Toggle nếu T=1, giữ nguyên nếu T=0
    end

endmodule


module bin2bcd16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] bin_in,  // Số nhị phân 16-bit
    input  wire        start,   // Tín hiệu bắt đầu chuyển đổi
    output reg  [3:0]  bcd3,    // Hàng nghìn
    output reg  [3:0]  bcd2,    // Hàng trăm
    output reg  [3:0]  bcd1,    // Hàng chục
    output reg  [3:0]  bcd0,    // Hàng đơn vị
);

    reg [15:0] shift_reg;
    reg [19:0] bcd_reg; // 4*4bit = 16bit BCD, nhưng cần dư để shift
    reg [4:0]  count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 16'd0;
            bcd_reg   <= 20'd0;
            count     <= 5'd0;
            done      <= 1'b0;
            bcd3      <= 4'd0;
            bcd2      <= 4'd0;
            bcd1      <= 4'd0;
            bcd0      <= 4'd0;
        end else if (start) begin
            // Khởi tạo cho thuật toán
            shift_reg <= bin_in;
            bcd_reg   <= 20'd0;
            count     <= 5'd16;
        end else if (count > 0) begin
            // Shift-and-add-3 algorithm
            if (bcd_reg[19:16] >= 5) bcd_reg[19:16] <= bcd_reg[19:16] + 3;
            if (bcd_reg[15:12] >= 5) bcd_reg[15:12] <= bcd_reg[15:12] + 3;
            if (bcd_reg[11:8]  >= 5) bcd_reg[11:8]  <= bcd_reg[11:8]  + 3;
            if (bcd_reg[7:4]   >= 5) bcd_reg[7:4]   <= bcd_reg[7:4]   + 3;

            // Shift left
            bcd_reg <= {bcd_reg[18:0], shift_reg[15]};
            shift_reg <= {shift_reg[14:0], 1'b0};
            count <= count - 1;
        end else if (count == 0 ) begin
            // Gán kết quả
            bcd3 <= bcd_reg[19:16];
            bcd2 <= bcd_reg[15:12];
            bcd1 <= bcd_reg[11:8];
            bcd0 <= bcd_reg[7:4];
        end
    end

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