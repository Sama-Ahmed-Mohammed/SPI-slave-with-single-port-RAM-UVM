package WRAP_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import WRAP_seq_item_pkg::*;
import shared_pkg::*;

class WRAP_driver extends uvm_driver#(WRAP_seq_item) ;
`uvm_component_utils(WRAP_driver)

//1-declare virtual if and seq item obj
virtual WRAP_if wrap_driver_vif ;
WRAP_seq_item stim_seq_item ;

function new(string name = "WRAP_driver", uvm_component parent =null);
super.new(name , parent);
endfunction

//2-Run phase:
task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin
    stim_seq_item = WRAP_seq_item::type_id::create("stim_seq_item");
    seq_item_port.get_next_item(stim_seq_item);
    wrap_driver_vif.rst_n= stim_seq_item.rst_n ;
    wrap_driver_vif.SS_n = stim_seq_item.SS_n; 
    wrap_driver_vif.MOSI= stim_seq_item.MOSI ; 

    @(negedge wrap_driver_vif.clk)
    seq_item_port.item_done();
    `uvm_info("run phase", stim_seq_item.convert2string_stimulus(),UVM_HIGH); 
   end
endtask

endclass
endpackage 




/*package WRAP_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import WRAP_seq_item_pkg::*;
import shared_pkg::*;

class WRAP_driver extends uvm_driver#(WRAP_seq_item) ;
`uvm_component_utils(WRAP_driver)

//1-declare virtual if and seq item obj
virtual WRAP_if wrap_driver_vif ;
WRAP_seq_item stim_seq_item ;

function new(string name = "WRAP_driver", uvm_component parent =null);
super.new(name , parent);
endfunction

//2-Run phase:
task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin
    stim_seq_item = WRAP_seq_item::type_id::create("stim_seq_item");
    seq_item_port.get_next_item(stim_seq_item);

    wrap_driver_vif.rst_n= stim_seq_item.rst_n ;
    wrap_driver_vif.SS_n = stim_seq_item.SS_n; 

    for (int i=10 ; i>=0 ; i--)begin
    @(negedge wrap_driver_vif.clk)
   
    stim_seq_item.MOSI =stim_seq_item.MOSI_bits[i] ;
    wrap_driver_vif.MOSI= stim_seq_item.MOSI ; 

    end
    @(negedge wrap_driver_vif.clk)

    seq_item_port.item_done();
    `uvm_info("run phase", stim_seq_item.convert2string_stimulus(),UVM_HIGH); 
   end
endtask

endclass
endpackage */