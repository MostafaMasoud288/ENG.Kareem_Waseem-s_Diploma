package ALSU_seq_item_pck ;
import uvm_pkg::*;
`include "uvm_macros.svh"
typedef enum bit [2:0] {OR,XOR,ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7} opcode_e;
class ALSU_seq_item extends uvm_sequence_item;
 `uvm_object_utils(ALSU_seq_item)
bit clk;
rand logic signed cin;
rand logic rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
rand opcode_e opcode;
rand logic signed [2:0] A, B;
logic [15:0] leds;
logic signed [5:0] out;
parameter MAXPOS=3,MAXNEG=-4,ZERO=0;
rand opcode_e arr[6]; 

 function new (string name = "ALSU_seq_item");
  super.new(name);
 endfunction
  
function string convert2string ();
  return $sformatf("%s reset =0b%0b ,cin =0b%0b,serial_in =0b%0b,direction =0b%0b ,bypass_A =0b%0b,bypass_B =0b%0b,red_op_A =0b%0b,
  red_op_B =0b%0b ,opcode =0b%0b,A =0b%0b,B =0b%0b,out =0b%0b,leds =0b%0b",
  super.convert2string(),rst,cin,serial_in,direction,bypass_A,bypass_B,red_op_A,red_op_B,opcode,A,B,out,leds);
endfunction

function string convert2string_stimulus ();
  return $sformatf(" reset =0b%0b ,cin =0b%0b,serial_in =0b%0b,direction =0b%0b ,bypass_A =0b%0b,bypass_B =0b%0b,red_op_A =0b%0b,
  red_op_B =0b%0b,opcode =0b%0b,A =0b%0b,B =0b%0b",rst,cin,serial_in,direction,bypass_A,bypass_B,red_op_A,red_op_B,opcode,A,B);
endfunction

////CONSTRAINTS/////
constraint ALSU_Cons {

    //Reset to be asserted with a low probability//
    rst dist {1:=1,0:=99};
    
    // bypass_A and bypass_B should be disabled most of the time //
    bypass_A dist {1:=4,0:=96};
    bypass_B dist {1:=4,0:=96};
    
    // Invalid cases should occur less frequent than the valid cases //
    opcode dist {INVALID_6:/2,INVALID_7:/2,[0:5]:/96};
    if( red_op_A || red_op_B ) {opcode dist{OR:/40,XOR:/40,[2:7]:/20};}
    // in case of addition or multiplication inputs (A, B) to take the values (MAXPOS, ZERO and MAXNEG) more often than others //
    if( opcode == ADD || opcode == MULT )
    {
    A dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-3:-1]:/3,[1:2]:/2} ;
    B dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-3:-1]:/3,[1:2]:/2} ;
    }
    else if(opcode == OR || opcode == XOR)
    {
        if (red_op_A) {
            A dist {3'b001:/30,3'b010:/30,3'b100:/30,[-3:-1]:/6,3'b011:/2,3'b000:/2} ;
            B == 0;
        }
        else if (red_op_B) {
            B dist {3'b001:/30,3'b010:/30,3'b100:/30,[-3:-1]:/6,3'b011:/2,3'b000:/2}  ;
            A == 0;
        }
}

}
constraint extra
{
   unique{arr};
  foreach(arr[i])
      arr[i] dist {[OR:ROTATE]:/100};

}



endclass
endpackage