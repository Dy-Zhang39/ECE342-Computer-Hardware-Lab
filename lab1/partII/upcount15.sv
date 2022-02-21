module upcount15 (
  input clk,
  input sreset,
  output [3:0] o_val,
  input i_enable,
  output o_last
  );
  logic [3:0] count;

  always_ff @ (posedge clk) begin
    if (sreset) count <= 4'b0;
    else begin
      if(i_enable) begin
        if (o_last) count <= 4'b0;
        else count <= count + 1;
      end//if
    end //else
  end //always_ff

assign o_val = count;
assign o_last = (count == 4'b1111) ? 1'b1 : 1'b0;


endmodule // upcounter
