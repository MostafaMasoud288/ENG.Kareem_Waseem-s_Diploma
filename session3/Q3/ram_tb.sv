package mo;
class transaction;
rand bit [7:0] data_in;
rand bit [15:0] address;
bit read;
bit write ;
bit [7:0] data_out ;
endclass
endpackage


import mo ::*;
module ram_tb();

/////signals///
bit clk;
bit write;
bit read;
bit [7:0] data_in;
bit [15:0] address;
bit [7:0] data_out;
localparam TESTS =100;
integer error_count=0,correct_count=0,i,j;
////RAM/////
 my_mem dut (.*);
////ARRAYS/////
bit [15:0] address_array [];//dynamic array fo address
bit [7:0] data_to_write_array [];//dynamic array fo data
bit [7:0] data_read_expect_assoc [int];//assiocitave array fo expected data read
bit [7:0] data_read_queue [$];//queue of data read
////object_generation///
transaction tra=new;
////clock_generation///
initial begin
clk=0;
forever begin
#1 clk=~clk;
end
end

///stimulas generation///
initial begin
tra.write=1;
tra.read=0;
write=tra.write;
read=tra.read;
stimulas_gen(tra);
//////writing///////

for(i=0;i<TESTS;i++)begin

data_in=data_to_write_array[i];
address=address_array[i];
@(negedge clk);
end
///////reading//////
tra.write=0;
tra.read=1;
write=tra.write;
read=tra.read;
for(j=99;j>=0;j--)begin
address=address_array[i];
//tra.data_out=data_out;
self_check;
data_read_queue.push_back(data_out);
end
/////filling queue////
j=0;
while( data_read_queue.size())begin
$display("DATA %d =0H%h",j,data_read_queue.pop_front);
j++;
end
$display(" Number of error transactions %d",error_count);
$display(" Number of correct transactions %d",correct_count);
$stop;
end

//////////////
task stimulas_gen(transaction trans);
address_array =new[TESTS];
data_to_write_array=new[TESTS];
for(i=0;i<TESTS;i++)begin
assert(trans.randomize());
address_array [i]=trans.address;
data_to_write_array [i]={~^trans.data_in,trans.data_in};
end
golden_model;
endtask

////////////
task golden_model;
//if(write)begin
    for(j=0;j<TESTS;j++)begin
        data_read_expect_assoc [address_array [j]]=data_to_write_array [j];
    end
//end
endtask
////////////////
task self_check ;
   @(negedge clk);
 if(data_out != data_read_expect_assoc [address]) begin
    $display("incorrect result %t",$time);
    error_count=error_count+1; end
 else
  correct_count=correct_count+1;
  

endtask

endmodule 
