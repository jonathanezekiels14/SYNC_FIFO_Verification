class fifo_regression_test extends fifo_base_test;
	`uvm_component_utils(fifo_regression_test)

	// constructor
	function new(string name = "fifo_regression_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	// run phase
	virtual task run_phase(uvm_phase phase);
		fifo_sanity_sequence sanity_seq;
		fifo_corner_sequence corner_seq;
		fifo_error_sequence error_seq;
		fifo_rand_sequence rand_seq;

		// set drain time and raise objection
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this);

		`uvm_info("REG_TEST", "==================================================", UVM_LOW)
		`uvm_info("REG_TEST", "STARTING COMPREHENSIVE FIFO REGRESSION", UVM_LOW)
		`uvm_info("REG_TEST", "==================================================", UVM_LOW)

		// execute sanity test
		`uvm_info("REG_TEST", "Sanity Test", UVM_LOW)
		sanity_seq = fifo_sanity_sequence::type_id::create("sanity_seq");
		sanity_seq.start(env.in_agent.sqr);

		// execute corner case test
		`uvm_info("REG_TEST", "Corner Test", UVM_LOW)
		corner_seq = fifo_corner_sequence::type_id::create("corner_seq");
		corner_seq.start(env.in_agent.sqr);

		// execute error case test
		`uvm_info("REG_TEST", "Error Test", UVM_LOW)
		error_seq = fifo_error_sequence::type_id::create("error_seq");
		error_seq.start(env.in_agent.sqr);

		// execute constrained random test
		`uvm_info("REG_TEST", "Rand Test", UVM_LOW)
		rand_seq = fifo_rand_sequence::type_id::create("rand_seq");
		rand_seq.start(env.in_agent.sqr);

		`uvm_info("REG_TEST", "==================================================", UVM_LOW)
		`uvm_info("REG_TEST", "ALU REGRESSION SUITE COMPLETED SUCCESSFULLY", UVM_LOW)
		`uvm_info("REG_TEST", "==================================================", UVM_LOW)

		phase.drop_objection(this);
	endtask
endclass
