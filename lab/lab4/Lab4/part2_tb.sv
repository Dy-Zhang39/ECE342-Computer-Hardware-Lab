module part2_tb();

		logic [15:0] x, y;
		logic [15:0] result;

		logic zero, underflow, overflow, nan;

		part2 #(.E(8), .M(7)) DUT (
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
			x = 16'b1100000110010000 ;
			y = 16'b0100000100011000;
			#10;
			if (result != 16'b1100001100101011) begin
				$display("Error! -18*9.5");
				$stop();
			end

			// 13.2 * -24.7
			x = 16'b0100000101010011 ;
			y = 16'b1100000111000101;
			#10;
			if (result != 'b1100001110100010) begin
				$display("Error! 13.2 * -24.7");
				$stop();
			end


			//Special Case
			//Zero
			// +zero * #!=inf	->E=0,M=0,zero=1
			x = 16'b0;
			y = 16'b0100000100011000;
			#10;
			if (result != 16'b0 || zero == 1'b0) begin
				$display("Error! zero1");
				$stop();
			end

			// #!=inf * -zero	->E=0,M=0,zero=1
			x = 16'b0100000100011000;
			y = 16'b1000000000000000;
			#10;
			if (result != 16'b1000000000000000 || zero == 1'b0) begin
				$display("Error! zero2");
				$stop();
			end

			//NaN
			// +zero * #=inf	->S=0, E=EB,M=0,NaN=1
			x = 16'b0 ;
			y = 16'b0111111110101010;
			#10;
			if (result != 16'b0111111110000000||nan==1'b0) begin
				$display("Error! NaN1");
				$stop();
			end

			// #=-inf * zero	->S=1, E=EB,M=0,Nah=1
			x = 16'b1111111110101101;
			y = 16'b0100000100011000;
			#10;
			if (result != 'b1111111110000000 || nan==1'b0) begin
				$display("Error! NaN2");
				$stop();
			end

			//Nan * #
			x = 16'b1111111110000000;
			y = 16'b0100000100011000;
			#10;
			if (result != 'b1111111110000000 || nan==1'b0) begin
				$display("Error! NaN3");
				$stop();
			end

			//Underflow
			//s=0, E <0	->E=0,M!=0,underflow=1
			x = 16'b0010000010100110 ;
			y = 16'b0001000011001100;
			#10;
			if (result[15:7] != 9'b000000000 && result[6:0] != 7'b0 || underflow == 0) begin
				$display("Error! Underflow1");
				$stop();
			end

			//s=1, E <0	->E=0,M!=0,underflow=1
			x = 16'b0010010010100110 ;
			y = 16'b000100100011000;
			#10;
			if (result[15:7] != 9'b000000000 && result[6:0] != 7'b0 || underflow == 0) begin
				$display("Error! Underflow2");
				$stop();
			end

			//overflow
			// E >= 2**(E)-1, 2**(E)-1, M=0, overflow=1
			x = 16'b1110111111011100 ;
			y = 16'b1101111110000000;
			#10;
			if (result != 16'b0111111110000000 || overflow == 1'b0) begin
				$display("Error! Overflow2");
				$stop();
			end

			// E >= 2**(E)-1, 2**(E)-1, M=0, overflow=1
			x = 16'b0111111010110111;
			y = 16'b1111101011110110;
			#10;
			if (result != 16'b1111111110000000 || overflow == 1'b0) begin
				$display("Error! Overflow2");
				$stop();
			end




			// Need more test cases for base 16, as well as for other bases (maybe 64?)



			$display("The test passed");

			$stop();

		end
endmodule
