module small_gate(
    input wire x,
    input wire y,
    input wire s,
    output wire m
);
    assign m = (~s & x) | (s & y);
endmodule 

// u v w x y
// 2:0 5:3 8:6 11:9 14:12 
// M 2:0
// S 17:155
module part3(
    input wire [17:0] SW,    
    output wire [2:0] LEDG,  
    output wire [17:0] LEDR   
);

    wire [2:0] uv_0;        
    wire [2:0] wx_1;        
    wire [2:0] uvwx_0;      
    wire [2:0] M;            

genvar i;
generate 
        for(i = 0; i < 3; i = i + 1) begin: generate_small_gate_1
            small_gate u1 (
                .x(SW[i]), // u
                .y(SW[i + 3]), // v
                .s(SW[15]), // S0
                .m(uv_0[i])
            );
end 
endgenerate

generate 
        for(i = 0; i < 3; i = i + 1) begin: generate_small_gate_2
            small_gate u2 (
                .x(SW[i + 6]), // w
                .y(SW[i + 9]), //x
                .s(SW[15]), // S0
                .m(wx_1[i])
            );
end
endgenerate

generate 
        for(i = 0; i < 3; i = i + 1) begin: generate_small_gate_3
            small_gate u3 (
                .x(uv_0[i]), // uv_0
                .y(wx_1[i]), // wx_1
                .s(SW[16]), // S1
                .m(uvwx_0[i])
            );
end
endgenerate

generate 
        for(i = 0; i < 3; i = i + 1) begin: generate_small_gate_4
            small_gate u4 (
                .x(uvwx_0[i]), //uvwx
                .y(SW[i + 12]), // y
                .s(SW[17]), // S2
                .m(M[i])
            );
end
endgenerate

    
    assign LEDG = M;       
    assign LEDR = SW;      
endmodule
