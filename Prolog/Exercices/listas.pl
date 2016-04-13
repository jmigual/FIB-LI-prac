pert(X,[X|_]).
pert(X,[_|L]):- pert(X,L).

concat([], L,L).
concat([X|L1], L2, [X|L3]):- concat(L1,L2,L3).

fact(0,1):- !.
fact(N,F) :-
  N1 is N-1,
  fact(N1,F1),
  F is F1 * N, !.

escfacts(K) :-  between(1,K, N), fact(N,F), write(F), nl, fail.
escfacts(_).

esccuadr(K) :-  between(1,K,N), F is N*N, write(F), nl, fail.
esccuadr(_).

main :- escfacts(7), esccuadr(8).

pert_con_resto(X,L,Resto) :-
  concat(L1, [X|L2], L),
  concat(L1, L2, Resto).
