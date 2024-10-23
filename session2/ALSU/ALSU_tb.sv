
import m2 ::*;
module ALSU_tb();
bit clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
opcode_e opcode;
bit signed [2:0] A, B;
bit [15:0] leds,leds_exp;
bit signed [5:0] out,out_exp;
/////////////////////////opcode_e arr[6]; 
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";

bit cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
bit signed [2:0] A_reg, B_reg;
bit [2:0] opcode_reg;
bit invalid_red_op, invalid_opcode, invalid;

ALSU DUT(.*);
alsu a=new;
integer error_count,correct_count,i;
initial
begin
clk=0;
forever begin
#1 clk=~clk;
a.clk=clk;
end
end

initial
begin 

error_count=0;
correct_count=0;
    a.rst=1'b1;
    init(a);
    check_result(a);

    a.constraint_mode(0);
    a.ALSU_Cons.constraint_mode(1);
    repeat(5000) begin
        assert(a.randomize());
        init(a);
        check_result(a);
        sampling(a);
    end

    a.constraint_mode(0);
    a.extra.constraint_mode(1);
    a.rst=0;a.bypass_A=0;a.bypass_B=0;a.red_op_A=0;a.red_op_B=0;
    a.rst.rand_mode(0);a.bypass_A.rand_mode(0);a.bypass_B.rand_mode(0);a.red_op_A.rand_mode(0);
   a.red_op_B.rand_mode(0);
    init(a);

    for(int i=0;i<50;i++)begin
        assert(a.randomize());
        cin=a.cin;direction=a.direction;serial_in=a.serial_in;A=a.A;B=a.B;
        if(i==28)a.arr.sort();
        foreach(a.arr[j])begin
          
            a.opcode=a.arr[j];
            opcode=a.arr[j];
            a.out=out;
            a.leds=leds;
            check_result(a);
            sampling(a);
        end
    end

a.rst=0;
a.A=2;
a.B=1;
a.opcode=OR;
a.bypass_A=1;
a.bypass_B=1;
sampling(a);
init(a);
check_result(a) ;//ALSU_3
a.bypass_A=0;
a.bypass_B=1;
sampling(a);
init(a);
check_result(a) ;//ALSU_4
a.bypass_A=1;
a.bypass_B=0;
sampling(a);
init(a);
check_result(a) ;//ALSU_5
a.bypass_A=0;
a.bypass_B=0;
a.red_op_A=1;
a.red_op_B=0;
sampling(a);
init(a);
check_result(a) ;//ALSU_6
a.red_op_A=0;
a.red_op_B=1;
sampling(a);
init(a);
check_result(a) ;//ALSU_7
$display(" Number of error transactions %d",error_count);
$display(" Number of correct transactions %d",correct_count);
$stop;
end

///////golden_model//////////

always @(posedge clk or posedge rst) begin
  if(rst) begin
     cin_reg <= 0;
     red_op_B_reg <= 0;
     red_op_A_reg <= 0;
     bypass_B_reg <= 0;
     bypass_A_reg <= 0;
     direction_reg <= 0;
     serial_in_reg <= 0;
     opcode_reg <= 0;
     A_reg <= 0;
     B_reg <= 0;
  end else begin
     cin_reg <= cin;
     red_op_B_reg <= red_op_B;
     red_op_A_reg <= red_op_A;
     bypass_B_reg <= bypass_B;
     bypass_A_reg <= bypass_A;
     direction_reg <= direction;
     serial_in_reg <= serial_in;
     opcode_reg <= opcode;
     A_reg <= A;
     B_reg <= B;
  end
end

//leds output blinking 
always @(posedge clk or posedge rst) begin
  if(rst) begin
     leds_exp <= 0;
  end else begin
      if (invalid)
        leds_exp <= ~leds_exp;
      else
        leds_exp <= 0;
  end
end

//ALSU output processing
always @(posedge clk or posedge rst) begin
  if(rst) begin
    out_exp <= 0;
  end
  else begin
    if (invalid) 
        out_exp <= 0;
    else if (bypass_A_reg && bypass_B_reg)
      out_exp <= (INPUT_PRIORITY == "A")? A_reg: B_reg;
    else if (bypass_A_reg )
      out_exp <= A_reg;
    else if (bypass_B_reg )
      out_exp <= B_reg;
    else begin
        case (opcode_reg)
          3'h0: begin 
            if (red_op_A_reg && red_op_B_reg)
              out_exp = (INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg ) 
              out_exp <= |A_reg;
            else if (red_op_B_reg )
              out_exp <= |B_reg;
            else 
              out_exp <= A_reg | B_reg;
          end
          3'h1: begin 
            if (red_op_A_reg && red_op_B_reg)
              out_exp <= (INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
            else if (red_op_A_reg ) 
              out_exp <= ^A_reg;
            else if (red_op_B_reg )
              out_exp <= ^B_reg;
            else 
              out_exp <= A_reg ^ B_reg;
          end
          3'h2:begin 
              if( FULL_ADDER == "ON")
                 out_exp <= A_reg + B_reg + cin_reg;
              else
                 out_exp <= A_reg + B_reg;
          end
          3'h3: out_exp <= A_reg * B_reg;
          3'h4: begin
            if (direction_reg)
              out_exp <= {out_exp[4:0], serial_in_reg};
            else
              out_exp <= {serial_in_reg, out_exp[5:1]};
          end
          3'h5: begin
            if (direction_reg)
              out_exp <= {out_exp[4:0], out_exp[5]};
            else
              out_exp <= {out_exp[0], out_exp[5:1]};
          end
          default:out_exp<=0;
        endcase
    end 
  end
end
always@* begin
 invalid_red_op = (red_op_A_reg || red_op_B_reg) && (opcode_reg!=0 && opcode_reg!=1);
 invalid_opcode = (opcode_reg==6 || opcode_reg==7);
invalid = invalid_red_op || invalid_opcode;
end



task check_result(alsu tr) ;
  @(negedge clk);
 a.out=out;
 a.leds=leds;
 if((a.out!=out_exp) || (a.leds!=leds_exp)) begin
    $display("incorrect result %t",$time);
    error_count=error_count+1; end
 else
  correct_count=correct_count+1;

endtask
 function void init(alsu tr);
        opcode=tr.opcode;A=tr.A;B=tr.B;
        rst=tr.rst;cin=tr.cin; red_op_A=tr.red_op_A; red_op_B=tr.red_op_B; bypass_A=tr.bypass_A;
        bypass_B=tr.bypass_B; direction=tr.direction; serial_in=tr.serial_in ;
        tr.out=out;tr.leds=leds;
    endfunction

    function  void  sampling(alsu a);
        if(rst ||bypass_B||bypass_A)begin
            a.cov.stop();
        end
        else begin
            a.cov.start();
            a.cov.sample();
        end
    endfunction

endmodule


