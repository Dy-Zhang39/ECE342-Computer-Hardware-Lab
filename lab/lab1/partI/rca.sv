//one bit full adder
module FA1bit(a, b, cin, s, cout);
input logic a, b, cin;
output logic s, cout;

logic x,y,z;
assign x=a^b;
assign y=x&cin;
assign z=a&b;
assign s=x^cin;
assign cout=y|z;

endmodule


//8 bit RCAmanual
module RCAmanual(input logic [7:0] x, input logic [7:0] y, output logic [8:0] sum);

logic [8:0] cin;
assign sum[8]=cin[8];

FA1bit fa0(.a(x[0]), .b(y[0]), .cin(1'b0), .s(sum[0]), .cout(cin[1]));
FA1bit fa1(.a(x[1]), .b(y[1]), .cin(cin[1]), .s(sum[1]), .cout(cin[2]));
FA1bit fa2(.a(x[2]), .b(y[2]), .cin(cin[2]), .s(sum[2]), .cout(cin[3]));
FA1bit fa3(.a(x[3]), .b(y[3]), .cin(cin[3]), .s(sum[3]), .cout(cin[4]));
FA1bit fa4(.a(x[4]), .b(y[4]), .cin(cin[4]), .s(sum[4]), .cout(cin[5]));
FA1bit fa5(.a(x[5]), .b(y[5]), .cin(cin[5]), .s(sum[5]), .cout(cin[6]));
FA1bit fa6(.a(x[6]), .b(y[6]), .cin(cin[6]), .s(sum[6]), .cout(cin[7]));
FA1bit fa7(.a(x[7]), .b(y[7]), .cin(cin[7]), .s(sum[7]), .cout(cin[8]));

endmodule


////8 bit RCAgen
module RCAgen(input logic [7:0] x, input logic [7:0] y, output logic [8:0] sum);

logic [8:0] cin;

assign cin[0]=1'b0;
assign sum[8]=cin[8];

genvar i;
generate
	for(i=0; i<8; i++) begin : adders
		FA1bit fa_inst (.a(x[i]), .b(y[i]), .cin(cin[i]), .s(sum[i]), .cout(cin[i+1]));
	end
endgenerate
endmodule
