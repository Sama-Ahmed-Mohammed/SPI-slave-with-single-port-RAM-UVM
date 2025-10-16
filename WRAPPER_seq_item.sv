package WRAP_seq_item_pkg; 
import uvm_pkg::*; 
`include "uvm_macros.svh" 
 
import shared_pkg::*; 
 
class WRAP_seq_item extends uvm_sequence_item ; 
`uvm_object_utils(WRAP_seq_item) 

//signals:
rand bit SS_n;
rand bit rst_n;
bit MOSI;
rand bit tx_valid;
rand bit [7:0] tx_data;
bit [9:0] rx_data, rx_data_ref;
bit rx_valid, MISO, rx_valid_ref, MISO_ref;

//array to store randomized mosi bits
rand bit [10:0] MOSI_bits;

//FUNCTIONS:

//1-Pre randomize func:
function void pre_randomize();

if(((counter_clk == 12) && (current_state inside { WRITE_ADD, WRITE_DATA, READ_ADD}) || ((counter_clk ==22 ) && (current_state == READ_DATA))))begin
  counter_clk = 0;
  MOSI_bits.rand_mode(1);

  comm_flag = 0;
end else begin 
  comm_flag = 1;
  MOSI_bits.rand_mode(0);
  MOSI_bits = MOSI_bits_saved;
end

endfunction

//2-post randomize func:
function void post_randomize() ;
current_state = state_e'(MOSI_bits[10:8]);
MOSI_bits_saved = MOSI_bits ;
if (!rst_n )begin
     comm_flag = 0;
     counter_clk =0 ;
end

if (!SS_n )begin
     if(!((counter_clk == 12) && (current_state inside { WRITE_ADD, WRITE_DATA, READ_ADD}) || ((counter_clk ==22 ) && (current_state == READ_DATA)))) begin
      counter_clk++ ;
      if(counter_clk < 13)begin 
        MOSI = MOSI_bits[12 - counter_clk];
      end

     end
     else begin
       comm_flag = 1 ;
       counter_clk = 1 ;  
     end           
end

endfunction

//3-Constructor:
function new(string name = "WRAP_seq_item"); 
super.new(name); 
endfunction 

//4-convert to string:
function string convert2string(); 
begin 
return $sformatf("%s SS_n = 0b%0b, rst_n =0b%0b, MOSI=0b%0b, MISO=0b%0b",
   
                 super.convert2string(),  
                 SS_n, rst_n, MOSI, MISO ) ; 
end                  
endfunction  

//5-convert to string, stimulus only : 
function string convert2string_stimulus(); 
return $sformatf("SS_n = 0b%0b, rst_n =0b%0b, MOSI=0b%0b",
                 SS_n, rst_n, MOSI ) ; 
                 
endfunction 
 
//CONSTRAINTS: 

//con1:rst de-asserted most of the time 
constraint rst_n_signal {   
                    rst_n dist{1:=98, 0:=2}; 
} 

//con2:Set SS_n signal once every 13 cycles for all cases except read data, set ss_n once every 23 cycles 
constraint SS_n_constraint { 
              if( !rst_n ){
              SS_n == 1;  //no communication allowed
              }
              else {
              if (~comm_flag) {
              SS_n == 1; 
              }
              else {
              SS_n == 0; //start the communucation
              }
              }
              
}

//con3: Randomize array holding data for MOSI,but apply constraint so 1st 3 bits lead to one of the 4 valid op
constraint MOSI_values {  
            if(~comm_flag){
              MOSI_bits [10:8] inside { WRITE_ADD, WRITE_DATA, READ_ADD, READ_DATA } ;  
}              
} 

//con4 , con5, con6  :
//FOR WRITE ONLY SEQUENCE: wr_addr op must be followed by wr_data or wr_addr op
//FOR READ ONLY SEQUENCE: Rd_addr op must be followed by Rd_data or Rd_addr op
//FOR READ/WRITE SEQUENCE:......
constraint modes {
if(seq_select == 0 && (~comm_flag)){ //WR ONLY SEQUENCE
  if ((current_state == WRITE_ADD) && rst_n ){ 
               MOSI_bits [10:8] inside {WRITE_ADD, WRITE_DATA} ;
               } 
}  
else if (seq_select ==1 && (~comm_flag)){ //READ ONLY SEQUENCE
   ((current_state == READ_ADD ) && rst_n ) -> MOSI_bits [10:8] == READ_DATA ;
              ((current_state == READ_DATA) && rst_n ) -> MOSI_bits [10:8] == READ_ADD ; 
}
else if (seq_select ==2 && (~comm_flag)){ //READ or WRITE SEQUENCE
   ((current_state == WRITE_ADD) && rst_n ) -> MOSI_bits [10:8] inside {WRITE_ADD, WRITE_DATA} ;
   ((current_state == WRITE_DATA) && rst_n ) -> MOSI_bits [10:8] dist {READ_ADD:=60, WRITE_ADD:=40};
   ((current_state == READ_ADD) && rst_n ) -> MOSI_bits [10:8] == READ_DATA ;
   ((current_state == READ_DATA) && rst_n ) -> MOSI_bits [10:8] dist {READ_ADD:=40, WRITE_ADD:=60}; 
}                 
}  
                                          
endclass 
endpackage


