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

                // Drive outputs
                drv_if.rst_n    = itm.rst_n;
                drv_if.rx_valid = itm.rx_valid;
                drv_if.din      = itm.din;

                // Wait for clock edge
                @(negedge drv_if.clk);
                `uvm_info("DRIVER", itm.convert2string_stimulus(), UVM_LOW)
                
                seq_item_port.item_done();
            end

        endtask
    endclass
endpackage
