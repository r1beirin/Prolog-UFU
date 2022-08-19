created(1660867330.333714).
assert(chave(integrante,5)).
assert(chave(eventos,1)).
retractall(chave(eventos,_),1).
assert(chave(eventos,2)).
retractall(chave(eventos,_),1).
assert(chave(eventos,3)).
