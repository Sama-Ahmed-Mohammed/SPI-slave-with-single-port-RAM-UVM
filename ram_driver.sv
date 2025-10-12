package ram_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import ram_sequence_item_pkg::*;
    import shared_pkg::*;

    class ram_driver extends uvm_driver #(ram_sequence_item);
        `uvm_component_utils(ram_driver)

        virtual ram_if.DRIVER drv_if;
        ram_sequence_item itm;

        function new(string name = "driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            `uvm_info("DRIVER", "Entered run_phase", UVM_LOW);

            forever begin
                itm = ram_sequence_item::type_id::create("itm");

                seq_item_port.get_next_item(itm);

                drv_if.cb.clk = itm.clk;
                drv_if.cb.rst_n = itm.rst_n;

                drv_if.cb.rx_valid = itm.rx_valid;
                drv_if.cb.din = itm.din;

                drv_if.cb.tx_valid = itm.tx_valid;
                drv_if.cb.dout = itm.dout;
                
                @(negedge drv_if.clk);

                seq_item_port.item_done();
                
                `uvm_info("DRIVER", itm.convert2string_stimulus(), UVM_HIGH)
            end

        endtask
    endclass
endpackage
