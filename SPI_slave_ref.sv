module spi_slave (SPI_Slave_if vif);
parameter ADDR_SIZE = 8;
localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

    (*fsm_encoding = "one_hot" *)

//============  Internal signals    ===========================
    reg [2:0] cs;
    reg [2:0] ns;
    reg read_addr_or_data; //if 0 read address, if 1 read data

//==============================================================
//                  Next state logic
//==============================================================
    always@(cs, vif.SS_n, vif.MOSI) begin
        case(cs)
            IDLE        : begin
                if(vif.SS_n) ns <= IDLE;

                else ns <= CHK_CMD;
            end

            CHK_CMD     : begin
                if(!vif.SS_n && !vif.MOSI) ns <= WRITE;

                else if(!vif.SS_n && vif.MOSI)begin 
                    if(!read_addr_or_data) begin
                        ns <= READ_ADD;
                    end

                    else begin
                        ns <= READ_DATA;
                    end
                end

                else ns <= IDLE;
            end

            WRITE       : begin
                if(!vif.SS_n) ns <= WRITE; 
                else ns<= IDLE;
            end

            READ_ADD    : begin
                if(!vif.SS_n) ns <= READ_ADD; 
                else ns <= IDLE;
            end

            READ_DATA   : begin
                if(!vif.SS_n) ns <= READ_DATA; 
                else ns <= IDLE;
            end

            default     : ns <= IDLE;
        endcase
    end

//==============================================================
//                  State memory
//==============================================================
    always@(posedge vif.clk)begin
        if(!vif.rst_n) cs <= IDLE;
        else cs <= ns;
    end
//=============================================================
//                  Output logic: 
//=============================================================
        
    reg [$clog2(ADDR_SIZE+2) - 1: 0] counter;
    reg [(ADDR_SIZE+2) - 1 : 0] temp; //temp register to parallelize data in

    always@(posedge vif.clk) begin
        if(!vif.rst_n ) begin
            vif.MISO_ref <= 0;
            vif.rx_data_ref <= 0;
            vif.rx_valid_ref <= 0;
            counter <= 0;
            temp <= 0;
            read_addr_or_data <= 0; //should initially be zero, since we must send read address first
        end

    //=======   RAM write/read command:  =========
        else begin
    // they are the same since slave recieve 10 bits serially and resend them to ram, the ram will check if its read or write
            if(cs == WRITE || cs == READ_ADD || cs == READ_DATA) begin

                //serial in parallel out: parallelize vif.MOSI data to send it to ram, happens in all cases of read/write
                temp[(ADDR_SIZE+2) - counter - 1] <= vif.MOSI; //send 10 bits to ram

                //parallel in serial out: if ram asserts vif.tx_valid, serialize vif.tx_data to send it on vif.MISO
                if(vif.tx_valid) vif.MISO_ref <= vif.tx_data[ADDR_SIZE - counter];

                /*Why  [ADDR_SIZE - counter] not [ADDR_SIZE - counter - 1]?
                    in read data state, when 10 bits are sent to ram the counter reaches 9 and restarts at zero.
                    in the next clk the vif.tx_valid =1 , but the counter will have started counting again (counter =1)
                    in this case the first bit to be sent on vif.MISO is vif.tx_data[7] which is correct, not vif.tx_data[6].
                */

                //counter logic
                if(counter == (ADDR_SIZE + 1)) begin 
                    counter <= 0;
                    vif.rx_data_ref <= temp;
                    vif.rx_valid_ref <= 1; //when counter finishes 10 counts correct data will be ready on rx_data
                end

                else begin
                    counter <= counter + 1;
                    vif.rx_valid_ref <= 0;
                end

                //read_addr_or_data signal
                if(cs == READ_ADD) read_addr_or_data <= 1;
                else if(cs == READ_DATA) read_addr_or_data <= 0;

            end

            //if state is IDLE or CHK_CMD
            else begin 
                vif.rx_valid_ref <= 0;
                counter <= 0;
                temp <= 0;
            end
        end
    end 
endmodule