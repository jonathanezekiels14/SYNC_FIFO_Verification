`include "defines.svh"
`include "fifo_interface.sv"
`include "fifo_pkg.sv"

module top;

	import uvm_pkg::*;
	import fifo_pkg::*;

	logic clk;

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	fifo_interface vif(clk);

	syn_fifo dut(
		.clk(clk),
		.rst(vif.rst),
		.wr_cs(vif.wr_cs),
		.rd_cs(vif.rd_cs),
		.rd_en(vif.rd_en),
		.wr_en(vif.wr_en),
		.data_in(vif.data_in),
		.data_out(vif.data_out),
		.empty(vif.empty),
		.full(vif.full)
	);

	initial begin
		vif.wr_cs = 0;
		vif.rd_cs = 0;
		vif.wr_en = 0;
		vif.rd_en = 0;
		vif.data_in = 0;
		vif.rst = 0;
		@(posedge clk);
		vif.rst = 1;
		repeat (2) @(posedge clk);
		vif.rst = 0;
		`uvm_info("TB_TOP", "Initial Reset Released.", UVM_LOW)
	end
	initial begin
		uvm_config_db#(virtual fifo_interface)::set(null, "*", "vif", vif);
		run_test();
	end
endmodule
