

package sequence_item ;
import uvm_pkg::*;
import shared_pck::*;
`include "uvm_macros.svh"
class shift_reg_seq_item extends uvm_sequence_item;
 `uvm_object_utils(shift_reg_seq_item)
  rand bit  reset;
  rand bit serial_in;
  rand direction_e direction;
  rand mode_e mode;
  rand bit [5:0] datain;
  logic [5:0] dataout;

 function new (string name = "shift_reg_seq_item");
  super.new(name);
 endfunction
  
function string convert2string ();
  return $sformatf("%s reset =0b%0b ,sereal_in =0b%0b,direction =0b%0b ,mode =0b%0b ,datain =0b%0b,dataout =0b%0b",super.convert2string(),reset,serial_in,direction,mode,datain,dataout);
endfunction

function string convert2string_stimulas ();
  return $sformatf(" reset =0b%0b ,sereal_in =0b%0b,direction =0b%0b ,mode =0b%0b ,datain =0b%0b",reset,serial_in,direction,mode,datain);
endfunction

constraint rst { reset dist {0:/98,1:/2};}

endclass
endpackage
