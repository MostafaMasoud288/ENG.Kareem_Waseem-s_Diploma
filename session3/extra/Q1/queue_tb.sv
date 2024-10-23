module queue_tb();

int j;
int q[$];
initial begin
j=1;
q={0,2,5};
q.insert(1,j);
$display("q=%p",q);
q.delete(1);
$display("q=%p",q);
q.push_front(7);
$display("q=%p",q);
q.push_back(9);
$display("q=%p",q);
j=q.pop_back();
$display("q=%p,j=%d",q,j);
j=q.pop_front();
$display("q=%p,j=%d",q,j);
////last_point///
q.push_front(7);
q.push_back(9);
$display("q_original=%p",q);
q.reverse();
$display("q_reversed=%p",q);
q.sort();
$display("q_sorted=%p",q);
q.rsort();
$display("q_reverse_sorted=%p",q);
q.shuffle();
$display("q_shuffled=%p",q);
end
endmodule