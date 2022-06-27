%   Predicado concatena
concatena([], Ys, Ys).
concatena([X|Xs], Y, [X|Zs]) :-
    concatena(Xs, Y, Zs).

/*
    Ex. 2:
*/
traducao(uno, um).
traducao(due, dois ).
traducao(tre, tres ).
traducao(quattro, quatro).
traducao(cinque, cinco ).
traducao(sei , seis ).
traducao(sette, sete ).
traducao(otto, oito ).
traducao(nove, nove).

traduz_lista([], []).
traduz_lista([X|Xs], [Y|Ys]) :-
    traducao(X, Y),
    traduz_lista(Xs, Ys).

/*
    Ex. 3:
*/
tres_vezes([], []).
tres_vezes([X|Xs], [X, X, X|Ys]) :-
    tres_vezes(Xs, Ys).

/*
    Ex. 4:
*/
intercala1([], [], []).
intercala1([X|Xs], [Y|Ys], [X, Y|Zs]) :-
    intercala1(Xs, Ys, Zs).

/*
    Ex. 5:
*/
intercala2([], [], []).
intercala2([X|Xs], [Y|Ys], [[X, Y]|Zs]) :-
    intercala2(Xs, Ys, Zs).

/*
    Ex. 6:
*/
intercala3([], [], []).
intercala3([X|Xs], [Y|Ys], [junta(X, Y)|Zs]) :-
    intercala3(Xs, Ys, Zs).

/*
    Ex. 7:
*/
membro(X, [X|_]).
membro(X, [_|Ys]) :-
    membro(X, Ys).

subconjunto([], _).
subconjunto([X|Xs], [Y|Ys]) :-
    membro(X, [Y|Ys]),
    subconjunto(Xs, [Y|Ys]).

/*
    Ex. 8:
*/
superconjunto([X|Xs], Y) :-
    subconjunto(Y, [X|Xs]).

/*
    Ex. 9:
*/
duplicada(X) :-
    concatena(Y, Y, X).     

/*
    Ex. 10:
*/
palindromo([_]).
palindromo([X|Xs]) :-
    concatena(Y, [X], Xs),
    palindromo(Y).

/*
    Ex. 11:
*/
digitosConcatena(0, []).
digitosConcatena(Num, X) :-
    Resto is mod(Num, 10),
    Quociente is div(Num, 10),
    concatena(Y, [Resto], X),
    digitosConcatena(Quociente, Y).

% ou usando acumulador
digitosAcum(0, Acum, Acum) :- !.
digitosAcum(Num, Acum, X) :-
    Resto is mod(Num, 10),
    Quociente is div(Num, 10),
    digitosAcum(Quociente, [Resto|Acum], X).

digitos(Num, X) :- digitosAcum(Num, [], X).

/*
    Ex. 12:
*/
palavras(0, zero).
palavras(1, um).
palavras(2, dois).
palavras(3, tres).
palavras(4, quatro).
palavras(5, cinco).
palavras(6, seis).
palavras(7, sete).
palavras(8, oito).
palavras(9, nove).

aux([X], [Y]) :- palavras(X, Y).
aux([X|Xs], [Y|Ys]) :-
    palavras(X, Y),
    aux(Xs, Ys).

digito_em_palavras(Num, X) :-
    digitos(Num, Y),
    aux(Y, X).

/*
    Ex. 13:
    Lembrar que 0 no MSB significa nada. Ou seja [0, 1, 1, 1, 1, 0, 1, 1] = [1, 1, 1, 1, 0, 1, 1].
*/
dec_para_bin_acum(0, Acum, [0|Acum]) :- !.
dec_para_bin_acum(Num, Acum, X) :-
    Resto is mod(Num, 2),
    Quociente is div(Num, 2),
    dec_para_bin_acum(Quociente, [Resto|Acum], X).

dec_para_bin(Num, X) :- dec_para_bin_acum(Num, [], X).

