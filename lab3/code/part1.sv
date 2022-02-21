module mult_csm
(
	input [7:0] x,
	input [7:0] y,
	output [15:0] out
);
	logic [15:0] pp[9];
	assign pp[0] = '0;
	
	logic [16:0] cin[9];
	assign cin[0] = '0;

	// let m = x, q = y
	
	
	// Write your nested generate for loops here.
	// set pp[1] to x & y0
	assign pp[1] = {{8{1'b0}}, x & {8{y[0]}}};
	
	// set cin[1] to x & y1
	assign cin[1] = {{7{1'b0}}, x & {8{y[1]}}, 1'b0};
	
	// set the last pp of each row r to x[7] & y[r]
	genvar row;
	generate 
		for (row = 2; row < 8; row++) begin : loop1 
			assign pp[row][7+row] = x[7] & y[row];
		end
	endgenerate
	

	// Have a RCA to add the numbers in columns 8 through 15 of 
	// the final row of the multiplier to get out[16:8].
	genvar col;
	generate
		for (row = 1; row < 7; row++) begin : loop2
			for (col = row; col < row + 8; col++) begin : loop3
				fa my_full_adder (
					.x(col == row ? 1'b0 : x[col - row - 1] & y[row+1]),
					.y(pp[row][col]),
					.cin(cin[row][col]),
					.cout(cin[row+1][col+1]),
					.s(pp[row+1][col])
				);
			end
		end
	endgenerate
	
	// Now, pp[7][7:14] contains the partial products that need to be summed
	// with cin[7][7:14] to produce the final pp row
	logic [8:0] pp_carries;
	assign pp_carries[0] = 1'b0;
	generate
		for (col = 7; col < 15; col++) begin : loop4
			fa my_full_adder (
				.x(pp[7][col]),
				.y(cin[7][col]),
				.cin(pp_carries[col-7]),
				.cout(pp_carries[col-6]),
				.s(pp[8][col])
			);
		end
	
	endgenerate
	
	// Set the values of pp[8][6:0] 
	generate
		for (col = 0; col < 7; col++) begin : loop5
			for (row = 8; row != col + 1; row--) begin : loop6
				assign pp[row][col] = pp[row-1][col];
			end
		end
	endgenerate
	
	
   	// Set the lower 8-bits of the final multiplier output. 
	assign out = {pp_carries[8], pp[8][14:0]};
		  
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
