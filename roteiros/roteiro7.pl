%   Ex 4.
/*s(C) :- sn(A), sv(B), append(A,B,C).
sn(C) :- det(A), n(B), append(A,B,C).
sv(C) :- v(A), sn(B), append(A,B,C).
sv(C) :- v(C).

det([o]).
det([a]).
n([homem]).
n([mulher]).
n([bola]).
v([chuta]).*/

%   Ex 5.
/*s(A-C) :- sn(A-B), sv(B-C).
sn(A-C) :- det(A-B), n(B-C).
sv(A-C) :- v(A-B), sn(B-C).
sv(A-B) :- v(A-B).

det([o|P]-P).
det([a|P]-P).
n([homem|P]-P).
n([mulher|P]-P).
n([bola|P]-P).
v([chuta|P]-P). */

%   Ex 6.
s --> sn, sv.
sn --> det, n.
sv --> v, sn.
sv --> v.

det --> [o].
det --> [a].
n--> [homem].
n--> [mulher].
n --> [bola].
v--> [chuta].

%   Ex 8.

ap --> [].
ap --> a, ap, a.

a --> [a].

%   Ex 10.
%   ?- ess(X - []). 
ess(A-D) :-
    foo(A-B),
    bar(B-C),
    wiggle(C-D).

foo([chu|P]-P).

foo(A-C) :-
    foo(A-B),
    foo(B-C).

bar(A-C) :-
    mar(A-B),
    zar(B-C).

mar(A-C) :-
    me(A-B),
    my(B-C).

me([eu|P]-P).
my([sou|P]-P).

zar(A-C) :-
    blar(A-B),
    car(B-C).

blar([um|P]-P).
car([trem|P]-P).
wiggle([tchu|P]-P).

wiggle(A-C) :-
    wiggle(A-B),
    wiggle(B-C).

%   Ex 11.
ab --> a, b.
ab --> a, ab, b.

a --> [a].
b --> [b].

%   Ex 12.

abb --> [].
abb --> a, abb, b, b.

a --> [a].
b --> [b].