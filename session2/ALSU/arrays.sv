module arrays();

bit [11:0] my_array [3:0] ;
integer i;

initial begin 
my_array = '{12'h012,12'h345,12'h678,12'h9AB};
//for(i=0;i<4;i++)
//$display("location %d : %b",i,my_array[i][5:4]);

foreach(my_array[i])
$display("location %d : %b",i,my_array[i][5:4]);
end
endmodule
