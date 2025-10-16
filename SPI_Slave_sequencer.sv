package SPI_Slave_sequencer_pkg;
import sequence_item_pkg::*;
import uvm_pkg::*;
  `include "uvm_macros.svh"

class SPI_Slave_sequencer extends uvm_sequencer #(sequence_item);
`uvm_component_utils(SPI_Slave_sequencer);

// constructor of the sequencer
function new (string name = "SPI_Slave_sequencer" , uvm_component parent = null);
    super.new(name , parent);
endfunction
endclass
endpackage    
