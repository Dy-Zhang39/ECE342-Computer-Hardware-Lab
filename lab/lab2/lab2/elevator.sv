`timescale 1ns/1ns

module elevator 
(
  input i_clock,
  input i_reset,
  input [1:0] i_buttons,
  output [1:0] o_current_floor
);
  
  logic dp_up, dp_down, done_moving;
  
  controlpath thecontrolpath(
    .i_clock(i_clock),
    .i_reset(i_reset),
    .i_buttons(i_buttons),
    .o_current_floor(o_current_floor),
    .i_done(done_moving),
    .o_dp_up(dp_up),
    .o_dp_down(dp_down)
  );
  
  datapath thedatapath(
    .i_clock(i_clock),
    .i_reset(i_reset),
    .i_dp_up(dp_up),
    .i_dp_down(dp_down),
    .o_done(done_moving)
  );  

endmodule

module controlpath (
  input i_clock,
  input i_reset,
  input [1:0] i_buttons,
  output logic [1:0] o_current_floor,
  input i_done, 
  output logic o_dp_up,
  output logic o_dp_down
);
  
  // Declare two objects, 'state' and 'nextstate' of type enum.
  // Add more states as needed for your design. 
  enum int unsigned{
    S_G,
    S_1,
    S_2,
    S_3,
	S_UP_PRESS,
	S_UP_WAIT,
	S_DOWN_PRESS,
	S_DOWN_WAIT
  } state, nextstate;
  
  // Clocked always block for making state registers
  always_ff @ (posedge i_clock or posedge i_reset) begin
    if (i_reset) state <= S_G;
    else state <= nextstate;
  end
  
  logic [1:0] current_floor_reg;
  always_ff @(posedge i_clock or posedge i_reset) begin
	if (i_reset) current_floor_reg <= 2'b0;
	else current_floor_reg <= o_current_floor;
  end
  
  
  // There is a mix of moore and mealy type in this FSM. 
  // The outputs o_dp_up and o_dp_down are "moore-type" in that they only respond to the current state. This allows these two signals to be asserted high
  // "undisturbed" for an entire clock cycle, without worrying about fluctuating inputs
  // However, the output "o_current_floor" is "mealy-type" in that it depends on the input i_done. This way, the output changes immediately when the elevator
  // passes a floor, rather than waiting for the state to change on the next clock cycle. This is required as a part of the lab.
  always_comb begin
    nextstate = state;
    o_dp_up = 1'b0;
    o_dp_down = 1'b0;
    o_current_floor = current_floor_reg;
    
    case(state)
	
		S_G: begin
			if (i_buttons != o_current_floor) nextstate = S_UP_PRESS;
			else nextstate = S_G;
		end
		
		S_1: begin
			if (i_buttons > o_current_floor) nextstate = S_UP_PRESS;
			else if (i_buttons < o_current_floor) nextstate = S_DOWN_PRESS;
			else nextstate = S_1;
		end
		
		S_2: begin
			if (i_buttons > o_current_floor) nextstate = S_UP_PRESS;
			else if (i_buttons < o_current_floor) nextstate = S_DOWN_PRESS;
			else nextstate = S_2;
		end
		
		S_3: begin
			if (i_buttons != o_current_floor) nextstate = S_DOWN_PRESS;
			else nextstate = S_3;
		end
		
		S_UP_PRESS: begin
			o_dp_up = 1'b1;
			nextstate = S_UP_WAIT;
		end
		
		S_UP_WAIT: begin
			if (i_done) begin
				o_current_floor = o_current_floor + 1;
				if (o_current_floor == i_buttons) begin
					case(i_buttons)
						2'd1: nextstate = S_1;
						2'd2: nextstate = S_2;
						2'd3: nextstate = S_3;
					endcase
				end 
				else nextstate = S_UP_PRESS;
			end
			else nextstate = S_UP_WAIT;
		end
	
		S_DOWN_PRESS: begin	
			o_dp_down = 1'b1;
			nextstate = S_DOWN_WAIT;
		end
		
		S_DOWN_WAIT: begin
			if (i_done) begin
				o_current_floor = o_current_floor - 1;
				if (o_current_floor == i_buttons) begin
					case(i_buttons)
						2'd0: nextstate = S_G;
						2'd1: nextstate = S_1;
						2'd2: nextstate = S_2;
					endcase
				end 
				else nextstate = S_DOWN_PRESS;
			end
			else nextstate = S_DOWN_WAIT;
		end
    endcase
	

  end
  
endmodule

// The datapath takes a move up or move down input and waits 5 cycles 
// before asserting o_done, to indicate that it has moved 1 floor. 
// NOTE 1: You do not need to edit the data path code. 
// NOTE 2: The datapath doesn't do any error checking; so if you ask it to move down
// from G or move up from 3, it will still do that. All checks should happen
// inside the control path. 
module datapath (
  input i_clock,
  input i_reset,
  input i_dp_up,
  input i_dp_down,
  output o_done 
);
  
  logic [2:0] count;
  
  always_ff @ (posedge i_clock or posedge i_reset) begin
    if ((i_reset) || (i_dp_up) || (i_dp_down))
      count <= 3'd0;
    else
      count <= count + 3'd1;
  end
  
  assign o_done = (count == 3'd5);
          
endmodule
