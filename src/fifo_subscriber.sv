class fifo_subscriber extends uvm_subscriber #(fifo_transaction)
	`uvm_component_utils(fifo_subscriber)

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

		cx_wr_cs_en: cross cp_wr_cs,cp_wr_en;

		cx_rd_cs_en: cross cp_rd_cs,cp_rd_en;

		cx_write_read: cross cx_wr_cs_en, cx_rd_cs_en;

		cp_data_in: coverpoint tx.data_in;

	endgroup

	function new(string name = "fifo_subscriber",uvm_component parent);
		super.new(name,this);
		cg1 = new();
	endfunction

	virtual function void write(fifo_transaction tx);
		if(t==null) return;
		this.cov_tx = tx;
		cg1.sample();
	endfunction

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SUBSCRIBER",$sformatf("Functional Coverage = %0.2f%%",cg1.get_inst_coverage()),UVM_LOW)
	endfunction
endclass
