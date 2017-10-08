`default_nettype none
/*
The module is used to select between outputing
the upper or lower halves of a bus.  The output
will be written on the posedge of the slow clock.
*/
module flash_out_capture #(parameter N = 32)(
	input logic [N-1:0] read_data,
	input logic data_valid,
	input logic data_bus_select,
	input logic fast_clock,
	input logic slow_clock,
	output logic [((N/2)-1):0] data_bus);
	
	logic [N-1:0] full_bus, next_full_bus;
	logic [((N/2)-1):0] next_data_bus;
	
	// Slow Clock register logic
	always_ff @(posedge slow_clock)
		data_bus <= next_data_bus;
		
	always_comb
		next_data_bus = (data_bus_select ? (full_bus [(N-1):(N/2)] ) : (full_bus [((N/2)-1):0]));
		
	// Fast Clock register logic
	always_ff @(posedge fast_clock)
		full_bus <= next_full_bus;
		
	always_comb
		next_full_bus <= (data_valid ? (read_data):(full_bus));
		
endmodule

