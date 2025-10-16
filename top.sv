import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_Slave_test_pkg::*;
import SPI_Slave_monitor_pkg::*;
module top;
  bit clk;
  // Clock generation
  initial begin 
    clk = 0;
    forever 
    #1 clk = ~clk;
  end 

  // Instantiate the interface and DUT and golden model
  SPI_Slave_if SPI_Slave_vif(clk);
  SLAVE dut (SPI_Slave_vif.DUT);
  spi_slave golden_model (SPI_Slave_vif.Golden_Model);
  //bind SLAVE SPI_Slave_sva SPI_Slave_sva_inst(SPI_Slave_vif.DUT);

  // run test using run_test task
  initial begin 
    uvm_config_db#(virtual SPI_Slave_if)::set(null, "*" , "SPI_Slave_if", SPI_Slave_vif);
    run_test("SPI_Slave_test");
  end 
endmodule