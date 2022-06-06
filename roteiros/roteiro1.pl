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
    pai(Z, Y);
    mae(Z, Y).

avoF(X, Y) :-
    mae(X, Z),
    pai(Z, Y);
    mae(Z, Y).

filho(X, Y) :-
    homem(X),
    pai(Y, X);
    mae(Y, X).

filha(X, Y) :-
    mulher(X),
    pai(Y, X);
    mae(Y, X).

irmao(X, Y) :-
    homem(X),
    not(X = Y),
    pai(Pai, X),
    pai(Pai, Y);
    not(X = Y),
    mae(Mae, X),
    mae(Mae, Y).

irma(X, Y) :-
    mulher(X),
    not(X = Y),
    pai(Pai, X),
    pai(Pai, Y);
    not(X = Y),
    mae(Mae, X),
    mae(Mae, Y).

irmaos(X, Y) :- 
    not(X = Y),
    irmao(X, Y);
    irma(X, Y).

tio(X, Y) :-
    homem(X),
    pai(Pai, Y),
    irmaos(X, Pai);
    mae(Mae, Y),
    homem(X),
    irmaos(X, Mae).

tia(X, Y) :-
    mae(Mae, Y),
    irmaos(X, Mae);
    pai(Pai, Y),
    mulher(X),
    irmaos(X, Pai).

% terminar prima
prima(X, Y) :-
    mae(MaeX, X),
    mae(MaeY, Y),
    mulher(X),
    irma(MaeX, MaeY).

/*
    Mundo do Harry Potter

    Consultas:

    5. magico(elfo_domestico). -> Falso, pois não existe ninguém chamado elfo_domestico que está ligado aos predicados de elfo_domestico ou bruxo.
    6. feiticeiro(harry). -> Falso, pois não existe nenhum fato feiticeiro(harry) escrito.
    7. magico(feiticeiro). -> Falso, pois o nome feiticeiro não é um elfo_domestico nem um bruxo.
    8. magico('McGonagall'). -> True, pois existe um bruxo('McGonagall').
    9. magico(Hermione). -> O resultado da consulta são as unificações que a variavel Hermione pode fazer.
    Fazer a arvore de busca de magico(Hermione). no papel.
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
    Minigramática

    10. Consulta: sentenca(A,B,C,D,E).

    A unifica com D

    11 - Lista de sentenças:

        uma pessoa come
*/

palavra(artigo, uma).
palavra(artigo, qualquer).
palavra(nome, pessoa).
palavra(nome, 'sopa de legumes').
palavra(verbo, come).
palavra(verbo, adora).

sentenca(Palavra1, Palavra2, Palavra3, Palavra4, Palavra5) :-
    palavra(artigo, Palavra1),
    palavra(nome, Palavra2),
    palavra(verbo, Palavra3),
    palavra(artigo, Palavra4),
    palavra(nome, Palavra5).
