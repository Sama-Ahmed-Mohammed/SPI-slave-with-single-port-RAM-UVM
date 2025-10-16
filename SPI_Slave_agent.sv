package SPI_Slave_agent_pkg;
import sequence_item_pkg::*;
import SPI_Slave_sequencer_pkg::*;
import SPI_Slave_driver_pkg::*;
import SPI_Slave_monitor_pkg::*;
import SPI_Slave_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class SPI_Slave_agent extends uvm_agent;
`uvm_component_utils(SPI_Slave_agent);
SPI_Slave_sequencer SPI_Slave_sqr;
SPI_Slave_driver SPI_Slave_drv;
SPI_Slave_monitor SPI_Slave_mon;
SPI_Slave_config SPI_Slave_cfg;

uvm_analysis_port #(sequence_item) agt_ap;

        // constructor for shift reg driver 
    function new(string name = "ALSU_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(SPI_Slave_config):: get (this , "" , "CFG" , SPI_Slave_cfg))begin
            `uvm_fatal("build_phase" , "Unable to get configuration object");
        end 
        SPI_Slave_sqr = SPI_Slave_sequencer::type_id::create("SPI_Slave_sqr" , this);
        SPI_Slave_drv = SPI_Slave_driver::type_id::create("SPI_Slave_drv" , this); 
        SPI_Slave_mon = SPI_Slave_monitor::type_id::create("SPI_Slave_mon" , this); 
        agt_ap = new("agt_ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        SPI_Slave_drv.SPI_Slave_vif = SPI_Slave_cfg.SPI_Slave_vif;
        SPI_Slave_mon.SPI_Slave_vif = SPI_Slave_cfg.SPI_Slave_vif;
        SPI_Slave_drv.seq_item_port.connect(SPI_Slave_sqr.seq_item_export); 
        SPI_Slave_mon.mon_ap.connect(agt_ap);
    endfunction
    endclass
endpackage 