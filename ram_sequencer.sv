package ram_sequencer_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import shared_pkg::*;
    
    import ram_sequence_item_pkg::*;

    class ram_sequencer extends uvm_sequencer #(ram_sequence_item);
        `uvm_component_utils(ram_sequencer)

        function new(string name = "ram_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction

    endclass
endpackage
