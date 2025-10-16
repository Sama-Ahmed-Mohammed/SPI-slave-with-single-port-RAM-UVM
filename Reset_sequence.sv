package WRAP_reset_seq_pkg; 
import uvm_pkg::*; 
`include "uvm_macros.svh" 
 
import WRAP_seq_item_pkg::*; 
import shared_pkg::*; 
 
class WRAP_reset_seq extends uvm_sequence #(WRAP_seq_item) ; 
`uvm_object_utils(WRAP_reset_seq) 
 
WRAP_seq_item seq_item_rst; 
 
function new(string name = "WRAP_reset_seq"); 
super.new(name); 
endfunction 
 
task body ; 
   
seq_item_rst = WRAP_seq_item::type_id::create("seq_item_rst"); 

start_item(seq_item_rst); 

seq_item_rst.rst_n ='b0;
seq_item_rst.SS_n ='b0 ;
seq_item_rst.MOSI ='b0;

finish_item(seq_item_rst); 
 
endtask 
 
endclass 
endpackage 




