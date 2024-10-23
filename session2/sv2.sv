class packet;

logic [7:0] data_in;
logic [3:0] address;

function new (logic [7:0] data=0,logic [3:0] addr =0);
address=addr;
data_in=data;
endfunction

function display ();
$display("DATA = 0X%0h , ADDRESS = 0X%0h",this.data_in,this.address);
endfunction

endclass

module sv2_tb();
packet pkt1,pkt2;
initial begin

pkt1=new (.addr(2));
pkt1.display();

pkt2=new (.data(3),.addr(4));
pkt2.display();
end
endmodule
