package mostafa ;

class transaction;

rand bit [7:0] data ;
rand bit [3:0] address ;

constraint c1{data ==5;}
constraint c2{address dist{0:/10,[1:14]:/80,15:/10};}

function display ();
$display("DATA = 0X%0h , ADDRESS = 0X%0h",this.data,this.address);
endfunction


endclass

endpackage
