class fifo_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_monitor)

	uvm_analysis_port #(fifo_transaction) mon_port;
	virtual fifo_interface vif;
	fifo_config cfg;

	function new(string name = "fifo_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(fifo_config)::get(this,"","fifo_config",cfg))
			`uvm_fatal(get_full_name(),"Monitor Failed to get config_db");
		mon_port = new("mon_port",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif=cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			@(vif.mon_cb);
			fifo_transaction tx = fifo_transaction::type_id::create("tx");
			tx.wr_cs = vif.mon_cb.wr_cs;
			tx.rd_cs = vif.mon_cb.rd_cs;
			tx.wr_en = vif.mon_cb.wr_en;
			tx.rd_en = vif.mon_cb.rd_en;
			tx.data_in = vif.mon_cb.data_in;
			tx.data_out = vif.mon_cb.data_out;
			tx.full = vif.mon_cb.full;
			tx.empty = vif.mon_cb.empty;
			`uvm_info(get_full_name(),tx.convert2string(),"UVM_HIGH");
			mon_port.write(tx);
		end
	endtask
endclass

