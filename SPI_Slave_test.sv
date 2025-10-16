package SPI_Slave_test_pkg;
import SPI_Slave_env_pkg::*;
import SPI_Slave_config_pkg::*;
import SPI_Slave_reset_sequence_pkg::*;
import SPI_Slave_main_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_Slave_test extends uvm_test;
  `uvm_component_utils(SPI_Slave_test)
  
  SPI_Slave_env env;
  SPI_Slave_config SPI_Slave_cfg;
  SPI_Slave_reset_sequence reset_seq;
  SPI_Slave_main_sequence main_seq;
  virtual SPI_Slave_if SPI_Slave_vif;

  function new(string name = "SPI_Slave_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the enviornment in the build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = SPI_Slave_env::type_id::create("env", this);
    SPI_Slave_cfg = SPI_Slave_config::type_id::create("SPI_Slave_cfg");
    main_seq  = SPI_Slave_main_sequence::type_id::create("main_seq");
    reset_seq = SPI_Slave_reset_sequence::type_id::create("reset_seq");
    

    if(!uvm_config_db#(virtual SPI_Slave_if)::get(this, "", "SPI_Slave_if", SPI_Slave_cfg.SPI_Slave_vif))
      `uvm_fatal("build_phase", "Test-unable to get the virtual interface of the SPI_Slave from the uvm_config_db");

    uvm_config_db#(SPI_Slave_config)::set(this, "*", "CFG", SPI_Slave_cfg);
  endfunction


  // Run in the test in the run phase, Open the sequences on the sequencers
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    // reset sequence 
    `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
    reset_seq.start(env.SPI_Slave_agt.SPI_Slave_sqr);
    `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

    // main sequence 
    `uvm_info("run_phase", "Stimulus Generation Started", UVM_LOW);
    main_seq.start(env.SPI_Slave_agt.SPI_Slave_sqr);
    `uvm_info("run_phase", "Stimulus Generation Ended", UVM_LOW);
    phase.drop_objection(this);
  endtask
endclass
endpackage