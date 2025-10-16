package ram_write_read_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;
    import ram_sequence_item_pkg::*;

    class ram_write_read_sequence extends uvm_sequence #(ram_sequence_item);
        `uvm_object_utils(ram_write_read_sequence)
        ram_sequence_item itm;

        function new(string name = "ram_write_read_sequence");
            super.new(name);
        endfunction

        task body();

            `uvm_info("BODY", "entered write only sequence body", UVM_LOW)
            
            repeat(1000) begin
                itm = ram_sequence_item::type_id::create("itm");

                itm.write_c.constraint_mode(0);
                itm.read_c.constraint_mode(0);
                
                start_item(itm);
                assert(itm.randomize());
                finish_item(itm);

            end
        endtask
    endclass
endpackage