package WRAP_sequencer_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import WRAP_seq_item_pkg::*;

class WRAP_sequencer extends uvm_sequencer#(WRAP_seq_item) ;
`uvm_component_utils(WRAP_sequencer)

function new(string name = "WRAP_sequencer", uvm_component parent =null);
super.new(name , parent);
endfunction

endclass

endpackage