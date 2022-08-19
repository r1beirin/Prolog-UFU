created(1660939165.369537).
assert(chave(integrante,6)).
assert(chave(email,1)).
assert(chave(eventos,3)).
assert(chave(lancamentos,4)).
assert(chave(pagamentos,1)).
retractall(chave(pagamentos,_),1).
assert(chave(pagamentos,2)).
