package WRAP_config_obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class WRAP_config_obj extends uvm_object;

`uvm_object_utils(WRAP_config_obj)

//declare virtual interface
virtual WRAP_if wrap_config_vif ; 

function new(string name = "WRAP_config_obj");
 super.new(name);
endfunction


endclass
endpackage: WRAP_config_obj_pkg
