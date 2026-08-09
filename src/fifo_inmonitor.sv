class fifo_inmonitor extends uvm_monitor;
	`uvm_component_utils(fifo_inmonitor)

	uvm_analysis_port #(fifo_transaction) inp_mon_port;
	virtual fifo_interface vif;
	fifo_config cfg;

	function new(string name = "fifo_inmonitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(fifo_config)::get(this,"","fifo_config",cfg))
			`uvm_fatal("fifo_inmonitor","Driver Failed to get config_db");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif=cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			@(vif.inp_monitor_cb);

