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
                itm = ram_sequence_item::type_id::create("itm");

                itm.clk = mon_if.clk;
                itm.rst_n = mon_if.cb.rst_n;
                
                itm.rx_valid = mon_if.cb.rx_valid;
                itm.din = mon_if.cb.din;
                itm.tx_valid = mon_if.cb.tx_valid;
                itm.dout = mon_if.cb.dout;

                @(negedge mon_if.cb.clk);

                mon_ap.write(itm);
                `uvm_info("MONITOR", itm.convert2string(), UVM_HIGH)
            end

        endtask
    endclass
endpackage
