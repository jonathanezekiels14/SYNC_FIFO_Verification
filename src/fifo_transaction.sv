class fifo_transaction extends uvm_sequence_item;

	// Inputs
	rand logic wr_cs,rd_cs;
	rand logic wr_en,rd_en;
	rand logic [`DATA_WIDTH-1:0] data_in;
	logic [`DATA_WIDTH-1:0] data_out;
	logic full,empty;

	`uvm_object_utils_begin(fifo_transaction)
		`uvm_field_int(wr_cs,UVM_DEFAULT|UVM_BIN)
		`uvm_field_int(rd_cs,UVM_DEFAULT|UVM_BIN)
		`uvm_field_int(wr_en,UVM_DEFAULT|UVM_BIN)
		`uvm_field_int(rd_en,UVM_DEFAULT|UVM_BIN)
		`uvm_field_int(data_in,UVM_DEFAULT|UVM_DEC)
		`uvm_field_int(data_out,UVM_DEFAULT|UVM_DEC)
		`uvm_field_int(full,UVM_DEFAULT|UVM_BIN)
		`uvm_field_int(empty,UVM_DEFAULT|UVM_BIN)
	`uvm_object_utils_end

	function new(string name = "fifo_transaction");
		super.new(name);
	endfunction

endclass

