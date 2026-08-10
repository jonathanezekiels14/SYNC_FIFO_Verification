class fifo_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(fifo_scoreboard)

	uvm_tlm_analysis_fifo #(fifo_transaction) inp_fifo;
	uvm_tlm_analysis_fifo #(fifo_transaction) out_fifo;

	function new(string name = "fifo_scoreboard", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		inp_fifo = new("inp_fifo",this);
		out_fifo = new("out_fifo",this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		fifo_transaction exp_tx,act_tx;

		forever begin
			inp_fifo.get(exp_tx);
			predict_output(exp_tx);
			out_fifo.
