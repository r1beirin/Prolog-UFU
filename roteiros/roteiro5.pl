%   Ex 3.

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

%   Ex 5.
:- op(300, xfx, [sao, eh_um]).
:- op(300, fx, gosta_de).
:- op(200, xfy, e).
:- op(100, fy, famoso).

_ eh_um _.
gosta_de _.
_ sao _.

/*  Ex 12
    p(X).
    X = 1, X = 2.

    p(X),p(Y).
    X = Y, Y = 1 ;
    X = 1,
    Y = 2 ;
    X = 2,
    Y = 1 ;
    X = Y, Y = 2.
    
    p(X),!,p(Y).
    X = Y, Y = 1 ;
    X = 1,
    Y = 2.

*/
p(1).
p(2):- !.
p(3).

/*
    Ex. 13: verifica se o número é positivo, negativo ou zero.
*/
classe(0, zero) :- !.
classe(Numero, positivo):- Numero > 0, !.
classe(Numero, negativo):- Numero < 0.

/*
    Ex. 14.
*/
classe2(0, zero).
classe2(Numero, positivo):- Numero > 0.
classe2(Numero, negativo):- Numero < 0.

separa([], [], []).
separa([X|Xs], P, [X|Ns]) :-
    classe2(X, negativo), !,
    separa(Xs, P, Ns).

separa([X|Xs], [X|P], Y) :-
    separa(Xs, P, Y).

/* Ex 15 */

f(X) :- !, X = p.
f(X) :- !, X = q.
f(X) :- X = r.