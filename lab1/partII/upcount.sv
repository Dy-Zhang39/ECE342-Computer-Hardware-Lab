module upcount #    //parameters section that begins with a #, coming before the usual input/output signals section
  (
  parameter N = 20,
  parameter Nbits = $clog2(N)   //clog2 built-in system function (which is only available in SystemVerilog) evaluates (at compile time!) the base 2 logarithm of the value and rounds it up to the next integer. In e↵ect, it counts how many bits are required to represent a given value. But it can only work with a constant value; so don’t try to pass in input to clog2
  )
  (
  input clk,
  input sreset,
  output [Nbits-1:0] o_val,
  input i_enable,
  output o_last
  );
  logic [Nbits-1:0] count;

  always_ff @ (posedge clk) begin
    if (sreset) count <= 'd0; //the bit width can be ignored in System Verilog
    else begin
      if(i_enable) begin
        if (o_last) count <= 'd0;
        else count <= count + 'd1;
      end//if
    end //else
  end //always_ff

assign o_val = count;
assign o_last = (count == N-1) ? 1'b1 : 1'b0;
//above same as assign o_last = count == N-1


endmodule // upcounter
