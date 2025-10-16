package WRAP_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import WRAP_seq_item_pkg::*;
import shared_pkg::*;

class WRAP_scoreboard extends uvm_scoreboard ;
`uvm_component_utils(WRAP_scoreboard)
uvm_analysis_export #(WRAP_seq_item) sb_export ;
uvm_tlm_analysis_fifo #(WRAP_seq_item) sb_fifo ;
WRAP_seq_item seq_item_sb ;

bit MISO_ref;

int error_count =0 ;
int correct_count =0 ;


function new(string name = "WRAP_scoreboard", uvm_component parent =null);
super.new(name , parent);
endfunction

//1-Build phase:
function void build_phase(uvm_phase phase);
super.build_phase(phase);
sb_export = new("sb_export",this) ;
sb_fifo = new("sb_fifo",this) ;
endfunction: build_phase 

//2-connect phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);
endfunction

//3-run phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
   sb_fifo.get(seq_item_sb);

   if (seq_item_sb.MISO === seq_item_sb.MISO_ref ) begin
      correct_count++;
      `uvm_info("run phase", $sformatf("CORRECT OPERATION: out= %s ", seq_item_sb.convert2string()),UVM_HIGH);
    end 
    else begin
      error_count++;
      `uvm_error("run phase", $sformatf("Comparison FAILED. Transaction received by the DUT:%S while the refrence out :0b%0b ", seq_item_sb.convert2string(), MISO_ref ));
    end
    
end
endtask

function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info("report phase", $sformatf("Total successful transactions: %d ", correct_count),UVM_MEDIUM);
`uvm_info("report phase", $sformatf("Total failed transactions: %d ", error_count),UVM_MEDIUM);
endfunction

endclass
endpackage
