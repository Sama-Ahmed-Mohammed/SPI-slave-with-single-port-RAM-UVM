package WRAP_Wr_Rd_seq_pkg; 
import uvm_pkg::*; 
`include "uvm_macros.svh" 
 
import WRAP_seq_item_pkg::*; 
import shared_pkg::*; 
 
class WRAP_Wr_Rd_seq extends uvm_sequence #(WRAP_seq_item) ; 
`uvm_object_utils(WRAP_Wr_Rd_seq) 
 
WRAP_seq_item Wr_Rd_seq_item; 
 
function new(string name = "WRAP_Wr_Rd_seq"); 
super.new(name); 
endfunction 
 
task body ; 
 
repeat(1000)begin    
Wr_Rd_seq_item = WRAP_seq_item::type_id::create("Wr_Rd_seq_item"); 


//activate rd_wr constraint
seq_select = 2 ;

start_item(Wr_Rd_seq_item); 
assert(Wr_Rd_seq_item.randomize()); 

finish_item(Wr_Rd_seq_item); 
 
end 
 
endtask 
 
endclass 
endpackage 