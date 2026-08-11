class fifo_env extends uvm_env;
	`uvm_component_utils(fifo_env)

	fifo_inp_agent in_agent;
	fifo_out_agent out_agent;
	fifo_scoreboard scb;
	fifo_subscriber sub;
	fifo_config cfg;

	function new(string name = "fifo_env", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(fifo_config)::get(this,"","fifo_config",cfg))
			`uvm_fatal(get_name(),"Environment Failed to get Config_db");
		uvm_config_db#(uvm_active_passive_enum)::set(this,"in_agent","is_active",cfg.is_active);
		in_agent = fifo_inp_agent::type_id::create("in_agent",this);
		out_agent = fifo_out_agent::type_id::create("out_agent",this);
		scb = fifo_scoreboard::type_id::create("scb",this);
		sub = fifo_subscriber::type_id::create("sub",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		in_agent.inp_agent_ap.connect(scb.inp_fifo.analysis_export);
		out_agent.out_agent_ap.connect(scb.out_fifo.analysis_export);
	endfunction
endclass

