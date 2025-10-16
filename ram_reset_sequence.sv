package ram_reset_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;
    import ram_sequence_item_pkg::*;

    class ram_reset_sequence extends uvm_sequence #(ram_sequence_item);
        `uvm_object_utils(ram_reset_sequence)
        ram_sequence_item itm;

        function new(string name = "ram_reset_sequence");
            super.new(name);
        endfunction

        task body();
            `uvm_info("BODY", "entered reset sequence body", UVM_MEDIUM)
                itm = ram_sequence_item::type_id::create("itm");

                start_item(itm);
                
                itm.rst_n = 0;
                itm.din = 0;
                itm.rx_valid =0;

                #5;

                itm.rst_n = 1;

                finish_item(itm);


        endtask
    endclass
endpackage


