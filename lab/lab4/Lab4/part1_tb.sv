module part1_tb();

		logic [31:0] x, y;
		logic [31:0] result;

		logic zero, underflow, overflow, nan;

		part1 DUT (
			.X(x),
			.Y(y),
			.result(result),
			.zero(zero),
			.underflow(underflow),
			.overflow(overflow),
			.nan(nan)
		);


		initial begin
			// Testing normal operation
			// -18 * 9.5
			x = 32'b11000001100100000000000000000000;
			y = 32'b01000001000110000000000000000000;
			#10;
			if (result != 32'b11000011001010110000000000000000) begin
				$display("Error! -18*9.5");
				$stop();
			end

			// 50 * 3
			x = 32'b01000010010010000000000000000000;
			y = 32'b01000000010000000000000000000000;
			#10;
			if (result != 32'b01000011000101100000000000000000) begin
				$display("Error! 50*3");
				$stop();
			end

			// 2986 * -3724
			x = 32'b01000101001110101010000000000000;
			y = 32'b11000101011010001100000000000000;
			#10;
			if (result != 32'b11001011001010011010110011111000) begin
				$display("Error! 2986*3724");
				$stop();
			end

			// -9.9583 * -2.5626  Both can't be stored exactly in float 32.
			x = 32'b11000001000111110101010100110010;
			y = 32'b11000000001001000000000110100011;
			#10;
			if (result != 32'b01000001110011000010011100110001) begin  // A number close to 25.51914024
				$display("Error! -9.9583*-2.5626");
				$stop();
			end

			// -0.640625 * (2*(1 + 2^-16 + 2^-17 + 2^-18))
			x = 32'b10111111001001000000000000000000;
			y = 32'b01000000000000000000000011100000;
			#10;
			if (result != 32'b10111111101001000000000100011111) begin  // A number close to -1.28128
				$display("Error! -0.640625 * (2*(1 + 2^-16 + 2^-17 + 2^-18))");
				$stop();
			end

			// Testing zero
			x = 32'b10000000000000000000000000000000;
			y = 32'b11111111111101111111111111111111;
			#10;
			if (result != 32'd0 || zero == 1'b0) begin
				$display("Error! zero0");
				$stop();
			end

			x = 32'b01010101010101010101010101010101;
			y = 32'b00000000000000000000000000000000;
			#10;
			if (result != 32'd0 || zero == 1'b0) begin
				$display("Error! zero1");
				$stop();
			end

			// Test underflow
			x = 32'b00100000110011000010011100110011; //3.25e-19
			y = 32'b00010000110011000010011100010011;	//7.56e-29
			#10;
			if (result != 32'd1 || underflow == 1'b0) begin 				//underflow: E=0, M!=0?
				$display("Error! underflow0");
				$stop();
			end

			x = 32'b00100100000000000000111111110000;  // exponents sum to 127
			y = 32'b00011011100000000000111111110000;
			#10;
			if (result != 32'd1 || underflow == 1'b0) begin
				$display("Error! underflow1");
				$stop();
			end

			x = 32'b10000100110011000010011100110011;
			y = 32'b00001111110001010011111110110111;
			#10;
			if (result != 32'b10000000000000000000000000000001 || underflow == 1'b0) begin
				$display("Error! underflow2");
				$stop();
			end

			// Test overflow
			x = 32'b11101111110111000011000010010000;
			y = 32'b11011111100000000011000011111110;
			#10;
			if (result != 32'b01111111100000000000000000000000 || overflow == 1'b0) begin
				$display("Error! overflow0");
				$stop();
			end

			x = 32'b01101111101000100011000010010110;
			y = 32'b11100110001001100011000011110110;
			#10;
			if (result != 32'b11111111100000000000000000000000 || overflow == 1'b0) begin
				$display("Error! overflow1");
				$stop();
			end

			x = 32'b11000001000000000000111111110000;  // exponents sum up to 382
			y = 32'b11111110000000000000111111110000;
			#10;
			if (result != 32'b01111111100000000000000000000000 || overflow == 1'b0) begin
				$display("Error! overflow1");
				$stop();
			end


			// Testing NaN
			x = 32'b11111111100010000000111111000000;
			y = 32'b10001111000010000000111111000000;
			#10;
			if (result != 32'b01111111100000000000000000000000 || nan == 1'b0) begin
				$display("Error! NaN0");
				$stop();
			end

			// Testing NaN
			x = 32'b00000000000010000000111111000000;
			y = 32'b00001111000010000000111111000000;
			#10;
			if (result != 32'b01111111100000000000000000000000 || nan == 1'b0) begin
				$display("Error! NaN1");
				$stop();
			end




			$display("The test passed");
		end
endmodule
