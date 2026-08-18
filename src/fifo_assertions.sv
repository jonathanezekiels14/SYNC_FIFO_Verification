`include "uvm_macros.svh"
module fifo_assertion(
	input clk, rst,
	input [`DATA_WIDTH-1:0] data_in, data_out,
	input wr_cs, rd_cs, wr_en, rd_en, full, empty

);
	int count=0;
	import uvm_pkg::*;

	bit reset_assertion_test = 1;
	bit full_assertion_test=1;
	bit empty_assertion_test=1;

	property reset_assertion;
		@(posedge clk)
		$rose(rst)|-> (data_out == 0)&&(!full)&&(empty);
	endproperty

	property full_assertion;
		@(posedge clk)
		(wr_cs && wr_en)|-> ##(2**`ADDR_WIDTH) full;
	endproperty

	property empty_assertion;
		@(posedge clk)
		(rd_cs &&rd_en)|-> ##(2**`ADDR_WIDTH) empty;
	endproperty


	assert property(reset_assertion)
	else begin
		reset_assertion_test =0;
	end
	assert property(full_assertion)
	else begin 
		full_assertion_test =0;
	end
	assert property(empty_assertion)
	else begin 
		empty_assertion_test=0;
	end

	task assertion_report;
		if(reset_assertion_test == 0) 
			`uvm_info("ASR","reset_assertion_test FAILED !!!!!!!",UVM_NONE)
		else begin
			count++;
			`uvm_info("ASR","reset_assertion_test PASSED........",UVM_NONE)
		end
		if(full_assertion_test == 0)
			`uvm_info("ASR","full_assertion_test FAILED !!!!!!!",UVM_NONE)
		else begin
			`uvm_info("ASR","full_assertion_test PASSED.........",UVM_NONE)
			count++;
		end
		if(empty_assertion_test ==0)
			`uvm_info("ASR","empty_assertion_test FAILED !!!!!!!",UVM_NONE)
		else begin
			`uvm_info("ASR","empty_assertion_test PASSED.........",UVM_NONE)
			count++;
		end
		if((reset_assertion_test == 0) || (full_assertion_test == 0) || (empty_assertion_test ==0) ) begin
			`uvm_info("ASR","SOME ASSERTIONS FAILED!!!!!!!!!!!!!!!",UVM_NONE)
		end
		else
			`uvm_info("ASR","ALL ASSERTIONS PASSED...............",UVM_NONE)

		`uvm_info("ASR",$sformatf("Total %d assertions passed out of 3",count),UVM_NONE)
	endtask
endmodule
