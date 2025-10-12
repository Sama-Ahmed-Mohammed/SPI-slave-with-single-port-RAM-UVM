package ram_coverage_collector_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import ram_sequence_item_pkg::*;
    import shared_pkg::*;

    class ram_coverage_collector extends uvm_component;
        `uvm_component_utils(ram_coverage_collector)

        uvm_analysis_export#(ram_sequence_item) cov_export;
        uvm_tlm_analysis_fifo#(ram_sequence_item) cov_fifo;
        ram_sequence_item itm;

        logic [1:0] op_type = itm.din[ADDR_SIZE+1:ADDR_SIZE];

        //covergroups
        covergroup  cvr_grp @(posedge itm.clk);

            // Check that din[9:8] takes all 4 possible values
            cp_op_type: coverpoint op_type {
            bins write_addr = {2'b00};
            bins write_data = {2'b01};
            bins read_addr  = {2'b10};
            bins read_data  = {2'b11};
            }

            // Check write data after write address
            seq_write_after_write_addr: coverpoint op_type {
            bins wa_wd_seq = (2'b00 => 2'b01);
            }

            // Check read data after read address
            seq_read_after_read_addr: coverpoint op_type {
            bins ra_rd_seq = (2'b10 => 2'b11);
            }

            // Check the full ordered sequence:
            // write address → write data → read address → read data
            seq_full_order: coverpoint op_type {
            bins full_sequence = (2'b00 => 2'b01 => 2'b10 => 2'b11);
            }

        endgroup

  // ============================================================
  // CROSS COVERAGE
  // ============================================================

    covergroup cg_cross @(posedge itm.clk);

        // Cross between op_type bins and rx_valid (when rx_valid=1)
        cp_op_type: coverpoint op_type {
        bins write_addr = {2'b00};
        bins write_data = {2'b01};
        bins read_addr  = {2'b10};
        bins read_data  = {2'b11};
        }

        cp_rx_valid: coverpoint itm.rx_valid {
        bins low = {0};
        bins high = {1};
        }

        cross_op_rx: cross cp_op_type, cp_rx_valid {
        ignore_bins rx_low = binsof(cp_rx_valid.low); // only care when rx_valid=1
        }

        // Cross between din[9:8] == read data (2’b11) and tx_valid high
        cp_read_data_op: coverpoint (op_type == 2'b11);
        cp_tx_valid: coverpoint itm.tx_valid;

        cross_read_txvalid: cross cp_read_data_op, cp_tx_valid {
        bins readdata_txvalid_high = binsof(cp_read_data_op) intersect {1} &&
                                    binsof(cp_tx_valid) intersect {1};
        }

    endgroup

        function new(string name = "ram_coverage_collector", uvm_component parent = null);
            super.new(name, parent);
            cvr_grp = new();
            cg_cross = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            cov_fifo.get(itm);
            cvr_grp.sample();
        endtask

    endclass
endpackage

