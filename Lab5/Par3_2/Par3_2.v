module Par3_2(
	input [8:0]SW,
	
	output [8:0]LEDR,
	output [4:0]LEDG
);

	
	wire Cin = SW[8];
	wire c1,c2,c3;
	full_adder f_a0(Cin,SW[7],SW[3],LEDG[0],c1);
	full_adder f_a1(c1,SW[6],SW[2],LEDG[1],c2);
	full_adder f_a2(c2,SW[5],SW[1],LEDG[2],c3);
	full_adder f_a3(c3,SW[4],SW[0],LEDG[3],LEDG[4]);
	
	assign LEDR = SW;
	
	
/*	    wire [4:0] carry;  // Array of carry bits
    wire [4:0] sum;    // Array of sum bits

    // Instantiate the full adders in a generate block
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : FA_GEN
            if (i == 0)
                full_adder f_a(SW[8], SW[7-i], SW[3-i], sum[i], carry[i]);
            else if (i == 3)
                full_adder f_a(carry[i-1], SW[4-i], SW[0-i], sum[i], LEDG[i]);
            else
                full_adder f_a(carry[i-1], SW[7-i], SW[3-i], sum[i], carry[i]);
        end
    endgenerate

    assign LEDG[4] = carry[3];  // Carry output for the last full adder
	*/
	
endmodule
	

module full_adder(
	input Ci,
	input A,
	input B,
	output s,Co
);

	assign s = A ^ B ^ Ci;
	assign Co = ((A^B)&Ci)|(A&B);
endmodule	
	

