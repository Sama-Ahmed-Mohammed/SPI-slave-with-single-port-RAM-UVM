package ram_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import ram_sequence_item_pkg::*;
    import shared_pkg::*;

    class ram_monitor extends uvm_monitor;
        `uvm_component_utils(ram_monitor)

        ram_sequence_item itm;
        uvm_analysis_port#(ram_sequence_item) mon_ap;
        virtual ram_if.MONITOR mon_if;

        function new(string name = "monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                @(posedge mon_if.clk);
                itm = ram_sequence_item::type_id::create("itm");
                itm.rst_n    = mon_if.rst_n;
                itm.rx_valid = mon_if.rx_valid;
                itm.din      = mon_if.din;
                itm.tx_valid = mon_if.tx_valid;
                itm.dout     = mon_if.dout;
                `uvm_info("MONITOR", itm.convert2string(), UVM_LOW)

                mon_ap.write(itm);
            end
        endtask
    endclass
endpackage
