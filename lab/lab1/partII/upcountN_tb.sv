`timescale 1ns / 1ns
module upcountN_tb ();

//generate a 50Mhz clock
logic clk;
initial clk = 1'b0;
always #10 clk = ~clk; //wait 10 ns and flip the clock


//create a val to hold the count value
logic [4:0] count17_val;
logic [6:0] count112_val;
logic [5:0] count60_val;

logic sreset17, dut_enable17, dut_last17, sreset112, dut_enable112, dut_last112, sreset60, dut_enable60, dut_last60;
upcount # (.N(17)) count17
(
.clk(clk),
.sreset(sreset17),
.o_val(count17_val),
.i_enable(dut_enable17),
.o_last(dut_last17)
);

upcount # (.N(112)) count112
(
.clk(clk),
.sreset(sreset112),
.o_val(count112_val),
.i_enable(dut_enable112),
.o_last(dut_last112)
);

upcount # (.N(60)) count60
(
.clk(clk),
.sreset(sreset60),
.o_val(count60_val),
.i_enable(dut_enable60),
.o_last(dut_last60)
);


initial begin

  //run count17
  dut_enable17 = 'd0;  //start with the enable signal off
  dut_enable60 = 'd0;
  dut_enable112 = 'd0;
  sreset17 = 'd1;       //start with reset on


  @(posedge clk);
  sreset17 =  'd0;     //leave the sreset on for one clk cycle and then turn it off

  @(posedge clk);
  dut_enable17 = 'd1; //set the enable signala on

  wait(dut_last17); //wait for longest counter to finish

  if(count17_val!== 'd16) begin
    $display("Error! Counter asserted  dut_last17, but count17_val was %d, instead of 16.", count17_val);
    $stop();
  end

  //run count60
  //start with the enable signal off
  dut_enable17 = 'd0;
  sreset60 = 'd1;       //start with reset on


  @(posedge clk);
  sreset60 =  'd0;     //leave the sreset on for one clk cycle and then turn it off

  @(posedge clk);
  dut_enable60 = 'd1; //set the enable signala on

  wait(dut_last60); //wait for longest counter to finish

  if(count60_val!== 'd59) begin
    $display("Error! Counter asserted  dut_last60, but dut_last60 was %d, instead of 59.", dut_last60);
    $stop();
  end

  //run count112
  dut_enable60 = 'd0;  //start with the enable signal off
  sreset112 = 'd1;       //start with reset on


  @(posedge clk);
  sreset112 =  'd0;     //leave the sreset on for one clk cycle and then turn it off

  @(posedge clk);
  dut_enable112 = 'd1; //set the enable signala on

  wait(dut_last112); //wait for longest counter to finish

  if(count112_val!== 'd111) begin
    $display("Error! Counter asserted  dut_last112, but dut_last112 was %d, instead of 111.", dut_last112);
    $stop();
  end

  //finished three count
  @(posedge clk); //wait 1 cycle before doing something else
  $stop();

end

endmodule // upcount15_tb
