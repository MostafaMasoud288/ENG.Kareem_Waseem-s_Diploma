
package m2;
typedef enum bit [2:0] {OR,XOR,ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7} opcode_e;

class alsu;
bit clk;
rand bit rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
rand opcode_e opcode;
rand bit signed [2:0] A, B;
bit [15:0] leds;
bit signed [5:0] out;
parameter MAXPOS=3,MAXNEG=-4,ZERO=0;
rand opcode_e arr[6]; 
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

covergroup cov ;
A_cp1 : coverpoint A
{
 bins A_data_0 = {0};
 bins A_data_max = {MAXPOS};
 bins A_data_min = {MAXNEG};
 bins others = default;
}
A_cp2 : coverpoint A iff (red_op_A) {bins A_data_walkingones [] = {1,2,4};}

B_cp1 : coverpoint B
{
 bins B_data_0 = {0};
 bins B_data_max = {MAXPOS};
 bins B_data_min = {MAXNEG};
 bins others = default;

}
B_cp2 : coverpoint B iff (red_op_B && !red_op_A) {bins B_data_walkingones [] = {1,2,4};}
ALU_cp : coverpoint opcode
{
 bins trans =(OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE);
 bins shift[] = {SHIFT,ROTATE};
 bins arith[] = {OR,XOR};
 bins bitwise[] = {MULT,ADD};
 illegal_bins invalid = {INVALID_6,INVALID_7};
}

opcode_B: cross ALU_cp,B_cp1
{
 bins op_b1 =binsof(ALU_cp.bitwise)&&binsof(B_cp1.B_data_0);
 bins op_b2 =binsof(ALU_cp.bitwise)&&binsof(B_cp1.B_data_max);
 bins op_b3 =binsof(ALU_cp.bitwise)&&binsof(B_cp1.B_data_min);
 option.cross_auto_bin_max=0;
}
opcode_A: cross ALU_cp,A_cp1
{
 bins op_a1 =binsof(ALU_cp.bitwise)&&binsof(A_cp1.A_data_0);
 bins op_a2 =binsof(ALU_cp.bitwise)&&binsof(A_cp1.A_data_max);
 bins op_a3 =binsof(ALU_cp.bitwise)&&binsof(A_cp1.A_data_min);
 option.cross_auto_bin_max=0;
}
opcode_cin: cross opcode,cin
{
 bins op_cin1 =binsof(opcode)intersect {ADD}&&binsof(cin)intersect {0};
 bins op_cin2 =binsof(opcode)intersect {ADD}&&binsof(cin)intersect {1};
 option.cross_auto_bin_max=0;
}
opcode_serial: cross opcode,serial_in
{
 bins op_cin1 =binsof(opcode)intersect {SHIFT}&&binsof(serial_in)intersect {0};
 bins op_cin2 =binsof(opcode)intersect {SHIFT}&&binsof(serial_in)intersect {1};
 option.cross_auto_bin_max=0;
}
opcode_direction: cross ALU_cp,direction
{
 bins op_dir1 =binsof(ALU_cp.shift)&&binsof(direction)intersect {0};
 bins op_dir2 =binsof(ALU_cp.shift)&&binsof(direction)intersect {1};
 option.cross_auto_bin_max=0;
}
reda: cross ALU_cp,A_cp2,B
{
 bins op_redA =binsof(ALU_cp.arith)&&binsof(A_cp2)&&binsof(B)intersect {0};
 option.cross_auto_bin_max=0;
}
redb: cross ALU_cp,B_cp2,A
{
 bins op_redB =binsof(ALU_cp.arith)&&binsof(B_cp2)&&binsof(A)intersect {0};
 option.cross_auto_bin_max=0;
}
reduction_invalid:coverpoint opcode iff(red_op_A ||red_op_B)
{
 illegal_bins reduction_invalid []={[ADD:INVALID_7]};
}
endgroup
function new();
cov =new();
endfunction


endclass

endpackage
