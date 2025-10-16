package shared_pkg;
parameter ADDR_SIZE = 8;
parameter MEM_DEPTH = 256;

//To know which operation is taking place:
typedef enum bit [2:0] { WRITE_ADD= 3'b000, WRITE_DATA=3'b001, READ_ADD=3'b110, READ_DATA =3'b111 } state_e;
state_e current_state;  


int unsigned  counter_clk ; //counts cycles in each operation
bit comm_flag ; //Stores condition 
bit [10:0] MOSI_bits_saved; //Stores 11 bits from MOSI randomized array

//A flag to be adjusted by each sequence to enable the suitable constraint for each
//WR_ONLY sequence sets it to 0 ,
//RD_ONLY sequence sets it to 1 ,
//WR_RD sequence sets it to 2 , 
int seq_select ; 

endpackage
