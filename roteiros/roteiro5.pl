% swipl Documents\fac\Prolog-UFU\roteiros\roteiro5.pl


tipotermo(X, atomo) :- 
    atom(X).
tipotermo(X, numero) :-
    number(X).
tipotermo(X, variavel) :-
    var(X).
tipotermo(X, constante) :-
    atomic(X).
tipotermo(X, termo_simples) :-
    functor(X, _, 0).
tipotermo(X, termo_complexo) :-
    functor(X, _, Y),
    Y > 0.
tipotermo(X, termo) :-
    tipotermo(X, termo_simples);
    tipotermo(X, termo_complexo).