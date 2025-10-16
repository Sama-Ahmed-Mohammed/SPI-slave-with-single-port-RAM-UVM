package ram_scoreboard_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    import ram_sequence_item_pkg::*;

    class ram_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ram_scoreboard)

        uvm_analysis_export#(ram_sequence_item) sb_export;
        uvm_tlm_analysis_fifo#(ram_sequence_item) sb_fifo;
        ram_sequence_item itm;

        int error_count = 0;
        int correct_count = 0;

        function new(string name = "ram_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        //  output ref signals
        logic [ADDR_SIZE-1:0] dout_ref;
        bit tx_valid_ref;
        //
        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                sb_fifo.get(itm);
                ref_model(itm.rst_n, itm.rx_valid, itm.din, itm.clk, dout_ref, tx_valid_ref);

                if ((tx_valid_ref != itm.tx_valid) || dout_ref !== itm.dout) begin
                    `uvm_error("SCOREBOARD", $sformatf("Data mismatch! Expected: %0h, Got: %0h", dout_ref, itm.dout))
                    error_count ++ ;
                    //$stop;
                end
                else correct_count ++;
            end
        endtask

        task automatic ref_model(
            input  bit                  rst_n_ref,
            input  bit                  rx_valid_ref,
            input  logic [ADDR_SIZE+1:0] din_ref,
            input  bit                  clk_ref,
            output logic [ADDR_SIZE-1:0] dout_ref,
            output bit                  tx_valid_ref
        );
            // Internal reference memory and address
            static logic [ADDR_SIZE-1:0] mem_ref [MEM_DEPTH-1:0];
            static logic [ADDR_SIZE-1:0] address_ref;

            if (!rst_n_ref) begin
                dout_ref     = '0;
                tx_valid_ref = 0;
            end
            else begin
                casez({din_ref[ADDR_SIZE+1:ADDR_SIZE], rx_valid_ref})
                    // --- Write address phase
                    3'b001: begin
                        address_ref   = din_ref[ADDR_SIZE-1:0];
                        dout_ref      = '0;
                        tx_valid_ref  = 0;
                    end

                    // --- Write data phase
                    3'b011: begin
                        mem_ref[address_ref] = din_ref[ADDR_SIZE-1:0];
                        dout_ref      = '0;
                        tx_valid_ref  = 0;
                    end

                    // --- Read address phase
                    3'b101: begin
                        address_ref   = din_ref[ADDR_SIZE-1:0];
                        dout_ref      = '0;
                        tx_valid_ref  = 0;
                    end

                    // --- Read data phase
                    3'b11?: begin
                        tx_valid_ref  = 1;
                        dout_ref      = mem_ref[address_ref];
                    end

                    default: begin
                        //dout_ref      = '0;
                        tx_valid_ref  = 0;
                    end
                endcase
            end
        endtask


        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SCOREBOARD", "report_phase", UVM_LOW)
            `uvm_info("SCOREBOARD", $sformatf("correct_count = %0d", correct_count), UVM_LOW)
            `uvm_info("SCOREBOARD", $sformatf("error_count = %0d", error_count), UVM_LOW)
        endfunction
    endclass
endpackage
