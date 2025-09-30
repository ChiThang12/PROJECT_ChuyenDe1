module part4(
	input wire [2:0] SW,
	output reg  [0:6] HEX0,
	output wire [2:0] LEDR
);

always @(*) begin
	case(SW)
		3'b000 : HEX0 = 7'b1001000; // H
		3'b001 : HEX0 = 7'b0110000; // E
		3'b010 : HEX0 = 7'b1110001; // L
		3'b011 : HEX0 = 7'b0000001; // 0
		default : HEX0 = 7'b1111111; // tat
	
	endcase
end
assign LEDR = SW;
endmodule