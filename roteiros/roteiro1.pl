/*
    Familia dos Simpsons
*/

homem(abraham).
homem(clancy).
homem(herbert).
homem(homer).
homem(bart).
mulher(mona).
mulher(jacqueline).
mulher(abbey).
mulher(marge).
mulher(selma).
mulher(patty).
mulher(maggie).
mulher(lisa).
mulher(ling).

pai(abraham, herbert).
pai(abraham, abbey).
pai(abraham, homer).
pai(clancy, marge).
pai(clancy, selma).
pai(clancy, patty).
pai(homer, maggie).
pai(homer, lisa).
pai(homer, bart).
mae(mona, homer).
mae(jacqueline, marge).
mae(jacqueline, selma).
mae(jacqueline, patty).
mae(marge, maggie).
mae(marge, lisa).
mae(marge, bart).
mae(selma, ling).

avoM(X, Y) :-
    pai(X, Z),
    pai(Z, Y).
avoM(X, Y) :- 
    pai(X, Z), 
    mae(Z, Y).
avoF(X, Y) :-
    mae(X, Z),
    pai(Z, Y).
avoF(X, Y) :-
    mae(X, Z),
    mae(Z, Y).

/*
    Mundo do Harry Potter
*/
:- dynamic feiticeiro/1.

elfo_domestico(dobby).

bruxo(hermione).
bruxo('McGonagall'). % Uso dos ' ' para usar letra maiuscula na primeira palavra. Obs: na consulta também.
bruxo(rita_skeeter).

magico(X) :- elfo_domestico(X).
magico(X) :- feiticeiro(X).
magico(X) :- bruxo(X).

/*
    Consultas:

    5. magico(elfo_domestico). -> Falso, pois não existe ninguém chamado elfo_domestico que está ligado aos predicados de elfo_domestico ou bruxo.
    6. feiticeiro(harry). -> Falso, pois não existe nenhum fato feiticeiro(harry) escrito.
    7. magico(feiticeiro). -> Falso, pois o nome feiticeiro não é um elfo_domestico nem um bruxo.
    8. magico('McGonagall'). -> True, pois existe um bruxo('McGonagall').
    9. magico(Hermione). -> O resultado da consulta são as unificações que a variavel Hermione pode fazer.
    Fazer a arvore de busca de magico(Hermione). no papel.
*/