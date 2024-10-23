module asso();
bit [23:0] array [bit [19:0]];
int i;
initial begin
array [0] =24'hA50400;
array [20'h400] =24'h123456;
array [20'h401] =24'h789ABC;
array [20'hFFFFF] =24'h0F1E2D;
foreach(array [i])
begin
$display("elements : 0x%h",array[i]);
end
$display("number of elements :%d",array.num);

end
endmodule
