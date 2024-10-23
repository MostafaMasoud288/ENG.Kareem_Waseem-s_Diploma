package m1;

class cnt;

parameter WIDTH = 4;
bit clk;
rand bit rst_n;
rand bit load_n;
rand bit up_down;
rand bit ce;
rand bit [WIDTH-1:0] data_load;
bit [WIDTH-1:0] count_out;
///////constrains/////////
constraint c1{rst_n dist{0:/6,1:/94};}
constraint c2{load_n dist{0:/5,1:/95};}
constraint c3{ce dist{0:/5,1:/95};}
/////covergroups//////
covergroup cov @(posedge clk);
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
////////////////////////

import m1 ::*;
module counter_tb();
parameter WIDTH =4;
bit clk;
bit rst_n;
bit load_n;
bit up_down;
bit ce;
bit [WIDTH-1:0] data_load;
bit [WIDTH-1:0] count_out,count_exp;
bit max_count,max_exp;
bit zero,zero_exp;

counter  #(.WIDTH(WIDTH))dut (.*);

cnt a =new;
integer error_count,correct_count,i;
initial begin
clk=0;
forever begin
#1 clk=~clk;
a.clk=clk;
end
end

initial begin

error_count=0;
correct_count=0;
rst_n=0;
check_result ;
for(i=0;i<1000;i=i+1)
begin
////////
assert(a.randomize());
rst_n=a.rst_n;
load_n=a.load_n;
up_down=a.up_down;
ce=a.ce;
data_load=a.data_load;
check_result ;
////////

end
$display(" Number of error transactions %d",error_count);
$display(" Number of correct transactions %d",correct_count);
$stop;
end
///////golden_model//////////
always @(posedge clk) begin
    if (!rst_n)
        count_exp <= 0;
    else if (!load_n)
        count_exp <= data_load;
    else if (ce) begin
        if (up_down)
            count_exp <= count_exp + 1;
        else 
            count_exp <= count_exp - 1; 
    end
end

assign max_exp = (count_exp == {WIDTH{1'b1}})? 1:0;
assign zero_exp = (count_exp == 0)? 1:0; 


task check_result ;
   @(negedge clk);
 a.count_out=count_out;
 if((count_out!=count_out) || (zero!=zero_exp) || (max_count!=max_exp)) begin
    $display("incorrect result %t",$time);
    error_count=error_count+1; end
 else
  correct_count=correct_count+1;

endtask
//////////
endmodule
