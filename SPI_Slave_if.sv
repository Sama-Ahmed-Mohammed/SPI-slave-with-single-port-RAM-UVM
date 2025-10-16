interface SPI_Slave_if (clk);
  input clk;
  logic MOSI, rst_n, SS_n, tx_valid;
  logic [7:0] tx_data;
  logic [9:0] rx_data, rx_data_ref;
  logic rx_valid, MISO, rx_valid_ref, MISO_ref;

  modport DUT(input clk, MOSI, rst_n, SS_n, tx_valid, tx_data, output rx_data, rx_valid, MISO);
  modport monitor(input MOSI, rst_n, SS_n, tx_valid, tx_data, rx_data, rx_valid, MISO);
  modport Golden_Model (input MOSI, SS_n, clk, rst_n, tx_data, tx_valid, output rx_data_ref, rx_valid_ref, MISO_ref);
endinterface 