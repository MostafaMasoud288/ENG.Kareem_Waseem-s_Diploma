module dff_t1_tb(); 
logic clk, rst, d, en;
logic q;

dff #(1) ff (.*);

integer error_count,correct_count;

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

d=1;
en=1;
reset_check;
check_result(1);

d=0;
en=0;
check_result(1);

d=0;
en=1;
check_result(0);

d=1;
en=0;
check_result(0);
reset_check;
$display(" Number of error transactions %d",error_count);
$display(" Number of correct transactions %d",correct_count);
$stop;
end

task check_result (input expected_value);
   @(negedge clk);
 if(expected_value!=q) begin
    $display("incorrect result %t",$time);
    error_count=error_count+1; end
 else
  correct_count=correct_count+1;

endtask

task reset_check ;
rst=1;
check_result(0);
rst=0;
//check_result(1);
endtask
endmodule
