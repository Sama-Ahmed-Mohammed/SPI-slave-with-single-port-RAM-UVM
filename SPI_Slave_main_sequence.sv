package SPI_Slave_main_sequence_pkg;
import sequence_item_pkg::*;
import uvm_pkg::*;
  `include "uvm_macros.svh"

class SPI_Slave_main_sequence extends uvm_sequence #(sequence_item);
`uvm_object_utils(SPI_Slave_main_sequence);
sequence_item seq_item;

// constructor for the reset sequence
function new (string name = "SPI_Slave_main_sequence");
    super.new(name);
endfunction

// task 
task body;
    repeat(10000)begin
        seq_item = sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
    end
endtask 
endclass
endpackage