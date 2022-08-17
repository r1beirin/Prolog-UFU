%   Ex. 4
s --> sn(sujeito, Num), sv(Num).

sn(_, Num) --> det(Num), n(sujeito, Num).

sv(Num) --> v(Num), sn(_, Num).
sv(Num) --> v(Num).

det(singular) --> [o].
det(plural) --> [os].
det(singular) --> [a].

n(sujeito, singular) --> [mulher].
n(sujeito, singular) --> [homem].
n(sujeito, plural) --> [homens]

v(singular) --> [bate].
v(plural) --> [batem].

%   Ex 5.
cangu(V,R,Q,A,C) :-
    ru(V,R,A,B),
    salta(Q,Q, B, C),
    marsupial(V,R,Q).