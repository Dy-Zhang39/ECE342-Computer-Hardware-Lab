module wallace_mult #(width=8) (
    input [7:0] x,
    input [7:0] y,
    output [15:0] out
);

// Wires corresponding to each level of the WTM.
wire [15:0] s_lev[0:3][1:2];
wire [15:0] c_lev[0:3][1:2];

// Rest of your code goes here.
logic [15:0] i [8];
genvar y_idx;
generate
	for (y_idx = 0; y_idx < 8; y_idx++) begin : set_i_loop
		assign i[y_idx] = (x & {8{y[y_idx]}}) << y_idx;
	end
endgenerate


// Level 0
CSA CSA_level0_1 (
	.in_0(i[0]),
	.in_1(i[1]),
	.in_2(i[2]),
	.s(s_lev[0][1]),
	.c(c_lev[0][1]));

CSA CSA_level0_2 (
	.in_0(i[3]),
	.in_1(i[4]),
	.in_2(i[5]),
	.s(s_lev[0][2]),
	.c(c_lev[0][2]));


// Level 1
CSA CSA_level1_1 (
	.in_0(s_lev[0][1]),
	.in_1(c_lev[0][1] << 1),
	.in_2(s_lev[0][2]),
	.s(s_lev[1][1]),
	.c(c_lev[1][1]));

CSA CSA_level1_2 (
	.in_0(c_lev[0][2] << 1),
	.in_1(i[6]),
	.in_2(i[7]),
	.s(s_lev[1][2]),
	.c(c_lev[1][2]));

// level 2
CSA CSA_level_2_1 (
	.in_0(c_lev[1][1] << 1),
	.in_1(s_lev[1][1]),
	.in_2(s_lev[1][2]),
	.s(s_lev[2][1]),
	.c(c_lev[2][1]));

// Level 3
CSA CSA_level_3_1 (
	.in_0(s_lev[2][1]),
	.in_1(c_lev[2][1] << 1),
	.in_2(c_lev[1][2] << 1),
	.s(s_lev[3][1]),
	.c(c_lev[3][1]));

// Output leve;
RCA RCA_out (
	.in_x(s_lev[3][1]),
	.in_y(c_lev[3][1] << 1),
	.carry(1'b0),
	.out(out)
);

endmodule



module CSA (
	input [15:0] in_0,
	input [15:0] in_1,
	input [15:0] in_2,
	output [15:0] s,
	output [15:0] c
);

	genvar i;
	generate
		for (i = 0; i < 16; i++) begin : loop_CSA
			fa full_adder (
				.x(in_0[i]),
				.y(in_1[i]),
				.cin(in_2[i]),
				.s(s[i]),
				.cout(c[i])
			);
		end
	endgenerate
endmodule

module RCA (
	input [15:0] in_x,
	input [15:0] in_y,
	input carry,
	output [15:0] out
);
	logic [16:0] carries;
	assign carries[0] = 0;

	genvar i;
	generate
		for (i = 0; i < 16; i++) begin : loop_CSA
			fa full_adder (
				.x(in_x[i]),
				.y(in_y[i]),
				.cin(carries[i]),
				.s(out[i]),
				.cout(carries[i+1])
			);
		end
	endgenerate
endmodule


// Full adder cell
module fa
(
	input x, y, cin,
	output s, cout
);
	assign s = x ^ y ^ cin;
	assign cout = x&y | x&cin | y&cin;
endmodule
