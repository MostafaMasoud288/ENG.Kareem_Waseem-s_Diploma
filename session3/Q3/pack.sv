package pack;
class transaction;
bit clk;
bit write;
bit read;
rand bit [7:0] data_in;
rand bit [15:0] address;
bit [7:0] data_out;
bit [15:0] address_array [];//dynamic array fo address
bit [7:0] data_to_write_array [];//dynamic array fo data
bit [7:0] data_read_expect_assoc [int];//assiocitave array fo expected data read
bit [7:0] data_read_queue [$];//queue of data read
function new();///constructor
address_array= new[100];
data_to_write_array= new[100];
endfunction
endclass
endpackage
