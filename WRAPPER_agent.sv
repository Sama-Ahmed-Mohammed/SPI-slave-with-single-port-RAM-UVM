package WRAP_agent_pkg;
//Static agent 

import uvm_pkg::*;
`include "uvm_macros.svh"
import WRAP_seq_item_pkg::*;
import WRAP_sequencer_pkg::*;
import WRAP_driver_pkg::*;
import WRAP_monitor_pkg::*;
import WRAP_config_obj_pkg::*;

class WRAP_agent extends uvm_agent ;
`uvm_component_utils(WRAP_agent)

//Objects:
WRAP_driver WRAP_drv;
WRAP_monitor WRAP_mon;
WRAP_sequencer WRAP_sqr;
WRAP_config_obj WRAP_cfg;
//analysis port:
uvm_analysis_port #(WRAP_seq_item) agt_ap ;

//func new:
function new(string name = " WRAP_agent", uvm_component parent =null);
super.new(name , parent);
endfunction

//build phase:
function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(WRAP_config_obj)::get(this, "","CFG", WRAP_cfg))begin
 `uvm_fatal("build phase", "Unable to get the configuration object");
end 

WRAP_drv = WRAP_driver::type_id::create("WRAP_drv",this);
WRAP_mon = WRAP_monitor::type_id::create("WRAP_mon",this);
WRAP_sqr = WRAP_sequencer::type_id::create("WRAP_sqr",this);
agt_ap = new("agt_ap",this);

endfunction: build_phase 

//connect phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);

WRAP_drv.wrap_driver_vif =  WRAP_cfg.wrap_config_vif ;
WRAP_mon.WRAP_mon_vif =  WRAP_cfg.wrap_config_vif ;

WRAP_drv.seq_item_port.connect(WRAP_sqr.seq_item_export);
WRAP_mon.mon_ap.connect(agt_ap);

endfunction
endclass

endpackage