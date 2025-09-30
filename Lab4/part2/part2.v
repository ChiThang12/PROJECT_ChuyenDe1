module part2 (
    input [17:0] SW,    
    output [7:0] LEDG,  
    output [17:0] LEDR  
);
    wire [7:0] X = SW[7:0];     
    wire [7:0] Y = SW[15:8];    
    wire s = SW[16];              
    wire [7:0] S = {8{s}};   
	 wire [7:0] M;
    assign M = (~S & X) | (S & Y); 
    assign LEDG = M;
    assign LEDR = SW;
endmodule