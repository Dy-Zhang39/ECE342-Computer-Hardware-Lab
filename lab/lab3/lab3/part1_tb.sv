module part1_tb();

		logic [7:0] x, y;
		logic [15:0] out;
		
		mult_csm DUT (
			.x(x),
			.y(y),
			.out(out)
		);
		
		
		initial begin
			for (integer i = 0; i <= 8'b11111111; i++) begin : loop1
				for (integer j = 0; j <= 8'b11111111; j++) begin : loop2
					x = i;
					y = j;
					#10;
					
					if (out != x * y) begin
						$display("Error: expect %d * %d = %d, got %d instead", x, y, x*y, out);
						$stop();
					end
				end
			end
			
			$display("The test passed");
		end
endmodule