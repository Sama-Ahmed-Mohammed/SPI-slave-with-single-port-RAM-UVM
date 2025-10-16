import shared_pkg::*;

interface ram_if (input clk);

  logic rst_n;
  logic rx_valid;
  logic [ADDR_SIZE + 1 : 0] din;
  logic tx_valid;
  logic [ADDR_SIZE - 1 : 0] dout;

  // Modports
  modport DUT (
    input  clk, rst_n, rx_valid, din,
    output tx_valid, dout
  );

  modport DRIVER (
    input  clk, tx_valid, dout,
    output rst_n, rx_valid, din
  );

  modport MONITOR (
    input  clk, rst_n, rx_valid, din, tx_valid, dout
  );

endinterface
