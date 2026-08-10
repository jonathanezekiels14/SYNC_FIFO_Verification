class fifo_driver extends uvm_driver #(fifo_transaction);

	`uvm_component_utils(fifo_driver)

	fifo_config cfg;
	virtual fifo_interface.DRV vif;

	function new(string name = "fifo_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(fifo_config)::get(this,"","fifo_config",cfg))
			`uvm_fatal("fifo_driver","Driver Failed to get config_db");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif=cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		reset_pins();
		forever begin
			wait(vif.rst == 0);
			seq_item_port.get_next_item(req);
			
			// Handle on the fly reset
			fork
				begin
					drive(req);
				end
				begin
					wait(vif.rst == 1);
				end
			join_any

			disable fork;

			if(vif.rst == 1)
				reset_pins();
			`uvm_info("DRV",req.convert2string(),"UVM_MED");
			seq_item_port.item_done();
		end
	endtask

	task reset_pins();
		vif.drv_cb.wr_cs <= 1'b0;
		vif.drv_cb.rd_cs <= 1'b0;
		vif.drv_cb.wr_en <= 1'b0;
		vif.drv_cb.rd_en <= 1'b0;
		vif.drv_cb.data_in <= 0;
	endtask

	task drive(fifo_transaction tx);
		@(vif.drv_cb);
		vif.drv_cb.wr_cs <= tx.wr_cs;
		vif.drv_cb.rd_cs <= tx.rd_cs;
		vif.drv_cb.wr_en <= tx.wr_en;
		vif.drv_cb.rd_en <= tx.rd_en;
		vif.drv_cb.data_in <= tx.data_in;
	endtask
endclass
