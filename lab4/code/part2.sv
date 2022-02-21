module part2 #(
	parameter E = 8,
	parameter M = 23,
	parameter BITS = E + M + 1,
	parameter EB = (2**(E-1)) - 1
)(
	input [BITS-1:0] X,
	input [BITS-1:0] Y,
	output [BITS-1:0] result,
	output zero, underflow, overflow, nan
);

	logic X_SIGN, Y_SIGN;
	logic [M:0] X_MANTISSA, Y_MANTISSA; // includes hidden 1
	logic [E-1:0] X_EXP, Y_EXP;

	assign X_SIGN = X[BITS-1];
	assign Y_SIGN = Y[BITS-1];
	assign X_MANTISSA = {1'b1, X[M-1:0]};
	assign Y_MANTISSA = {1'b1, Y[M-1:0]};
	assign X_EXP = X[M+E-1:M];
	assign Y_EXP = Y[M+E-1:M];


	logic [E:0] exponent_addition;
	assign exponent_addition = X_EXP + Y_EXP - EB;

	logic [2*M + 1:0] mantissa_multiplication;
	assign mantissa_multiplication = X_MANTISSA * Y_MANTISSA;

	logic [M+1:0] truncated_mantissa;
	assign truncated_mantissa = mantissa_multiplication >> M;

	logic [E-1:0] final_exp;
	logic [M-1:0] final_mantissa;
	logic o_zero, o_underflow, o_overflow, o_nan;

	always_comb begin
		o_zero = 1'b0;
		o_underflow = 1'b0;
		o_overflow = 1'b0;
		o_nan = 1'b0;

		if ((X[BITS-2:0] == 31'b0 && Y_EXP != '1)|| (Y[BITS-2:0] == 31'b0 && X_EXP != '1)) begin
			// special case of zero
			final_mantissa = 'b0;
			final_exp = 'b0;
			o_zero = 1'b1;
		end
		else if ((X_EXP == 'b0 && X_MANTISSA != 'b0) ||
				 (Y_EXP == 'b0 && Y_MANTISSA != 'b0) ||
				 (X_EXP == '1) || (Y_EXP == '1)) begin
			// NaN: either input is infinity, or so small that it's invalid
			o_nan = 1'b1;
			final_mantissa = 'b0;
			final_exp = '1;
		end
		else if (X_EXP + Y_EXP <= EB) begin
			// underflow
			final_exp = '0;
			final_mantissa = 'b1;  // it just has to be nonzero
			o_underflow = 1'b1;
		end
		else if (X_EXP + Y_EXP >= (3*EB + 1)) begin
			// overflow
			final_exp = '1;
			final_mantissa = '0;
			o_overflow = 1'b1;
		end
		else if (truncated_mantissa[M+1] == 1'b1) begin
			final_mantissa = truncated_mantissa >> 1;
			final_exp = exponent_addition + 1'b1;
		end
		else begin
			final_mantissa = truncated_mantissa;
			final_exp = exponent_addition;
		end
	end

	assign result[BITS-1] = X_SIGN ^ Y_SIGN;
	assign result[M+E-1:M] = final_exp;
	assign result[M-1:0] = final_mantissa;
	assign zero = o_zero;
	assign underflow = o_underflow;
	assign overflow = o_overflow;
	assign zero = o_zero;
	assign nan = o_nan;


endmodule
