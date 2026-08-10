class fifo_outmonitor extends uvm_monitor;
	`uvm_component_utils(fifo_outmonitor)

	uvm_analysis_port #(fifo_transaction) out_mon_port;
	virtual fifo_interface.MON vif;
	fifo_config cfg;

	function new(string name = "fifo_outmonitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(fifo_config)::get(this,"","fifo_config",cfg))
			`uvm_fatal(get_full_name(),"Monitor Failed to get config_db");
		out_mon_port = new("out_mon_port",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif=cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			@(vif.mon_cb);

			if(vif.mon_cb.rd_en == 1 && vif.mon_cb.rd_cs == 1 && vif.mon_cb.empty == 0) begin
				fifo_transaction tx = fifo_transaction::type_id::create("tx");
				tx.rd_cs = vif.mon_cb.rd_cs;
				tx.rd_en = vif.mon_cb.rd_en;
				tx.empty = vif.mon_cb.empty;
				delay_capture(tx);
			end
		end
	endtask

	task delay_capture(fifo_transaction data_tx);
		fork
			begin
				@(vif.mon_cb);
				data_tx.data_out = vif.mon_cb.data_out;
				`uvm_info(get_full_name(),{"READ TX Captured:\n",data_tx.convert2string()},UVM_MEDIUM);
				out_mon_port.write(data_tx);
			end
		join_none
	endtask
endclass
