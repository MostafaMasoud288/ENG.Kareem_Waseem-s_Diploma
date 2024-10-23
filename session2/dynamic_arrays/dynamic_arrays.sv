module dynamic_array();
integer i;
int dyn_arr_1 [],dyn_arr_2 [];

initial begin
dyn_arr_1 = new[6];
dyn_arr_2='{9,1,8,3,4,4};

for(i=0;i<6;i=i+1) dyn_arr_1[i]=i;
$display("array1=%p,size=%d",dyn_arr_1,$size(dyn_arr_1));
dyn_arr_1.delete();

dyn_arr_2.reverse();
$display("array2_reversed=%p",dyn_arr_2);
dyn_arr_2.sort();
$display("array2_sorted=%p",dyn_arr_2);
dyn_arr_2.rsort();
$display("array2_reverse_sorted=%p",dyn_arr_2);
dyn_arr_2.shuffle();
$display("array2_shuffled=%p",dyn_arr_2);

end
 
endmodule
