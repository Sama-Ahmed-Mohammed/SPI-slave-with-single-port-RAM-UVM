//Module that contains the assertions
import shared_pkg::*;

module WRAP_sva ( 
input bit clk ,
input bit SS_n,
input bit rst_n,
input bit MOSI,

input bit MISO
);


//1- Synchronous Reset  
property sync_rst; 
@(posedge clk) 
    (!rst_n)  |=> (MISO == 0 );
endproperty   

//2- MISO remains stable as long as it is not a read data operation :
//not_rd_data will be set in the sequences
property stable_MISO; 
@(posedge clk) 
    ( (current_state != READ_DATA)  && rst_n) |=> (( MISO  == $past(MISO) ));
endproperty 

//asserting the property
assert property(sync_rst) ;
cover property(sync_rst);

assert property(stable_MISO) ;
cover property(stable_MISO);

endmodule


