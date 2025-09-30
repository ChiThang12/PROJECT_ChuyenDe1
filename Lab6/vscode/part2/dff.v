module dff (
    input  wire clk,   // clock
    input  wire rst,   // async reset, active low
    input  wire d,     // data input
    output reg  q      // data output
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            q <= 0;       // reset về 0
        end else begin
            q <= d;       // chốt dữ liệu tại cạnh lên của clk
        end
    end

endmodule