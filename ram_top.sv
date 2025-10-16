
import uvm_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"
`include "ram_assertions.sv"
import ram_test_pkg::*;

module top();
  bit clk;

  initial begin 
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Instantiate the interface and DUT
  ram_if ram_vif(clk);

  // DUT instantiation
  RAM u_dut (
    .clk(ram_vif.DUT.clk),
    .rst_n(ram_vif.DUT.rst_n),
    .rx_valid(ram_vif.DUT.rx_valid),
    .din(ram_vif.DUT.din),
    .tx_valid(ram_vif.DUT.tx_valid),
    .dout(ram_vif.DUT.dout)
  );

  // === Bind assertions to the interface ===
  bind RAM ram_assertions bind_ram_assertions (
    .clk(ram_vif.DUT.clk),
    .rst_n(ram_vif.DUT.rst_n),
    .rx_valid(ram_vif.DUT.rx_valid),
    .din(ram_vif.DUT.din),
    .tx_valid(ram_vif.DUT.tx_valid),
    .dout(ram_vif.DUT.dout)
    );

  // run test using run_test task
  initial begin
    uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","ram_if",ram_vif);
    run_test("ram_test");
  end
endmodule