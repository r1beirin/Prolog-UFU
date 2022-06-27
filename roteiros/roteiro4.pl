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
