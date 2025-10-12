package ram_write_only_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;
    import ram_sequence_item_pkg::*;

    class ram_write_only_sequence extends uvm_sequence #(ram_sequence_item);
        `uvm_object_utils(ram_write_only_sequence)
        ram_sequence_item itm;

        function new(string name = "ram_write_only_sequence");
            super.new(name);
        endfunction

        task body();

            `uvm_info("BODY", "entered write only sequence body", UVM_MEDIUM)
            
            repeat(100) begin
                itm = ram_sequence_item::type_id::create("itm");
                
                start_item(itm);
                assert(itm.randomize());
                finish_item(itm);

            end
        endtask
    endclass
endpackage