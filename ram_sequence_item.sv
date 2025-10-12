package ram_sequence_item_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import shared_pkg::*;

  class ram_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(ram_sequence_item)

    // ===== Signals =====
    logic clk;
    rand logic rst_n;
    rand logic rx_valid;
    rand logic [ADDR_SIZE+1:0] din;

    logic tx_valid;
    logic [ADDR_SIZE-1:0] dout;

    // Track previous operation type
    static bit [1:0] prev_op = 2'b00; 
    rand bit [1:0] curr_op;

    function new(string name = "ram_sequence_item");
      super.new(name);
    endfunction

    // ===== Constraints =====
    constraint rst_c {
      rst_n dist {0 := 10, 1 := 90};
    }

    constraint rx_valid_c {
      rx_valid dist {0 := 10, 1 := 90};
    }

    // Operation must match din encoding
    constraint op_encoding_c {
      din[ADDR_SIZE+1:ADDR_SIZE] == curr_op;
    }

    // Randomize the operation according to previous one
    constraint operation_seq_c {
      // Write Address (00)
      if (prev_op == 2'b00)
        curr_op inside {2'b00, 2'b01};

      // Write Data (01)
      else if (prev_op == 2'b01)
        curr_op dist {2'b10 := 60, 2'b00 := 40};

      // Read Address (10)
      else if (prev_op == 2'b10)
        curr_op == 2'b11;

      // Read Data (11)
      else if (prev_op == 2'b11)
        curr_op dist {2'b00 := 60, 2'b10 := 40};
    }

    // ===== Randomization Hooks =====
    function void pre_randomize();
      // Could add logic to force reset or start sequence here if needed
    endfunction

    function void post_randomize();
      // Update prev_op for next item
      prev_op = curr_op;
    endfunction

    // ===== Debug Print Functions =====
    function string convert2string();
      return $sformatf("%s rst_n=%0b rx_valid=%0b din=%h (op=%b)",
                        super.convert2string(),
                        rst_n, rx_valid, din, curr_op);
    endfunction

    function string convert2string_stimulus();
      return $sformatf("rst_n=%0b rx_valid=%0b din=%h (op=%b)",
                        rst_n, rx_valid, din, curr_op);
    endfunction

  endclass
endpackage
