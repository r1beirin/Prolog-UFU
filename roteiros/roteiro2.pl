/*
    Ex. 1. 
    a) Done
    b) Done
    c) true.
    d) true.
    e) acima(X, novelo).  => Tem que dar cupcake, hipopotamo2, hipopotamo1, maca e sorvete.
        X unifica com sorvete;
        X unifica com cupcake ;
        X unifica com hipopotamo2 ;
        X unifica com hipopotamo1 ;
        X unifica com maca ;
    f) acima(X, caneca). => Nenhum objeto está acima da caneca
        Prolog retorna false
    g) Done.
    h) abaixo(X, cupcake). =>  Tem que dar hipopotamo2, hipopotamo1, maca, sorvete, novelo, elefante, base e mesa.
        X unifica com hipopotamo2 ;
        X unifica com hipopotamo1 ;
        X unifica com maca ;
        X unifica com sorvete ;
        X unifica com novelo ;
        X unifica com elefante ;
        X unifica com base ;
        X unifica com mesa ;
    i) abaixo(X, lapis). => Tem que dar vidro e mesa.
        X unifica vidro ;
        X unifica mesa ;
*/

sobre(cupcake, hipopotamo2).
sobre(hipopotamo2, hipopotamo1).
sobre(hipopotamo1, maca).
sobre(maca, sorvete).
sobre(sorvete, novelo).
sobre(novelo, elefante).
sobre(elefante, base).
sobre(base, mesa).
sobre(lapis, vidro).
sobre(vidro, mesa).
sobre(caneca, mesa).

%   Caso base
acima(X, Y) :-
    sobre(X, Y).

acima(X, Y) :-
    sobre(X, Z),
    acima(Z, Y).

abaixo(X, Y) :-
    acima(Y, X).

/*
    Ex. 2. 
    a) Done
    b) Done
    c) Done
    d) Done
    e) Done
    f) subordinado(zero, tainha). => Prolog tem que dar true.
        Prolog: true
    g) subordinados(X, mironga). => Prolog tem que responder louise_lorota, tainha, cuca, ky, blips, quindim, roque, cosme, dentinho, platao e zero.
        X unifica com zero ;
        X unifica com platao ;
        X unifica com dentinho ;
        X unifica com cosme ;
        X unifica com roque ;
        X unifica com quindim ;
        X unifica com blips ;
        X unifica com ky ;
        X unifica com cuca ;
        X unifica com tainha ;
        X unifica com louise_lorota ;
*/

/*proximo_posto(soldado, taifeiro).
proximo_posto(taifeiro, cabo).
proximo_posto(cabo, terceiro_sargento).
proximo_posto(terceiro_sargento, segundo_sargento).
proximo_posto(segundo_sargento, primeiro_sargento).
proximo_posto(primeiro_sargento, subtenente).
proximo_posto(subtenente, aspirante).
proximo_posto(aspirante, segundo_tenente).
proximo_posto(segundo_tenente, primeiro_tenente).
proximo_posto(primeiro_tenente, capitao).
proximo_posto(capitao, major).
proximo_posto(major, tenente_coronel).
proximo_posto(tenente_coronel, coronel).
proximo_posto(coronel, general_brigada).
proximo_posto(general_brigada, general_divisao).*/

proximo_posto(soldado, cabo).
proximo_posto(cabo, sargento).
proximo_posto(sargento, tenente).
proximo_posto(tenente, capitao).
proximo_posto(capitao, major).
proximo_posto(major, general).

militar(zero, soldado).
militar(platao, soldado).
militar(dentinho, soldado).
militar(cosme, soldado).
militar(roque, soldado).
militar(quindim, soldado).
militar(blips, soldado).
militar(ky, cabo).
militar(cuca, sargento).
militar(tainha, sargento).
militar(louise_lorota, sargento).
militar(escovinha, tenente).
militar(mironga, tenente).
militar(durindana, capitao).
militar(peroba, major).
militar(dureza, general).

menor_patente(X, Y) :-
    proximo_posto(X, Y).

menor_patente(X, Y) :-
    proximo_posto(X, Z),
    menor_patente(Z, Y).

maior_patente(X, Y) :-
    menor_patente(Y, X).

subordinado(X, Y) :-
    militar(X, Patente1),
    militar(Y, Patente2),
    menor_patente(Patente1, Patente2).

/*
    Ex. 3.
        a) caminho(5, 10). => Tem que retornar true.
            Prolog retorna true.
        b) caminho(1, X). => Prolog tem que retornar 2.
            X unifica com 2 ;
        c) caminho(13, X). => Tem que retornar 14, 9, 10 (1) e 17, 18 (2).
            X unifica com 14 ;
            X unifica com 9 ;
            X unifica com 17 ;
            X unifica com 10 ;
            X unifica com 18 ;
*/

conectado(1,2).
conectado(3,4).
conectado(5,6).
conectado(7,8).
conectado(9,10).
conectado(12,13).
conectado(13,14).
conectado(15,16).
conectado(17,18).
conectado(19,20).
conectado(4,1).
conectado(6,3).
conectado(4,7).
conectado(6,11).
conectado(14,9).
conectado(11,15).
conectado(16,12).
conectado(14,17).
conectado(16,19).

caminho(X, Y) :-
    conectado(X, Y).

%   Ex: 5, 10
caminho(X, Y) :-
    %   Ex: 5, 6
    %   Logo 10 != 6 => Y != de algo.
    conectado(X, Z),
    caminho(Z, Y).

/*
    Ex. 4.
*/

deCarro(auckland,hamilton).
deCarro(hamilton,raglan).
deCarro(valmont,saarbruecken).
deCarro(valmont,metz).

deTrem(metz,frankfurt).
deTrem(saarbruecken,frankfurt).
deTrem(metz,paris).
deTrem(saarbruecken,paris).

deAviao(frankfurt,bangkok).
deAviao(frankfurt,singapore).
deAviao(paris,losAngeles).
deAviao(bangkok,auckland).
deAviao(losAngeles,auckland).

viagem(X, Y) :-
    deCarro(X, Y);
    deTrem(X, Y);
    deAviao(X, Y).

viagem(X, Y) :-
    deCarro(X, Z),
    viagem(Z, Y);
    deTrem(X, Z),
    viagem(Z, Y);
    deAviao(X, Z),
    viagem(Z, Y).