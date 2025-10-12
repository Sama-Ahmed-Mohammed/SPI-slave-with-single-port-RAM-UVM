package ram_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import ram_driver_pkg::*;
    import ram_monitor_pkg::*;
    import ram_sequencer_pkg::*;
    import ram_sequence_item_pkg::*;
    import ram_config_obj_pkg::*;
    import shared_pkg::*;

    class ram_agent extends uvm_agent;
        `uvm_component_utils(ram_agent)

        //components
        ram_monitor mon;
        ram_driver drv;
        ram_sequencer sqr;

        //config obj
        ram_config_obj obj;

        //analysis port
        uvm_analysis_port#(ram_sequence_item) agt_ap;

        function new(string name = "ram_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            obj = ram_config_obj::type_id::create("obj");

            if(!uvm_config_db#(ram_config_obj)::get(this, "","ram_cfg", obj))
                `uvm_fatal("AGENT", "Can't get config obj");
            
            if(obj.is_active == UVM_ACTIVE) begin
                drv = ram_driver::type_id::create("drv", this);
                sqr = ram_sequencer::type_id::create("sqr", this);
            end

            mon = ram_monitor::type_id::create("mon", this);
            agt_ap = new("agt_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            mon.mon_if = obj.vif;
            
            if(obj.is_active == UVM_ACTIVE) begin
                drv.seq_item_port.connect(sqr.seq_item_export);
                drv.drv_if = obj.vif;
            end
            
            //analsysis port connection
            mon.mon_ap.connect(agt_ap);
        endfunction
    endclass
endpackage