class fifo_out_agent extends uvm_agent;

	`uvm_component_utils(fifo_out_agent)

	fifo_config cfg;
	fifo_driver drv;
	fifo_sequencer sqr;
	fifo_outmonitor mon;
	uvm_analysis_port #(fifo_transaction) out_agent_ap;

	function new(string name = "fifo_out_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(fifo_config)::get(this,"","fifo_config",cfg))
			`uvm_fatal(get_name(),"Agent Failed to get Config_db");
		mon = fifo_outmonitor::type_id::create("mon",this);
		out_agent_ap = new("out_agent_ap",this);
		if (cfg.is_active == UVM_ACTIVE) begin
			drv = fifo_driver::type_id::create("drv",this);
			sqr = fifo_sequencer::type_id::create("sqr",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mon.out_mon_port.connect(out_agent_ap);

		if(cfg.is_active == UVM_ACTIVE)
			drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction

endclass


		
