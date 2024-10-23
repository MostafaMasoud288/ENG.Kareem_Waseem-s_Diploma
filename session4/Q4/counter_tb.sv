import pack ::*;
module counter_tb(counter_interface.test inter);
transaction tra =new;

initial begin
for(int i=0;i<1000;i=i+1)
begin
assert(tra.randomize());
inter.rst_n=tra.rst_n;
inter.load_n=tra.load_n;
inter.up_down=tra.up_down;
inter.ce=tra.ce;
inter.data_load=tra.data_load;
tra.count_out=inter.count_out;
tra.max_count=inter.max_count;
tra.zero=inter.zero;
@(negedge inter.clk);
#2;
sampling(tra);

end
$stop;
end

function  void  sampling(transaction tra);
        if(!tra.rst_n)begin
            tra.cov.stop();
        end
        else begin
            tra.cov.start();
            tra.cov.sample();
        end
    endfunction

endmodule
