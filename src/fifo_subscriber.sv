class fifo_subscriber extends uvm_subscriber #(fifo_transaction)
	`uvm_component_utils(fifo_subscriber)

	fifo_transaction cov_tx;
	covergroup cg1;
		option.per_instance = 1;

		cp_wr_cs: coverpoint cov_tx.wr_cs;

	function new(string name = "fifo_subscriber",uvm_component parent);
		super.new(name,this);
	endfunction

	
