import uvm_pkg::*;
import shared_pkg::*;

module ram_assertions (din,clk,rst_n,rx_valid,dout,tx_valid);

  // Local aliases for readability
  input logic clk, rst_n, rx_valid, tx_valid;
  input logic [ADDR_SIZE + 1 : 0] din;
  input logic [ADDR_SIZE - 1 : 0] dout;

  // Constants for operation decoding
  // Write Addr = 00, Write Data = 01, Read Addr = 10, Read Data = 11
  wire [1:0] op_type = din[ADDR_SIZE+1 : ADDR_SIZE];

  // ============================================================
  // Reset Behavior Assertion
  // ============================================================
  // Whenever reset is asserted (rst_n == 0), tx_valid and dout must be low

  property p_reset_outputs_low;
    @(posedge clk)
      !rst_n |=> (tx_valid == 0 && dout == '0);
  endproperty

  a_reset_outputs_low: assert property (p_reset_outputs_low)
    else $error("ASSERT", "During reset, tx_valid or dout not low!");

  c_reset_outputs_low: cover property (p_reset_outputs_low);

  // ============================================================
  // During Address/Data Input Phases → tx_valid must be 0
  // ============================================================
  // During write address, write data, and read address phases, tx_valid must remain deasserted

  property p_tx_valid_during_input;
    @(posedge clk)
      (op_type inside {2'b00, 2'b01, 2'b10}) |=> !tx_valid;
  endproperty

  a_tx_valid_during_input: assert property (p_tx_valid_during_input)
    else $error("ASSERT", "tx_valid asserted during input phase!");

  c_tx_valid_during_input: cover property (p_tx_valid_during_input);

  // ============================================================
  // After Read Data (2'b11) → tx_valid should rise for 1 cycle then fall
  // ============================================================
  // When read data occurs, tx_valid must go high, and within one cycle after high, it must fall

  property p_tx_valid_pulse_after_read;
    @(posedge clk)
      (op_type == 2'b11 && rx_valid) |-> ##1 tx_valid ##1 !tx_valid;
  endproperty

  a_tx_valid_pulse_after_read: assert property (p_tx_valid_pulse_after_read)
    else $error("ASSERT", "tx_valid did not behave correctly after read data!");

  c_tx_valid_pulse_after_read: cover property (p_tx_valid_pulse_after_read);

  // ============================================================
  // Every Write Address must be eventually followed by Write Data
  // ============================================================

  property p_write_addr_followed_by_write_data;
    @(posedge clk)
      (op_type == 2'b00 && rx_valid) |=> ##[1:$] (op_type == 2'b01);
  endproperty

  a_write_addr_followed_by_write_data: assert property (p_write_addr_followed_by_write_data)
    else $error("ASSERT", "Write Address not followed by Write Data!");

  c_write_addr_followed_by_write_data: cover property (p_write_addr_followed_by_write_data);

  // ============================================================
  // Every Read Address must be eventually followed by Read Data
  // ============================================================

  property p_read_addr_followed_by_read_data;
    @(posedge clk)
      (op_type == 2'b10 && rx_valid) |=> ##[1:$] (op_type == 2'b11);
  endproperty

  a_read_addr_followed_by_read_data: assert property (p_read_addr_followed_by_read_data)
    else $error("ASSERT", "Read Address not followed by Read Data!");

  c_read_addr_followed_by_read_data: cover property (p_read_addr_followed_by_read_data);


endmodule
