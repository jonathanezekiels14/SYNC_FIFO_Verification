class fifo_sanity_test extends fifo_base_test;
	`uvm_component_utils(fifo_sanity_test)

	function new (string name = "fifo_sanity_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		fifo_sanity_sequence seq;
		phase.phase_done.set_drain_time(this,800ns);
		phase.raise_objection(this);
		seq = fifo_sanity_sequence::type_id::create("seq");
		seq.start(env.in_agent.sqr);
		phase.drop_objection(this);
	endtask
endclass
