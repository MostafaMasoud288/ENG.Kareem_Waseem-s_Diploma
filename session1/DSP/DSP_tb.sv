module DSP_tb();
//parameter OPERATION = "ADD";
logic  [17:0] A, B, D;
logic  [47:0] C;
logic clk, rst_n;
logic  [47:0] P;

DSP dsp (.*);

integer error_count,correct_count,i;

always
begin
clk=0;
#1;
clk=1;
#1;
end

initial
begin 

error_count=0;
correct_count=0;
A=2;
B=10;
C=1;
D=3;
reset_check;
for(i=0;i<15;i=i+1) begin
A=$random;
B=$random;
C=$random;
D=$random;
check_result(((D+B)*A)+C);
end
reset_check;

$display(" Number of error transactions %d",error_count);
$display(" Number of correct transactions %d",correct_count);
$stop;
end

task check_result (input  [47:0] expected_value);
  repeat(5) @(negedge clk);
 if(expected_value!=P) begin
    $display("incorrect result %t",$time);
    error_count=error_count+1; end
 else
  correct_count=correct_count+1;

endtask

task reset_check ;
rst_n=0;
check_result(0);
rst_n=1;
//check_result(1);
endtask

endmodule
