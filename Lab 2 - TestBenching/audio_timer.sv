`default_nettype none

/*
This module is a wrap around counter that can be controlled.
*/

module audio_timer #(parameter N = 24, count_limit = 24'h7FFFF) (
	input logic [1:0] control,
	input logic clk,
	output logic [N-1:0] counter);
	
	logic [N-1:0] next_counter;
	
	localparam [N-1:0] one = 1;
	
	//define control options, increase and decrease occurs on clock
	localparam reset_counter = 2'b00;
	localparam increase_counter = 2'b01;
	localparam decrease_counter = 2'b10;
	localparam pause_counter = 2'b11;
	
	always_ff @(posedge clk)
		begin
			counter <= next_counter;
		end
	
	//	Next state logic
	always_comb
		begin
			casex(control)
				pause_counter: next_counter = counter;
				increase_counter: begin 
					if(counter != count_limit)
						next_counter = counter + one;
					else
						next_counter = 0;
					end
				decrease_counter: begin 
					if(counter != 0)
						next_counter = counter - one;
					else
						next_counter = count_limit;
					end
				reset_counter: next_counter = 0;
				default: next_counter = 0;
			endcase
		end
	
endmodule

`default_nettype wire

