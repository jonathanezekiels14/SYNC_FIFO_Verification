class fifo_rand_sequence extends fifo_base_sequence;
	`uvm_object_utils(fifo_rand_sequence)

	function new(string name = "fifo_rand_sequence");
		super.new(name);
	endfunction

	virtual task body();
		fifo_transaction tx;
		repeat (500) begin
			tx = fifo_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with { 
				wr_en != rd_en;
			})
			finish_item(tx);
		end

	endtask
endclass

