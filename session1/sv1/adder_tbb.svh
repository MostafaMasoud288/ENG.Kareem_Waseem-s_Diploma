package addpack;
class transaction;
    bit  clk;
   rand  bit  reset;
   rand  bit  signed [3:0] A;
   rand bit  signed [3:0] B;	
    bit signed [4:0] C ;
    parameter MAXPOS=7,MAXNEG=-8,ZERO=0;
constraint alucons 
{
 reset dist {1:=1,0:=99};
 A dist {MAXPOS:/10,MAXNEG:/10,ZERO:/10,[-7:-1]:/35,[1:6]:/35} ;
 B dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-7:-1]:/3,[1:6]:/2} ;
}
covergroup A_COV;
coverpoint A
{
 bins max ={MAXPOS};
 bins zero = {ZERO};
 bins min ={MAXNEG};
 bins others =default;
 bins data_0max=(0=>MAXPOS);
 bins data_minmax=(MAXNEG=>MAXPOS);
 bins data_maxmin=(MAXPOS=>MAXNEG);
}
endgroup
covergroup B_COV;
coverpoint B
{
 bins max ={MAXPOS};
 bins zero = {ZERO};
 bins min ={MAXNEG};
 bins others =default;
 bins data_0max=(0=>MAXPOS);
 bins data_minmax=(MAXNEG=>MAXPOS);
 bins data_maxmin=(MAXPOS=>MAXNEG);
}
endgroup
function new;
A_COV=new;
B_COV=new;
endfunction
endclass
endpackage

import addpack::*;
module adder_tbb(); 
    logic  clk_tb;
    logic  reset_tb;
    logic  signed [3:0] A_tb;	
    logic  signed [3:0] B_tb;	
    logic  signed [4:0] C_tb; 

 adder dut (.clk(clk_tb),.reset(reset_tb),.A(A_tb),.B(B_tb),.C(C_tb));
// localparam MAXPOS= 7,MAXNEG= -8 ;
  integer error_count,correct_count;
 transaction ts =new;
always
begin
clk_tb=0;
forever begin 
#1 clk_tb=~clk_tb;
ts.clk=clk_tb;
end
end

initial
begin 

error_count=0;
correct_count=0;
A_tb=1;
B_tb=0;
reset_check;///adder_1
sampling(ts);
repeat (1000)begin
assert(ts.randomize());//adder_2
A_tb=ts.A;
B_tb=ts.B;
reset_tb=ts.reset;
///goldenmodel///
if(reset_tb)
check_result(0);
else
check_result(A_tb+B_tb);
sampling(ts);
end
reset_check;//adder_3



$display(" Number of error transactions %d",error_count);
$display(" Number of correct transactions %d",correct_count);
$stop;
end

task check_result (input signed [4:0] expected_value);
   @(negedge clk_tb);
 if(expected_value!=C_tb) begin
    $display("incorrect result %t",$time);
    error_count=error_count+1; end
 else
  correct_count=correct_count+1;

endtask

task reset_check ;
reset_tb=1;
check_result(0);
reset_tb=0;
//check_result(1);
endtask

function void sampling(transaction ts);
if(ts.reset)begin
ts.A_COV.stop();
ts.B_COV.stop();
end
else begin
ts.A_COV.start();
ts.B_COV.start();
ts.A_COV.sample();
ts.B_COV.sample();
end
endfunction

endmodule
