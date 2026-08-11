class fifo_subscriber extends uvm_subscriber #(fifo_transaction);
	`uvm_component_utils(fifo_subscriber)

	fifo_transaction cov_tx;
	
	covergroup cg1;

		cp_wr_cs: coverpoint cov_tx.wr_cs;

		cp_rd_cs: coverpoint cov_tx.rd_cs;

		cp_wr_en: coverpoint cov_tx.wr_en;

		cp_rd_en: coverpoint cov_tx.rd_en;

		cx_wr_cs_en: cross cp_wr_cs, cp_wr_en;

		cx_rd_cs_en: cross cp_rd_cs, cp_rd_en;

		cx_write_read: cross cp_wr_cs, cp_rd_cs, cp_wr_en, cp_rd_en;

	endgroup

	function new(string name = "fifo_subscriber", uvm_component parent);
		super.new(name, parent); 
		cg1 = new();
	endfunction

	virtual function void write(fifo_transaction t);
		this.cov_tx = t;
		cg1.sample();
	endfunction

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SUBSCRIBER", $sformatf("Functional Coverage = %0.2f%%", cg1.get_inst_coverage()), UVM_NONE)
	endfunction
endclass
