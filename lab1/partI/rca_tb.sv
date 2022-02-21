`timescale 1ns / 1ns //set defult units for delay statements 'timescale <time_unit> / <time_precision>



module tb (); //no inputs or outputs
  logic [7:0] dut_x, dut_y;
  logic [8:0] dut_out;

  //instantiate the design under test and the RCAgen
  RCAgen DUT (.x(dut_x), .y(dut_y), .sum(dut_out));

  //drive the inputs

  /* method one: assign specific value
  assign dut_x = 8'd5;
  assign dut_y = 8'd7;
  */

  //methond two: testing mutiple cases
  //initial block: execute this code only once, starting ar the beginning of time
  initial begin
    for (integer x = 0;  x < 256; x++) begin //here integer x == logic [31:0] x;
      for (integer y = 0;  y < 256; y++) begin
        logic [8:0] realsum;
        realsum = x + y;

        dut_x = x[7:0]; //pick the rightmost 8bit
        dut_y = y[7:0];
        #5; //wait 5ns (ns buz of the timescale directive)

        if(dut_out !== realsum) begin //!== lets you compare against x and z values, x means unkown value(wire connected but not initialized or initialized twice), z means high impedence(wire not connect to the circuit)
          $display("Mismatch! %d + %d should be %d, got %d instead", x, y, realsum, dut_out);
          $stop();
        end
      end //for y
    end //for x

    $display("Test passed!");
    $stop();
  end //initial
endmodule // tb

/* use 'vlog' command to compile .v and .sv in ModelSim, files will be searched in current directory, compiled file will be saved at the 'work' folder by default;

cd ../path/to/source/files
vlib work         # creates ’work’ library
vlog <filename>   # compiles source files into ’work’ library
vsim <module_name>
log *
add wave *


*/
