package SPI_Slave_reset_sequence_pkg;
import sequence_item_pkg::*;
import uvm_pkg::*;
  `include "uvm_macros.svh"

class SPI_Slave_reset_sequence extends uvm_sequence #(sequence_item);
`uvm_object_utils(SPI_Slave_reset_sequence);
sequence_item seq_item;

// constructor for the reset sequence
function new (string name = "SPI_Slave_reset_sequence");
    super.new(name);
endfunction

// task 
task body;
    seq_item = sequence_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n = 0 ;
    seq_item.MOSI = 0;
    seq_item.SS_n = 0;
    seq_item.tx_valid = 0;
    seq_item.tx_data = 0;
    finish_item(seq_item);
endtask 
endclass
endpackage


