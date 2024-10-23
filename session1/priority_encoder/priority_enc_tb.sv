package encoderr;
class transaction;
rand bit rst;
rand bit [3:0] D;
endclass
endpackage

import encoderr::*;
module priority_enc_tb ();

bit clk;
bit  rst;
bit [3:0] D;
bit  [1:0] Y;
bit  valid;

priority_enc dut (clk,rst,D,Y,valid);
//integer error_count,correct_count;

initial begin
clk=0;
forever begin
#1 clk=~clk;
end
end

transaction tra =new();

property reset;
@(negedge clk) rst |-> (!valid && !Y);
endproperty


property nonvalidation;
@(negedge clk) (!rst&&(~|D)) |-> (!valid);
endproperty

property validation;
@(negedge clk) (!rst&&(|D)) |-> valid;
endproperty

property out1;
@(negedge clk) (!rst&&D[3]&&!D[2]&&!D[1]&&!D[0]) |-> (Y===0);
endproperty

property out2;
@(negedge clk) (!rst&&D[2]&&!D[1]&&!D[0]) |-> (Y===1);
endproperty

property out3;
@(negedge clk) (!rst&&D[1]&&!D[0]) |-> (Y===2);
endproperty

property out4;
@(negedge clk) (!rst&&D[0]) |-> (Y===3);
endproperty

assert property (validation);
cover property (validation);
assert property (nonvalidation);
cover property (nonvalidation);
assert property (reset);
cover property (reset);
assert property (out1);
cover property (out1);
assert property (out2);
cover property (out2);
assert property (out3);
cover property (out3);
assert property (out4);
cover property (out4);


initial 
begin
for(int i=0 ;i<5000;i++)begin
assert(tra.randomize());
rst=tra.rst;
D=tra.D;
#2;
end
$stop;
end

endmodule
