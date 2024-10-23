////EXAMPLE_1////
assert property(@(posedge clk) a |-> ##2 b);

////EXAMPLE_2////
assert property (@(posedge clk) (a&&b) |-> ##[1:3] c);

////EXAMPLE_3////
sequence s11b;
 ##2 (!b);
endsequence

property check;
  @(posedge clk) s11b;
endproperty

////EXAMPLE_4////
property decoder_3_8;
  @(posedge clk) $onehot(y);
endproperty

property priority_encoder;
  @(posedge clk) ($countones(D)===0) |=> (!valid);
endproperty
