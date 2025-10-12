package ram_config_obj_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;
    
    class ram_config_obj extends uvm_object;
        `uvm_object_utils(ram_config_obj)
        
        virtual ram_if vif;
        uvm_active_passive_enum is_active;

        function new(string name = "obj");
            super.new(name);
        endfunction
    endclass

endpackage