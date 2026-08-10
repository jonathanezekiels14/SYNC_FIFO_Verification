class fifo_sanity_sequence extends fifo_base_sequence;
	`uvm_object_utils(fifo_sanity_sequence)

	function new(string name = "fifo_sanity_sequence");
		super.new(name);
	endfunction

	virtual task body();
		fifo_transaction tx;
		repeat (2) begin
			tx = fifo_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with { 
				wr_cs == 1;
				wr_en == 1;
				rd_cs == 0;
				rd_en == 0;
			})
			finish_item(tx);
		end

		repeat (2) begin
			tx = fifo_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with { 
				wr_cs == 0;
				wr_en == 0;
				rd_cs == 1;
				rd_en == 1;
			})
			finish_item(tx);
		end
	endtask
endclass