/*
    Ex. 14:
*/
bin_para_dec_acum([], Acum, Acum).
bin_para_dec_acum([X|Xs], Acum, Num) :-
    Acum2 is Acum * 2,
    Acum3 is Acum2 + X,
    bin_para_dec_acum(Xs, Acum3, Num).

bin_para_dec(X, Num) :- bin_para_dec_acum(X, 0, Num).

/*
    Ex. 15:
    Tem que possuir um caso caso a head seja impar se nao o programa da falso diretamente.
*/
pares([], []).
pares([X|Xs], [X|Ys]) :-
    N is mod(X, 2),
    N =:= 0,
    pares(Xs, Ys).
pares([X|Xs], Y) :-
    N is mod(X, 2),
    N =\= 0,
    pares(Xs, Y).

/*
    Ex. 16:
*/
multiEsc(_, [], []).
multiEsc(Num, [X|Xs], [Y|Resultado]) :-
    Y is Num * X,
    multiEsc(Num, Xs, Resultado).

/*
    Ex. 17:
*/
prodEsc([], [], 0).
prodEsc([X|Xs], [Y|Ys], Resultado) :-
    Z is X * Y,
    prodEsc(Xs, Ys, ResultadoNovo),
    Resultado is Z + ResultadoNovo.

/*
    Ex. 18:
    Caso base é quando o elemento da cabeça e o escolhido são iguais.
*/
remove(Elemento, [Elemento|Xs], Xs).
remove(Elemento, [X|Xs], [X|Ys]) :-
    remove(Elemento, Xs, Ys).

/*
    Ex. 19:
*/
insere(Elemento, X, Y) :-
    remove(Elemento, Y, X).

% ========================================================================================== %

permutacao([], []).
permutacao(Y, [X|Xs]) :-
    remove(X, Y, Res),
    permutacao(Res, Xs).

/*
    20. a) ?- permutacao([a,m,o,r], X).
        b) ?- permutacao([carlos, rose, sergio, adriano, fabiola], X).

        Fazer essas consultas no swipl, as unificações a X são grandes.

    Ex. 21:
    Num de permutações é o fatorial da quantidade de elementos
*/
comprimento_lista_acum([], Acum, Acum).
comprimento_lista_acum([_|Xs], Acum, Tamanho) :-
    NovoAcum is Acum + 1,
    comprimento_lista_acum(Xs, NovoAcum, Tamanho).

comprimento_lista(X, Tamanho) :- comprimento_lista_acum(X, 0, Tamanho).

fatorial_acum(1, Acum, Acum) :- !.
fatorial_acum(Num, Acum, Resultado) :-
    AcumNovo is Acum * Num,
    N1 is Num - 1,
    fatorial_acum(N1, AcumNovo, Resultado).

fatorial(Num, Resultado) :- fatorial_acum(Num, 1, Resultado).

num_permutacoes([], 0).
num_permutacoes(X, Num) :-
    comprimento_lista(X, Tamanho),
    fatorial(Tamanho, Num).

% ========================================================================================== %

combinacao(0,_,[]).
combinacao(N, [X|Xs], [X|Ys]) :- 
    N > 0,
    N1 is N - 1,
    combinacao(N1,Xs,Ys).
combinacao(N, [_|Xs], Ys) :-
    N>0,
    combinacao(N,Xs,Ys).
/*
    22. a) ?- combinacao(5, [a1,a2,a3,a4,a5,a6,a7,a8,a9,a10], Resultado).
    b) ??????

    Ex. 23:
    m!/(m - p)!p!
*/
num_combinacoes([], _, 0).
num_combinacoes(X, P, Num) :-
    comprimento_lista(X, Tamanho),
    fatorial(Tamanho, FatM),
    fatorial(P, FatP),
    Subtr is Tamanho - P,
    fatorial(Subtr, FatSubtr),
    Num is FatM / (FatSubtr * FatP).

% ========================================================================================== %

/*
    Ex. 24:
*/
