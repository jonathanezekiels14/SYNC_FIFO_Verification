interface fifo_interface(input logic clk);
	// Inputs
	logic rst;
	logic wr_cs,rd_cs,wr_en,rd_en;
	logic [`DATA_WIDTH-1:0] data_in;
	
	// Outputs
	logic [`DATA_WIDTH-1:0] data_out;
	logic full,empty;

	// Clocking blocks
	clocking drv_cb @(posedge clk);
		default output #1ns;
		output wr_cs,rd_cs,wr_en,rd_en,data_in;
	endclocking

	clocking mon_cb @(posedge clk);
		default input wr_cs,rd_cs,wr_en,rd_en,data_in,data_out,full,empty;
	endclocking

	// Modports
	modport DRV (clocking drv_cb,input rst);
	modport MON (clocking mon_cb);
endinterface

