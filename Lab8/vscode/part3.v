module part3(
    input CLOCK_50,
    input [1:0] KEY,
    input [15:0] SW,
    output [6:0] HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output [1:0] LEDG,
    output [15:0] LEDR
);
    wire rst_n = KEY[0];          // Reset
    wire clk   = CLOCK_50;        // Clock 50 MHz
    wire start_stop = KEY[1];     // Start/Stop nút nhấn
    wire [4:0] hour;
    wire [5:0] minute, sec;
    wire led_count;

    reg running;
    reg prev_start_stop;

    // Điều khiển chạy/dừng đồng hồ
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            running <= 1'b0;
            prev_start_stop <= 1'b1;
        end else begin
            if (prev_start_stop == 1'b1 && start_stop == 1'b0) begin
                running <= ~running;
            end
            prev_start_stop <= start_stop;
        end
    end

    // Mạch đồng hồ
    timer t1 (
        .clk(clk),
        .rst_n(rst_n),
        .enable(running),
        .i_data(SW),
        .hour_o(hour),
        .minute_o(minute),
        .sec_o(sec),
        .led_count(led_count)
    );

    // Chuyển binary -> BCD
    wire [3:0] h_ones, h_tens, m_ones, m_tens, s_ones, s_tens;
    bin2bcd conv_h (.bin({11'd0, hour}),   .bcd1(h_ones), .bcd2(h_tens), .bcd3(), .bcd4(), .bcd5());
    bin2bcd conv_m (.bin({10'd0, minute}), .bcd1(m_ones), .bcd2(m_tens), .bcd3(), .bcd4(), .bcd5());
    bin2bcd conv_s (.bin({10'd0, sec}),    .bcd1(s_ones), .bcd2(s_tens), .bcd3(), .bcd4(), .bcd5());

    // Hiển thị 7 segment
    char_7seg seg_s1 (.C(s_ones), .Display(HEX2));
    char_7seg seg_s2 (.C(s_tens), .Display(HEX3));
    char_7seg seg_m1 (.C(m_ones), .Display(HEX4));
    char_7seg seg_m2 (.C(m_tens), .Display(HEX5));
    char_7seg seg_h1 (.C(h_ones), .Display(HEX6));
    char_7seg seg_h2 (.C(h_tens), .Display(HEX7));

    assign LEDG = KEY; // hiển thị trạng thái KEY
    assign LEDR = SW;  // hiển thị trạng thái SW

endmodule

// Module Timer
module timer(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire [15:0] i_data,
    output wire [4:0] hour_o,
    output wire [5:0] minute_o,
    output wire [5:0] sec_o,
    output reg        led_count
);

    reg [5:0] sec, minute;
    reg [4:0] hour;
    reg [31:0] counter_for_sec;
    reg [25:0] blink_counter;

    // Để mô phỏng nhanh, giảm giá trị này xuống
    localparam COUNT_1S     = 100; // 50_000_000 cho thực tế
    localparam COUNT_500MS  = 50;  // 25_000_000 cho thực tế

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec    <= {1'b0, i_data[4:0]};
            minute <= i_data[10:5];
            hour   <= i_data[15:11];
            counter_for_sec <= 32'd0;
            blink_counter   <= 26'd0;
            led_count <= 1'b0;
        end else if (enable) begin
            // Bộ đếm giây
            if (counter_for_sec == COUNT_1S - 1) begin
                counter_for_sec <= 32'd0;
                if (sec == 6'd59) begin
                    sec <= 6'd0;
                    if (minute == 6'd59) begin
                        minute <= 6'd0;
                        if (hour == 5'd23)
                            hour <= 5'd0;
                        else
                            hour <= hour + 5'd1;
                    end else
                        minute <= minute + 6'd1;
                end else
                    sec <= sec + 6'd1;
            end else begin
                counter_for_sec <= counter_for_sec + 32'd1;
            end

            // Blink LED
            if (blink_counter < COUNT_500MS)
                led_count <= 1'b1;
            else
                led_count <= 1'b0;

            if (blink_counter >= (COUNT_500MS * 2 - 1))
                blink_counter <= 26'd0;
            else
                blink_counter <= blink_counter + 26'd1;
        end
    end

    assign hour_o   = hour;
    assign minute_o = minute;
    assign sec_o    = sec;

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

// `timescale 1ns/1ps

// module part3_tb;

//     reg CLOCK_50;
//     reg [1:0] KEY;
//     reg [15:0] SW;
//     wire [6:0] HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
//     wire [1:0] LEDG;
//     wire [15:0] LEDR;

//     // DUT
//     part3 uut (
//         .CLOCK_50(CLOCK_50),
//         .KEY(KEY),
//         .SW(SW),
//         .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .HEX6(HEX6), .HEX7(HEX7),
//         .LEDG(LEDG),
//         .LEDR(LEDR)
//     );

//     // Clock 50 MHz giả lập (ở đây chỉ cần 10ns/chu kỳ)
//     initial CLOCK_50 = 0;
//     always #10 CLOCK_50 = ~CLOCK_50; // 50 MHz giả (chu kỳ 20ns)
    
//     initial begin
//         $dumpfile("part3_tb.vcd");
//         $dumpvars(0, part3_tb);
//     end

//     initial begin
//         // Ban đầu: reset và preset giờ: 12h34
//         SW = 16'b01100_100010_00000; // giờ=12 (01100), phút=34 (100010), sec=0
//         KEY = 2'b01; // reset active, chưa nhấn Start/Stop
//         #100;
//         KEY[0] = 1; // nhả reset

//         // Nhấn nút Start
//         #100;
//         KEY[1] = 0; #40; KEY[1] = 1; // pulse

//         // Chạy khoảng 200 chu kỳ clock (tương ứng vài giây giả lập)
//         #2000;

//         // Nhấn nút Stop
//         KEY[1] = 0; #40; KEY[1] = 1;

//         #1000;

//         // Nhấn nút Start lại
//         KEY[1] = 0; #40; KEY[1] = 1;

//         #2000;

//         $finish;
//     end
// endmodule