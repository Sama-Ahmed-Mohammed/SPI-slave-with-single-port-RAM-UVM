import uvm_pkg::*; 
`include "uvm_macros.svh" 
 
import WRAP_test_pkg::*; 
 
module TB_top(); 
 //1- clock generation 
bit clk;   
initial begin 
    clk=0; 
    forever begin 
    #1 clk=!clk ; 
    end 
end   
 
//2- Interface  
WRAP_if wrap_if (clk); 
 
//3- DUT intiation 
top DUT_top (  
    wrap_if.SS_n,
    clk,
    wrap_if.rst_n,
    wrap_if.MOSI,
    wrap_if.MISO
);
 
//4-Refrence model (using the design top) 
top refrence_model (  
    wrap_if.SS_n,
    clk,
    wrap_if.rst_n,
    wrap_if.MOSI,
    wrap_if.MISO_ref
);

//5-binding the wrapper dut and the assertions      
bind top WRAP_sva wrapper_sva_inst ( 
  .clk(clk), 
  .SS_n(SS_n),
  .rst_n(rst_n),
  .MOSI(MOSI),
  .MISO(MISO)
); 
 
initial begin 
//6- Set virtual interface     
  uvm_config_db#(virtual WRAP_if)::set(null, "uvm_test_top", "wrap_if" ,wrap_if);   
//7- run test using run_test task 
  run_test("wrap_test"); 
end    
 
endmodule   
