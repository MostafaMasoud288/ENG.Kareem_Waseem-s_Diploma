package pack;

class transaction;

parameter WIDTH = 4;
bit clk;
rand bit rst_n;
rand bit load_n;
rand bit up_down;
rand bit ce;
rand bit [WIDTH-1:0] data_load;
bit [WIDTH-1:0] count_out;
bit max_count;
bit zero;
///////constrains/////////
constraint c1{rst_n dist{0:/6,1:/94};}
constraint c2{load_n dist{0:/5,1:/95};}
constraint c3{ce dist{0:/5,1:/95};}
/////covergroups//////
covergroup cov ;
 A1: coverpoint data_load iff (!load_n);
 A2: coverpoint count_out iff (rst_n && ce && up_down){bins count1 [16] ={[0:15]};}
 A3: coverpoint count_out iff (rst_n && ce && up_down){bins count2 =(15=>0);}
 A4: coverpoint count_out iff (rst_n && ce && !up_down){bins count3 [16] ={[0:15]};}
 A5: coverpoint count_out iff (rst_n && ce && !up_down){bins count4 =(0=>15);}

endgroup
function new();
cov =new();
endfunction

endclass

endpackage
