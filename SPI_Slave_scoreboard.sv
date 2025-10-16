package SPI_Slave_scoreboard_pkg;
  import sequence_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class SPI_Slave_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(SPI_Slave_scoreboard);

    uvm_analysis_export #(sequence_item) sb_export;
    uvm_tlm_analysis_fifo #(sequence_item) sb_fifo;
    sequence_item seq_item_sb;

    int error_count = 0;
    int correct_count = 0;

    // constructor
    function new(string name = "SPI_Slave_scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    // build phase
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sb_export = new("sb_export", this);
      sb_fifo   = new("sb_fifo", this);
    endfunction

    // connect phase
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      sb_export.connect(sb_fifo.analysis_export);
    endfunction
  
  // run phase
task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    sb_fifo.get(seq_item_sb);    
    if (seq_item_sb.rx_data !== seq_item_sb.rx_data_ref) begin
    `uvm_error("run_phase",
    $sformatf(
      "Comparison FAILED!\n, Transaction received by the DUT: %s
      While the reference data: Ref rx_data  = 0b%10b, Ref rx_valid = 0b%0b, Ref MISO = 0b%0b \n",
    seq_item_sb.convert2string(), seq_item_sb.rx_data_ref, seq_item_sb.rx_valid_ref, seq_item_sb.MISO_ref));
    error_count++;
    end else begin
  `uvm_info("run_phase",
    $sformatf(
      "Comparison Succeeded\n, Transaction received by the DUT: %s
      While the reference data: Ref rx_data  = 0b%10b , Ref rx_valid = 0b%0b, Ref MISO = 0b%0b \n",
    seq_item_sb.convert2string(), seq_item_sb.rx_data_ref, seq_item_sb.rx_valid_ref, seq_item_sb.MISO_ref),
    UVM_HIGH
  );
  correct_count++;
  end
  end 
endtask

    // report phase
    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("report phase", $sformatf("Total successful transactions: %0d", correct_count), UVM_MEDIUM);
      `uvm_info("report phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM);
    endfunction

  endclass
endpackage
