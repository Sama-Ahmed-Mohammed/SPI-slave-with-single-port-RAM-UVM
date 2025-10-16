package WRAP_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import WRAP_agent_pkg::*;
import WRAP_coverage_pkg::*;
import WRAP_scoreboard_pkg::*;

class WRAP_env extends uvm_env;
`uvm_component_utils(WRAP_env)

//objects inside an environment
WRAP_agent WRAP_agt ;
WRAP_scoreboard  WRAP_sb ;
WRAP_coverage WRAP_cov ;

function new(string name = "WRAP_env", uvm_component parent =null);
super.new(name , parent);
endfunction

//build phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
WRAP_agt = WRAP_agent::type_id::create("WRAP_agt",this);
WRAP_sb = WRAP_scoreboard::type_id::create("WRAP_sb",this);
WRAP_cov = WRAP_coverage::type_id::create("WRAP_cov",this);
endfunction: build_phase 

//connect phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
WRAP_agt.agt_ap.connect(WRAP_sb.sb_export);
WRAP_agt.agt_ap.connect(WRAP_cov.cov_export);
endfunction

endclass
endpackage: WRAP_env_pkg
