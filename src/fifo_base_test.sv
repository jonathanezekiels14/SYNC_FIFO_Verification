class fifo_base_test extends uvm_test;
	`uvm_component_utils(fifo_base_test)

	fifo_env env;
	fifo_config cfg;

	function new(string name = "fifo_base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cfg = fifo_config::type_id::create("cfg");
		if (!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", cfg.vif)) begin
			`uvm_fatal("BASE_TEST", "Could not find the virtual interface 'vif' in the config_db!")
		end
		cfg.is_active = UVM_ACTIVE; 
		uvm_config_db#(fifo_config)::set(this, "*", "fifo_config", cfg);
		env = fifo_env::type_id::create("env", this);

	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info("BASE_TEST", "Printing UVM Topology:", UVM_NONE)
		uvm_top.print_topology();
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this,500ns);
	endtask
endclass

