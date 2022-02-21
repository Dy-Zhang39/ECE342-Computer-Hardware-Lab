module part1 (

	input [31:0] X,
	input [31:0] Y,
	output [31:0] result,
	output zero, underflow, overflow, nan
);

	logic X_SIGN, Y_SIGN;
	logic [23:0] X_MANTISSA, Y_MANTISSA; // includes hidden 1
	logic [7:0] X_EXP, Y_EXP;

	//get the three bit fields
	assign X_SIGN = X[31];
	assign Y_SIGN = Y[31];
	assign X_MANTISSA = {1'b1, X[22:0]};
	assign Y_MANTISSA = {1'b1, Y[22:0]};
	assign X_EXP = X[30:23];
	assign Y_EXP = Y[30:23];

	//adding exponent
	logic [8:0] exponent_addition;
	assign exponent_addition = X_EXP + Y_EXP - 127;


	logic [47:0] mantissa_multiplication;
	assign mantissa_multiplication = X_MANTISSA * Y_MANTISSA;

	//round
	logic [24:0] truncated_mantissa;
	assign truncated_mantissa = mantissa_multiplication >> 23;

	logic [7:0] final_exp;
	logic [22:0] final_mantissa;
	logic o_zero, o_underflow, o_overflow, o_nan;

	always_comb begin
		o_zero = 1'b0;
		o_underflow = 1'b0;
		o_overflow = 1'b0;
		o_nan = 1'b0;

		if ((X[30:0] == 31'b0 && Y_EXP != '1)|| (Y[30:0] == 31'b0 && X_EXP != '1)) begin
			// special case of zero
			final_mantissa = 'b0;
			final_exp = 'b0;
			o_zero = 1'b1;
		end
		else if ((X_EXP == 'b0 && X_MANTISSA != 'b0) ||								//too small x, but not 0
				 (Y_EXP == 'b0 && Y_MANTISSA != 'b0) || 									//too small y, but not 0
				 (X_EXP == 'd255) || (Y_EXP == 'd255)) begin 							//one of them is infinity
					 //more cases?
					 //x=-inf, y=-inf? s=1, frac=0

			// NaN: either input is infinity, or so small that it's invalid
			o_nan = 1'b1;
			final_mantissa = 'b0;
			final_exp = 'd255;
		end
		else if (X_EXP + Y_EXP <= 127) begin
			// underflow
			final_exp = 0;
			final_mantissa = 'b1;
			o_underflow = 1'b1;
		end
		else if (X_EXP + Y_EXP >= 382) begin
			final_exp = 'd255;
			final_mantissa = 'd0;
			o_overflow = 1'b1;
		end
		else if (truncated_mantissa[24] == 1'b1) begin
			final_mantissa = truncated_mantissa >> 1;
			final_exp = exponent_addition + 1'b1;
		end
		else begin
			final_mantissa = truncated_mantissa;
			final_exp = exponent_addition;
		end
	end

	assign result[31] = X_SIGN ^ Y_SIGN;
	assign result[30:23] = final_exp;
	assign result[22:0] = final_mantissa;
	assign zero = o_zero;
	assign underflow = o_underflow;
	assign overflow = o_overflow;
	assign zero = o_zero;
	assign nan = o_nan;

endmodule
