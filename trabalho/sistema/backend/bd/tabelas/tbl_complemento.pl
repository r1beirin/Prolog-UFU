created(1660939165.3683054).
assert(complemento(4,"d","2022-08-01","d","d","","d","d","d","d")).
assert(complemento(5,"teste","","123","123","123@hotmail","12","!3","1223","sp")).
assert(complemento(6,"testeok","","1233","","","","","","")).
retract(complemento(5,"teste","","123","123","123@hotmail","12","!3","1223","sp")).
retractall(complemento(6,_,_,_,_,_,_,_,_,_),1).
assert(complemento(6,"testeok","","1799277777777","","","","","","")).
