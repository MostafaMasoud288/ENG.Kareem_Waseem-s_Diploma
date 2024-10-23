package ALSU_Package;

// Enums //
typedef enum {OR=0,XOR,ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7}opcode_e;

// Parameters //
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
parameter MAXPOS=3;
parameter ZERO=0;
parameter MAXNEG=-4;
parameter T=2;

// Class //
class ALSU_Constraints;

// Class Variables //
rand logic Reset;
rand logic signed [2:0] a,b;
rand logic BYPASS_A,BYPASS_B;
rand opcode_e OPCODE; 
rand logic CIN;
rand logic RED_OP_A,RED_OP_B;
rand logic SERIAL_IN;
rand logic DIRECTION;

// Constraints block //

constraint ALSU_Cons {

    //Reset to be asserted with a low probability//
    Reset dist {1:=1,0:=99};
    
    // bypass_A and bypass_B should be disabled most of the time //
    BYPASS_A dist {1:=4,0:=96};
    BYPASS_B dist {1:=4,0:=96};
    
    // Invalid cases should occur less frequent than the valid cases //
    OPCODE dist {INVALID_6:/2,INVALID_7:/2,[0:5]:/96};
    
    // in case of addition or multiplication inputs (A, B) to take the values (MAXPOS, ZERO and MAXNEG) more often than others //
    if( OPCODE == ADD || OPCODE == MULT )
    {
    a dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-3:-1]:/3,[1:2]:/2} ;
    b dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-3:-1]:/3,[1:2]:/2} ;
    }
    else if(OPCODE == OR || OPCODE == XOR)
    {
        if (RED_OP_A) {
            a dist {3'b001:/30,3'b010:/30,3'b100:/30,[-3:-1]:/6,3'b011:/2,3'b000:/2} ;
            b == 0;
        }
        else if (RED_OP_B) {
            b dist {3'b001:/30,3'b010:/30,3'b100:/30,[-3:-1]:/6,3'b011:/2,3'b000:/2}  ;
            a == 0;
        }
}

}

endclass

endpackage

import ALSU_Package::*;

// Module Delaration //
module ALSU_tb1(); 

// Signals Declaration //
// inputs //
logic clk,reset;
logic signed [2:0] A,B;
logic cin;
logic serial_in;
logic red_op_A,red_op_B;
opcode_e opcode;
logic bypass_A,bypass_B;
logic direction;

// internals //
logic signed [2:0] A_REG,B_REG;
logic cin_reg,serial_in_reg;
logic red_op_A_reg,red_op_B_reg;
logic bypass_A_reg,bypass_B_reg;
logic [2:0] opcode_reg;
logic direction_reg;
logic signed [5:0] out_reg;
logic signed [5:0] Expected_out;
logic [15:0]Expected_leds,leds_reg;

logic invalid_red_op, invalid_opcode, invalid;

// Outputs //
logic [15:0]leds;
logic signed [5:0]out;

// Summary Counters //
int Pass_Count=0;
int Error_Count=0;

// DUT Instantiation //

ALSU alsu (.clk(clk)
          ,.rst(reset)
          ,.A(A)
          ,.B(B)
          ,.cin(cin)
          ,.serial_in(serial_in)
          ,.red_op_A(red_op_A)
          ,.red_op_B(red_op_B)
          ,.opcode(opcode)
          ,.bypass_A(bypass_A)
          ,.bypass_B(bypass_B)
          ,.direction(direction)
          ,.out(out)
          ,.leds(leds)
);


// Clock Generation //
always begin
    clk=1'b0;
    #(T/2);
    clk=1'b1;
    #(T/2);
end

ALSU_Constraints obj=new();
// Stimulus Generation //
initial begin

// ALSU_1 //
reset_assert;

// ALSU_2 //
for (int i = 0; i<200 ;i++ ) begin
    assert(obj.randomize());
    reset=obj.Reset;
    A=obj.a;
    B=obj.b;
    cin=obj.CIN;
    serial_in=obj.SERIAL_IN;
    red_op_A=obj.RED_OP_A;
    red_op_B=obj.RED_OP_B;
    opcode=obj.OPCODE;
    bypass_A=obj.BYPASS_A;
    bypass_B=obj.BYPASS_B;
    direction=obj.DIRECTION;
    check_result();
end    
$display("Testbench Summary: %0d Test cases Passed , %0d Test Cases Failed",Pass_Count,Error_Count);
reset_assert;
$stop;
end

// Golden Model //
always @(posedge clk , posedge reset)
begin

    Expected_leds<=16'b0;
    if(reset)
    begin
        Expected_leds<=16'b0;
        A_REG<=0;
        B_REG<=0;
        out_reg<=0;
        cin_reg<=0;
        serial_in_reg<=0;
        red_op_A_reg<=0;
        red_op_B_reg<=0;
        bypass_A_reg<=0;
        bypass_B_reg<=0;
        opcode_reg<=0;
        direction_reg<=0;
        Expected_out<=0;
        Expected_leds<=0;
    end
    else
    begin
        A_REG<=A;
        B_REG<=B;
        cin_reg<=cin;
        serial_in_reg<=serial_in;
        red_op_A_reg<=red_op_A;
        red_op_B_reg<=red_op_B;
        bypass_A_reg<=bypass_A;
        bypass_B_reg<=bypass_B;
        opcode_reg<=opcode;
        direction_reg<=direction;
        Expected_out<=out_reg;
        Expected_leds<=leds_reg;
    end
end
always @(*) begin
     if (invalid)
    begin
        out_reg<=0;
    end
    else if(bypass_A_reg || bypass_B_reg) begin
        if (bypass_A_reg && bypass_B_reg)
        begin
        if(INPUT_PRIORITY == "A")
        out_reg=A_REG;
        else 
        out_reg=B_REG;
        end
        else if(bypass_A_reg) begin
            out_reg=A_REG;
        end
        else
        out_reg=B_REG;
    end
    else
    begin
    case (opcode_e'(opcode_reg))
    OR:
        begin
            if(INPUT_PRIORITY == "A") begin
                if(red_op_A_reg)
                out_reg = |A_REG;
                else if(red_op_B_reg)
                out_reg = |B_REG;
                else 
                out_reg = A_REG | B_REG;
            end
            else begin
                 if(red_op_B_reg)
                out_reg = |B_REG;
                else if(red_op_A_reg)
                out_reg = |A_REG;
                else 
                out_reg = A_REG | B_REG;
            end
        end
    XOR:
        begin
            if(red_op_A_reg)
            out_reg = ^A_REG;
            else if(red_op_B_reg)
            out_reg = ^B_REG;
            else 
                out_reg = A_REG ^ B_REG;
        end
    ADD:
        begin
         if(FULL_ADDER =="ON")
         out_reg=A_REG+B_REG+cin_reg;   
         else
         out_reg=A_REG+B_REG;
        end
    MULT:
        begin
         out_reg = A_REG*B_REG;   
        end
    SHIFT:
         begin
            if(direction_reg)begin
                out_reg = {out[4:0],serial_in_reg};
            end
            else begin
                out_reg = {serial_in_reg,out[5:1]};
            end
         end
    ROTATE:
          begin
            if(direction_reg)begin
                out_reg = {out[4:0],out[5]};
            end
            else begin
                out_reg={out[0],out[5:1]};
            end
          end
    default: 
           begin
                out_reg=16'b0;
                
           end   
    endcase 
     end
if(invalid)
leds_reg=~leds;
else
leds_reg=0;
end

//Invalid handling
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (~opcode_reg[2] & ~opcode_reg[1]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;



// Response Checker //
task check_result();
@(negedge clk);
if (Expected_out != out || Expected_leds != leds) begin
    Error_Count=Error_Count+1;
end

else begin
    Pass_Count=Pass_Count+1;
end

endtask

// Reset //
task reset_assert();
reset=1'b1;
@(negedge clk);
if(out != Expected_out || Expected_leds != leds)
begin
$display("Reset Failed");    
Error_Count=Error_Count+1;    
end
else
Pass_Count=Pass_Count+1;
reset=1'b0;
endtask


endmodule