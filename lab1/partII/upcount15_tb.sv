`timescale 1ns / 1ns
module upcount15_tb ();

//generate a 50Mhz clock
logic clk;
initial clk = 1'b0;
always #10 clk = ~clk; //wait 10 ns and flip the clock

logic sreset, dut_enable, dut_last;
logic [3:0] dut_val;
upcount15 DUT(.clk(clk), .sreset(sreset), .o_val(dut_val), .i_enable(dut_enable), .o_last(dut_last));

initial begin
  dut_enable = 1'b0;  //start with the enable signal off
  sreset = 1'b1;       //start with reset on

//@(posedge clk); // Waits until the next positive clock edge
//@(negedge clk); // ... or negative clock edge
//wait(dut_done); // Waits for dut_done == 1’b1

  @(posedge clk);
  sreset =  1'b0;     //leave the sreset on for one clk cycle and then turn it off

  @(posedge clk);
  dut_enable = 1'b1; //set the enable signala on

  wait(dut_last); //wait for counter to finish
  if(dut_val!==4'b1111) begin
    $display("Error! Counter asserted  o_last, but o_val was %d, instead of 15.", dut_val);
    $stop();
  end

  @(posedge clk); //wait 1 cycle before doing something else
  $stop();

end

endmodule // upcount15_tb
