package WRAP_Rd_only_seq_pkg; 
import uvm_pkg::*; 
`include "uvm_macros.svh" 
 
import WRAP_seq_item_pkg::*; 
import shared_pkg::*; 
 
class WRAP_Rd_only_seq extends uvm_sequence #(WRAP_seq_item) ; 
`uvm_object_utils(WRAP_Rd_only_seq) 
 
WRAP_seq_item seq_item_rd; 
 
function new(string name = "WRAP_Rd_only_seq"); 
super.new(name); 
endfunction 
 
task body ; 
 
repeat(1000)begin    
seq_item_rd = WRAP_seq_item::type_id::create("seq_item_rd"); 

//activate rd_only constraint
seq_select = 1 ;
// seq_item_rd.WR_only.constraint_mode(0);
// seq_item_rd.Rd_only.constraint_mode(1);
// seq_item_rd.Rd_or_Wr.constraint_mode(0);

start_item(seq_item_rd); 
assert(seq_item_rd.randomize()); 

 

finish_item(seq_item_rd); 
 
end 
 
endtask 
 
endclass 
endpackage 