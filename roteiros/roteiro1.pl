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
    pai(X, Z),
    mae(Z, Y).

avoF(X, Y) :-
    mae(X, Z),
    pai(Z, Y);
    mae(X, Z),
    mae(Z, Y).

filho(X, Y) :-
    homem(X),
    pai(Y, X);
    homem(X),
    mae(Y, X).

filha(X, Y) :-
    mulher(X),
    pai(Y, X);
    mulher(X),
    mae(Y, X).

irmao(X, Y) :-
    homem(X),
    not(X = Y),
    pai(Pai, X),
    pai(Pai, Y).

irma(X, Y) :-
    mulher(X),
    not(X = Y),
    pai(Pai, X),
    pai(Pai, Y).

irmaos(X, Y) :- 
    not(X = Y),
    irmao(X, Y);
    irma(X, Y).

tio(X, Y) :-
    homem(X),
    pai(Pai, Y),
    irmaos(X, Pai).

tia(X, Y) :-
    mulher(X),
    mae(Mae, Y),
    irmaos(X, Mae);
    mulher(X),
    pai(Pai, Y),
    irmaos(X, Pai).

prima(X, Y) :-
    mulher(X),
    mae(MaeX, X),
    mae(MaeY, Y),
    irma(MaeX, MaeY).

primo(X, Y) :-
    homem(X),
    mae(MaeX, X),
    mae(MaeY, Y),
    irma(MaeX, MaeY).

/*
    Mundo do Harry Potter

    Consultas:

    5. magico(elfo_domestico). -> Falso, pois não existe ninguém chamado elfo_domestico que está ligado aos predicados de elfo_domestico ou bruxo.
    6. feiticeiro(harry). -> Falso, pois não existe nenhum fato feiticeiro(harry) escrito.
    7. magico(feiticeiro). -> Erro, pois o predicado feiticeiro não existe. Tratando esse erro, X unifica com feiticeiro mas não é um elfo_domestico nem um bruxo.
    8. magico('McGonagall'). -> True, pois existe um bruxo('McGonagall').
    9. magico(Hermione). -> O resultado da consulta são as unificações que a variavel Hermione pode fazer.
    
    Consulta: magico(Hermione).

    1ª - magico(Hermione) :- elfo_domestico(Hermione).
    Hermione unifica com dobby.
    2ª - magico(Hermione) :- feiticeiro(Hermione). 
    Hermione não unifica com nada, então não é valido essa regra para variavel Hermione.
    3ª - magico(Hermione) :- bruxo(Hermione).
    Hermione unifica com hermione
    Hermione unifica com 'McGonagall'
    Hermione unifica com rita_skeeter

    Fim.
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
    11. ???
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

/*
    Alunos
    12. Ok
    13. aluno(paulo, pl).
    14. aluno(rui, poo).
    15. aluno(paulo, ed1), aluno(maria, ed1).
    16. aluno(X, pl).
    17. aluno(rui, X).
    18. feito no fazDisciplina/2.
    19. A consulta quer unificar X com todos os alunos que estudam PL e estuda.
    20. cursapl/1
*/

aluno(paulo,poo).
aluno(pedro,poo).
aluno(maria,pl).
aluno(rui,pl).
aluno(manuel,pl).
aluno(pedro,pl).
aluno(rui,ed1).

estuda(paulo).
estuda(maria).
estuda(manuel).

fazDisciplina(X, Y) :-
    aluno(X, Y),
    estuda(X).

cursaPl(X) :-
    aluno(X, pl),
    estuda(X).