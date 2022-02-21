module part2_tb();

		logic [30:0] x, y;
		logic [30:0] result;

		logic zero, underflow, overflow, nan;

		part2 #(.E(10), .M(20)) DUT (
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
			x = 31'h3500b3f6 ;
			y = 31'h222a06b0;
			#10;
			if (result != '0)begin
				$display("Error! -18*9.5");
				$stop();
			end






			// Need more test cases for base 16, as well as for other bases (maybe 64?)



			$display("The test passed");

			$stop();

		end
endmodule
