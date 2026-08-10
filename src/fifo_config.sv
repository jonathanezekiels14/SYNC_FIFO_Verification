class fifo_config extends uvm_object;

	`uvm_object_utils(fifo_config)

	uvm_active_passive_enum is_active = UVM_ACTIVE;
	virtual fifo_interface vif;
	
	function new(string name = "fifo_config");
		super.new(name);
	endfunction
endclass

