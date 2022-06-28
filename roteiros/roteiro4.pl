% swipl Documents\fac\Prolog-UFU\roteiros\roteiro4.pl
/*
    Ex. 1:
*/
soma_acum2([], _, []).
soma_acum2([X|Xs], Acum, [AcumNovo|Resultado]) :-
    AcumNovo is X + Acum,
    soma_acum2(Xs, AcumNovo, Resultado).

soma_acum(X, Resultado) :-
    % dar um trace com o acum inicial [0] sem ser 0.
    soma_acum2(X, [0], Resultado).

/*
    Ex. 2:
*/
soma_ate_acum(0, Acum, Acum) :- !.
soma_ate_acum(X, Acum, Resultado) :-
    NovoX is X - 1,
    AcumNovo is X + Acum,
    soma_ate_acum(NovoX, AcumNovo, Resultado).

soma_ate(X, Resultado) :-
    soma_ate_acum(X, 0, Resultado).

/*
    Ex. 3:
*/
membro(X, [X|_]).
membro(X, [_|Ys]) :-
    membro(X, Ys).

sem_repeticao([], []).
sem_repeticao([X|Xs], Y) :-
    membro(X, Xs),
    sem_repeticao(Xs, Y).

sem_repeticao([X|Xs], [X|Ys]) :-
    sem_repeticao(Xs, Ys).

/*
    Ex. 4:
    Tentar usando a L2 na L1.
*/
concatena([], Y, Y).
concatena([X|Xs], Ys, [X|Resultado]) :-
    concatena(Xs, Ys, Resultado).

segmento([], []).
segmento(X, Y) :-
    concatena(X,_,Y).
segmento(X, [_|Ys]) :-
    segmento(X, Ys).

/*
    Ex. 5:
    Terminar
*/
separa_dup([], []).
separa_dup([X|Xs], Resultado) :-
    concatena([X], Y, Resultado),
    membro(X, [X|Xs]),
    separa_dup(Xs, Y).

/*separa_dup([_|Xs], Resultado) :-
    separa_dup(Xs, Resultado).*/

/*
    Ex. 6:
    Fazer
*/
replica([], _, []).

/*
    Ex. 7:
*/
bissexto(X) :-
    mod(X, 4) =:= 0,
    mod(X, 100) =\= 0.

bissexto(X) :-
    mod(X, 100) =:= 0,
    mod(X, 400) =:= 0.

/*
    Ex. 8: 
    Criar base de dados?
*/

/*
    Ex. 9:
        a) Done.
        b) Done.
        c) Done.
        d) Done.
*/
disjunto([], _) :- !.
disjunto([X|Xs], Y) :-
    not(membro(X, Y)),
    disjunto(Xs, Y).

uniao(_, _, []) :- !.
uniao(X, Y, [M|Ms]) :-
    (membro(M, X); membro(M, Y)),
    uniao(X, Y, Ms).

intersecao(_, _, []) :- !.
intersecao(X, Y, [M|Ms]) :-
    membro(M, X),
    membro(M, Y),
    intersecao(X, Y, Ms).

diferenca(_, _, []) :- !.
diferenca([X|Xs], Y, [X|M]) :-
    not(membro(X, Y)),
    diferenca(Xs, Y, M).

/*
    Ex. 10:
*/
ocorrencias_acum(_, [], Acum, Acum) :- !.
ocorrencias_acum(X, [X|Ys], Acum, N) :-
    AcumNovo is Acum + 1,
    ocorrencias_acum(X, Ys, AcumNovo, N).
ocorrencias_acum(X, [_|Ys], Acum, N) :-
    ocorrencias_acum(X, Ys, Acum, N).

ocorrencias(X, L, N) :- ocorrencias_acum(X, L, 0, N).

/*
    Ex. 11:
*/