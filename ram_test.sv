
package ram_test_pkg;

  import ram_env_pkg::*;
  import ram_config_obj_pkg::*;
  import ram_write_only_sequence_pkg::*;
  import ram_reset_sequence_pkg::*;

  import shared_pkg::*;

  import uvm_pkg::*;
  `include "uvm_macros.svh"


  class ram_test extends uvm_test;
    `uvm_component_utils(ram_test)

    ram_env env;
    ram_config_obj cfg;
    virtual ram_if ram_vif;

    //sequences here
    ram_reset_sequence rst_seq;
    ram_write_only_sequence w_seq;

    function new(string name = "ram_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction 

    // Build the enviornment in the build phase
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = ram_env::type_id::create("env", this);
      cfg = ram_config_obj::type_id::create("cfg");

      rst_seq = ram_reset_sequence::type_id::create("rst_seq");
      w_seq = ram_write_only_sequence::type_id::create("w_seq");

      if(!uvm_config_db#(virtual ram_if)::get(this, "", "ram_if", cfg.vif))
        `uvm_fatal("TEST", "unable to get the virtual interface");

      uvm_config_db#(ram_config_obj)::set(this, "*", "ram_cfg", cfg);

    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      `uvm_info("TEST", "run_phase: reset sequence starts", UVM_LOW);
      rst_seq.start(env.agt.sqr);

      `uvm_info("TEST", "run_phase: reset sequence ends, main sequence starts", UVM_LOW);
      w_seq.start(env.agt.sqr);

      `uvm_info("TEST", "run_phase:main sequence ended", UVM_LOW);

      phase.drop_objection(this);
    endtask
  endclass
endpackage