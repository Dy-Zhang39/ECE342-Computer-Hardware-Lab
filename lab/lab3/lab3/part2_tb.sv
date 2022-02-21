module part2_tb();

		logic [7:0] x, y;
		logic [15:0] out;

		wallace_mult DUT (
			.x(x),
			.y(y),
			.out(out)
		);




		initial begin
			for (integer i = 0; i < 255; i++) begin : loop1
				for (integer j = 0; j < 255; j++) begin : loop2
					x = i;
					y = j;
					#10;

					if (out !== x * y) begin
						$display("Error: expect %d * %d = %d, got %d instead", x, y, x*y, out);
						$stop();
					end
				end
			end

			$display("The test passed");
		end
endmodule
