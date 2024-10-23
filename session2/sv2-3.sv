import mostafa ::*;
module sv2_3_tb();
 transaction a =new;
integer i;

initial begin

for(i=0;i<20;i=i+1)
begin
assert(a.randomize());
a.display();
end

end

endmodule
