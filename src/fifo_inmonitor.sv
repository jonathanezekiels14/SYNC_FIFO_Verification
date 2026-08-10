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
			`uvm_fatal(get_full_name(),"Monitor Failed to get config_db");
		inp_mon_port = new("inp_mon_port",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif=cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			@(vif.mon_cb);
			if (vif.mon_cb.wr_en == 1 && vif.mon_cb.wr_cs == 1) begin
				fifo_transaction tx = fifo_transaction::type_id::create("tx");
				tx.wr_cs = vif.mon_cb.wr_cs;
				tx.wr_en = vif.mon_cb.wr_en;
				tx.data_in = vif.mon_cb.data_in;
				tx.full = vif.mon_cb.full;
				`uvm_info(get_full_name(),{"WRITE TX Captured:\n" tx.convert2string()},"UVM_HIGH");
				inp_mon_port.write(tx);
			end
		end
	endtask
endclass
