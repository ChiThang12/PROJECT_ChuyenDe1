module par4_2(
    input [8:0] SW,               
    output [6:0] HEX7,           
    output [6:0] HEX6,            
    output [8:0] LEDR,           
    output LEDG                   
);

    wire [3:0] A = SW[7:4];       
    wire [3:0] B = SW[3:0];      
    wire Cin = SW[8];            
    wire [3:0] sum;              
    wire [4:0] temp;              
    wire [3:0] h6;                
    wire [3:0] h7;               

    assign LEDR = SW;             
    assign LEDG = (A >= 4'b1010 && B >= 4'b1010) ? 1'b1 : 1'b0;

    assign temp = A + B + Cin;    
    assign sum = (temp >= 4'b1010) ? (temp + 4'b0110) : temp; 
    assign h6 = sum % 10;        
    assign h7 = sum / 10;         

   
    char_7seg display_h7 (.C(h7), .Display(HEX7));  
    char_7seg display_h6 (.C(h6), .Display(HEX6)); 

endmodule


// Tạo module hiển thị LED 7 đoạn
module char_7seg(
    input [3:0] C,
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
            default : Display = 7'b1111111;  // Không hợp lệ
        endcase
    end

endmodule
