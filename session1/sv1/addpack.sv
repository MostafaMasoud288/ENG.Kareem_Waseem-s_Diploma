package addpack;
class transaction;
    bit  clk;
   rand  bit  reset;
   rand  bit  signed [3:0] A;
   rand bit  signed [3:0] B;	
    bit signed [4:0] C ;
    parameter MAXPOS=7,MAXNEG=-8,ZERO=0;
constraint alucons 
{
 reset dist {1:=1,0:=99};
 A dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[-7:-1]:/3,[1:6]:/2} ;
 B dist {MAXPOS:/33,MAXNEG:/32,ZERO:/30,[--7:-1]:/3,[1:6]:/2} ;
}
covergroup A_COV;
coverpoint A
{
 bins max ={MAXPOS};
 bins zero = {ZERO};
 bins min ={MAXNEG};
 bins others =default;
 bins data_0max=(0=>MAXPOS);
 bins data_minmax=(MAXNEG=>MAXPOS);
 bins data_maxmin=(MAXPOS0=>MAXNEG);
}
endgroup
covergroup B_COV;
coverpoint B
{
 bins max ={MAXPOS};
 bins zero = {ZERO};
 bins min ={MAXNEG};
 bins others =default;
 bins data_0max=(0=>MAXPOS);
 bins data_minmax=(MAXNEG=>MAXPOS);
 bins data_maxmin=(MAXPOS0=>MAXNEG);
}
endgroup
function void new;
A_COV=new;
B_COV=new;
endfunction
endclass
endpackage
