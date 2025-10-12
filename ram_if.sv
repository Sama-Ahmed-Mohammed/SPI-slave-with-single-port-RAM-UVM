import shared_pkg::*;
interface ram_if (clk);
  input clk;

  logic rst_n;
  logic rx_valid;
  logic [ADDR_SIZE + 1 : 0] din;

  logic tx_valid;
  logic [ADDR_SIZE - 1 : 0] dout;

  //Used clocking block for synchronous time control :)

  clocking cb @(posedge clk);
    output #0ns rst_n, rx_valid, din;
    input #1step tx_valid, dout;
  endclocking

  modport DUT(
    input clk, rst_n, rx_valid, din,
    output tx_valid, dout
  );

  modport DRIVER(
    input clk,
    clocking cb
  );

  modport MONITOR(
    input clk,
    clocking cb
  );

endinterface