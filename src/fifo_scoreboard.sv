class fifo_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(fifo_scoreboard)

	uvm_tlm_analysis_fifo #(fifo_transaction) inp_fifo;
	uvm_tlm_analysis_fifo #(fifo_transaction) out_fifo;

	logic [`DATA_WIDTH-1:0] q[$:((2**`ADDR_WIDTH)-1)];
	int pass_count,fail_count = 0;

	function new(string name = "fifo_scoreboard", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		inp_fifo = new("inp_fifo",this);
		out_fifo = new("out_fifo",this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		fork
		forever begin
			fifo_transaction inp_tx;
			inp_fifo.get(inp_tx);
			
			if (inp_tx.full == 1'b0) begin
				q.push_front(inp_tx.data_in);
				`uvm_info("SCBD_WRITE", $sformatf("Stored Data: 'd%0d | Queue Size: %0d", inp_tx.data_in, q.size()), UVM_HIGH);
			end else begin
				`uvm_info("SCBD_OVERFLOW_DROP", "DUT is full! Write dropped by hardware and scoreboard.", UVM_HIGH);
			end
		end

		forever begin
			fifo_transaction out_tx;
			logic [`DATA_WIDTH-1:0] exp_data;
			out_fifo.get(out_tx);

			if(q.size() > 0) begin
				exp_data = q.pop_back();

				if(exp_data === out_tx.data_out) begin
					`uvm_info("SCBD_PASS", $sformatf("PASS! Expected: 'd%0d | Actual: 'd%0d", exp_data, out_tx.data_out), UVM_LOW);
					pass_count++;
				end
				else begin
					`uvm_error("SCBD_MISMATCH", $sformatf("FAIL! Expected: 'd%0d | Actual: 'd%0d", exp_data, out_tx.data_out));
					fail_count++;
				end
			end
			else begin
				`uvm_error("SCBD_UNDERFLOW", $sformatf("DUT read out data 'd%0d, but the expected queue is EMPTY!", out_tx.data_out));
				fail_count++;
			end
		end
	join
	endtask	
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SCBD_REPORT", "-----------------------------------------", UVM_NONE);
		`uvm_info("SCBD_REPORT", $sformatf(" Total Matches    : %0d", pass_count), UVM_NONE);
		`uvm_info("SCBD_REPORT", $sformatf(" Total Mismatches : %0d", fail_count), UVM_NONE);
		`uvm_info("SCBD_REPORT", $sformatf(" Data Left in FIFO: %0d", q.size()), UVM_NONE);
		`uvm_info("SCBD_REPORT", "-----------------------------------------", UVM_NONE);	
	endfunction
endclass


