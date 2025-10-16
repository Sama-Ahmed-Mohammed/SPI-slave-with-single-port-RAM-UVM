package WRAP_Wr_only_seq_pkg; 
import uvm_pkg::*; 
`include "uvm_macros.svh" 
 
import WRAP_seq_item_pkg::*; 
import shared_pkg::*; 
 
class WRAP_Wr_only_seq extends uvm_sequence #(WRAP_seq_item) ; 
`uvm_object_utils(WRAP_Wr_only_seq) 
 
WRAP_seq_item seq_item_wr; 
 
function new(string name = "WRAP_Wr_only_seq"); 
super.new(name); 
endfunction 
 
task body ; 
 
repeat(1000)begin    
seq_item_wr = WRAP_seq_item::type_id::create("seq_item_wr"); 

//activate wr_only constraint
seq_select = 0 ;

start_item(seq_item_wr); 
assert(seq_item_wr.randomize()); 


finish_item(seq_item_wr); 
 
end 
 
endtask 
 
endclass 
endpackage 