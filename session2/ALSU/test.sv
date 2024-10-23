import m2 ::*;
module test();
IMAGE a =new;
initial begin
assert(a.randomize());
a.print;
end

endmodule
