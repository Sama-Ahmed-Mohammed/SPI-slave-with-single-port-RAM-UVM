package WRAP_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import WRAP_seq_item_pkg::*;
import shared_pkg::*;

class WRAP_monitor extends uvm_monitor ;
`uvm_component_utils(WRAP_monitor)

//1-declare virtual if and config obj
virtual WRAP_if WRAP_mon_vif ;
WRAP_seq_item rsp_seq_item ;

uvm_analysis_port #(WRAP_seq_item) mon_ap ;

function new(string name = "WRAP_monitor", uvm_component parent =null);
super.new(name , parent);
endfunction

//2-Build phase:
function void build_phase(uvm_phase phase);
super.build_phase(phase);
mon_ap=new("mon_ap",this);
endfunction: build_phase 

//3-Run phase
task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin
    rsp_seq_item = WRAP_seq_item::type_id::create("rsp_seq_item");

    @(negedge WRAP_mon_vif.clk);
    rsp_seq_item.SS_n = WRAP_mon_vif.SS_n; 
    rsp_seq_item.rst_n = WRAP_mon_vif.rst_n;
    rsp_seq_item.MOSI = WRAP_mon_vif.MOSI ; 

    rsp_seq_item.MISO = WRAP_mon_vif.MISO ;
    rsp_seq_item.MISO_ref = WRAP_mon_vif.MISO_ref ;

    mon_ap.write(rsp_seq_item);//broadcast the seq item 
    `uvm_info("run phase", rsp_seq_item.convert2string_stimulus(),UVM_HIGH);
    
end
endtask



endclass

endpackage