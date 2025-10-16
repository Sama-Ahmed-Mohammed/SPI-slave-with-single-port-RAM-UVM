package SPI_Slave_env_pkg;
import SPI_Slave_agent_pkg::*;
import SPI_Slave_scoreboard_pkg::*;
import SPI_Slave_coverage_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_Slave_env extends uvm_env;
  `uvm_component_utils(SPI_Slave_env)

  SPI_Slave_agent SPI_Slave_agt;
  SPI_Slave_scoreboard SPI_Slave_sb;
  SPI_Slave_coverage SPI_Slave_cov;

  function new(string name = "SPI_Slave_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    SPI_Slave_agt = SPI_Slave_agent::type_id::create("SPI_Slave_agt", this);
    SPI_Slave_sb = SPI_Slave_scoreboard::type_id::create("SPI_Slave_sb", this);
    SPI_Slave_cov = SPI_Slave_coverage::type_id::create("SPI_Slave_cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
  SPI_Slave_agt.agt_ap.connect(SPI_Slave_sb.sb_export);
  SPI_Slave_agt.agt_ap.connect(SPI_Slave_cov.cov_export);
  endfunction
endclass
endpackage