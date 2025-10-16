package SPI_Slave_driver_pkg;
import sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class SPI_Slave_driver extends uvm_driver #(sequence_item);
`uvm_component_utils(SPI_Slave_driver);

virtual SPI_Slave_if SPI_Slave_vif;
sequence_item stim_seq_item;


// constructor for shift reg driver 
function new(string name = "SPI_Slave_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        stim_seq_item = sequence_item::type_id::create("stim_seq_item");
        seq_item_port.get_next_item(stim_seq_item);
        SPI_Slave_vif.rst_n = stim_seq_item.rst_n;
        SPI_Slave_vif.MOSI = stim_seq_item.MOSI;
        SPI_Slave_vif.SS_n = stim_seq_item.SS_n; 
        SPI_Slave_vif.tx_valid = stim_seq_item.tx_valid;
        SPI_Slave_vif.tx_data = stim_seq_item.tx_data;
        @(negedge SPI_Slave_vif.clk);
        seq_item_port.item_done();
        `uvm_info("run_phase" , stim_seq_item.convert2string_stimulus(), UVM_HIGH)
    end
endtask
endclass
endpackage 