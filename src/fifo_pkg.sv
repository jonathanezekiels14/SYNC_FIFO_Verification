package fifo_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "defines.svh"

	`include "fifo_transaction.sv"
	`include "fifo_config.sv"

	`include "fifo_base_sequence.sv"
	`include "fifo_sanity_sequence.sv"	
	`include "fifo_corner_sequence.sv"
	`include "fifo_error_sequence.sv"
	`include "fifo_rand_sequence.sv"

	`include "fifo_sequencer.sv"

	`include "fifo_driver.sv"
	`include "fifo_inmonitor.sv"
	`include "fifo_outmonitor.sv"

	`include "fifo_inp_agent.sv"
	`include "fifo_out_agent.sv"

	`include "fifo_scoreboard.sv"
	`include "fifo_subscriber.sv"

	`include "fifo_environment.sv"

	`include "fifo_base_test.sv"
	`include "fifo_sanity_test.sv"
	`include "fifo_corner_test.sv"
	`include "fifo_error_test.sv"
	`include "fifo_rand_test.sv"
	`include "fifo_regression_test.sv"

endpackage

