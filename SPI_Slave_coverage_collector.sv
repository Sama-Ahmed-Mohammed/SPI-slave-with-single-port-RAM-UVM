package SPI_Slave_coverage_pkg;
import sequence_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class SPI_Slave_coverage extends uvm_component;
`uvm_component_utils(SPI_Slave_coverage);
uvm_analysis_export #(sequence_item) cov_export;
uvm_tlm_analysis_fifo #(sequence_item) cov_fifo;
sequence_item seq_item_cov;

// Coverpoints      
covergroup SPI_Slave_cg;
// coverpoint for rx_data
rx_data_cp:  coverpoint seq_item_cov.rx_data[9:8]{
    bins rx_data_0 = {2'b00};
    bins rx_data_1 = {2'b01};
    bins rx_data_2 = {2'b10};
    bins rx_data_3 = {2'b11};
    bins all_transitions[] = ([0:1] => [0:1]);
  }

  // coverpoint for SS_n
SS_n_cp:  coverpoint seq_item_cov.SS_n{
  bins SS_n_0 = {0};
  bins SS_n_1 = {1};
  bins SS_n_start = (1 => 0 => 0);
  bins SS_n_end = (0 => 0 => 1);
  bins SS_n_normal = (1 => 0[*12] => 1);// Normal Operation
  bins SS_n_READ_DATA = (1 => 0[*22:30] => 1);  // READ_DATA
 }

  // coverpoint for MOSI
MOSI_cp: coverpoint seq_item_cov.MOSI{
    bins MOSI_0 = {0};
    bins MOSI_1 = {1};
    bins Bins_trans1 = (1'b0 => 1'b0 => 1'b0);
    bins Bins_trans2 = (1'b0 => 1'b0 => 1'b1);
    bins Bins_trans3 = (1'b1 => 1'b1 => 1'b0);
    bins Bins_trans4 = (1'b1 => 1'b1 => 1'b1);
  }


// Cross coverage
// Cross between SS_n and MOSI, exclude illegal bins 
cross SS_n_cp, MOSI_cp {
  option.cross_auto_bin_max = 0;
  bins WRITE_cross = binsof(SS_n_cp.SS_n_0) && binsof(MOSI_cp.MOSI_0);
  bins READ_cross = binsof(SS_n_cp.SS_n_0) && binsof(MOSI_cp.MOSI_1);
  bins IDLE_cross = binsof(SS_n_cp.SS_n_1) && (binsof(MOSI_cp.MOSI_1) || binsof(MOSI_cp.MOSI_0));
  ignore_bins exclude1 = binsof(MOSI_cp.Bins_trans1);
  ignore_bins exclude2 = binsof(MOSI_cp.Bins_trans2);
  ignore_bins exclude3 = binsof(MOSI_cp.Bins_trans3);
  ignore_bins exclude4 = binsof(MOSI_cp.Bins_trans4);
  ignore_bins exclude5 = binsof(SS_n_cp.SS_n_normal);
  ignore_bins exclude6 = binsof(SS_n_cp.SS_n_READ_DATA);
  ignore_bins exclude7 = binsof(SS_n_cp.SS_n_end);
}
endgroup

function new(string name = "SPI_Slave_coverage", uvm_component parent = null);
    super.new(name,parent);
    SPI_Slave_cg = new();
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo = new("cov_fifo", this);
endfunction    

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin 
        cov_fifo.get(seq_item_cov);
        SPI_Slave_cg.sample();
    end 
endtask
endclass
endpackage 