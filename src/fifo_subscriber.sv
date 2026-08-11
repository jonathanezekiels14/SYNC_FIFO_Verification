class fifo_subscriber extends uvm_component;
	`uvm_component_utils(fifo_subscriber)

	virtual fifo_interface vif;
	fifo_config cfg;
	
	fifo_transaction cov_tx;

	covergroup cg1;
		option.per_instance = 1;

		cp_wr_cs: coverpoint cov_tx.wr_cs{
			bins wr_on = {1};
			bins wr_off = {0};
		}

		cp_rd_cs: coverpoint cov_tx.rd_cs{
			bins rd_on = {1};
			bins rd_off = {0};
		}

		cp_wr_en: coverpoint cov_tx.wr_en{
			bins wr_en_on = {1};
			bins wr_en_off = {0};
		}

		cp_rd_en: coverpoint cov_tx.rd_en{
			bins rd_en_on = {1};
			bins rd_en_off = {0};
		}

		cx_wr_cs_en: cross cp_wr_cs, cp_wr_en;

		cx_rd_cs_en: cross cp_rd_cs, cp_rd_en;

		cx_write_read: cross cp_wr_cs, cp_rd_cs, cp_wr_en, cp_rd_en;

		cp_data_in: coverpoint cov_tx.data_in {
			bins low  = {[0:85]};
			bins med  = {[86:170]};
			bins high = {[171:255]};
		}
	endgroup

	function new(string name = "fifo_subscriber", uvm_component parent);
		super.new(name, parent);
		cg1 = new();
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(fifo_config)::get(this, "", "fifo_config", cfg)) begin
			`uvm_fatal("COV", "Coverage collector failed to get config_db");
		end
		
		cov_tx = fifo_transaction::type_id::create("cov_tx");
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif = cfg.vif;
	endfunction
	virtual task run_phase(uvm_phase phase);
		forever begin
			@(vif.mon_cb);
			
			if (vif.rst == 1'b0) begin
				cov_tx.wr_cs   = vif.mon_cb.wr_cs;
				cov_tx.wr_en   = vif.mon_cb.wr_en;
				cov_tx.rd_cs   = vif.mon_cb.rd_cs;
				cov_tx.rd_en   = vif.mon_cb.rd_en;
				cov_tx.data_in = vif.mon_cb.data_in;
				
				cg1.sample();
			end
		end
	endtask

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SUBSCRIBER", $sformatf("Functional Coverage = %0.2f%%", cg1.get_inst_coverage()), UVM_NONE)
	endfunction
endclass
