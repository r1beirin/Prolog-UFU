created(1660874897.9514313).
assert(chave(integrante,5)).
assert(chave(eventos,8)).
assert(chave(lancamentos,10)).
retractall(chave(lancamentos,_),1).
assert(chave(lancamentos,11)).
