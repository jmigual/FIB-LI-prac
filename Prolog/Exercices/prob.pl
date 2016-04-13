nat(0).
nat(N) :- 
  nat(N1),
  N is N1 + 1.
  
concat([], L2, L2) :- !.
concat([X|L1], L2, [X|L3]) :- concat(L1, L2, L3).

pert_con_resto(X,L,Resto):- 
  concat(L1,[X|L2], L ),
  concat(L1, L2, Resto).
  
long([],0). % longitud de una lista
long([_|L],M):- long(L,N), M is N+1.

factores_primos(1,[]) :- !.
factores_primos(N,[F|L]):- 
  nat(F), 
  F>1, 0 is N mod F,
  N1 is N // F, 
  factores_primos(N1,L),!.
  
permutacion([],[]).
permutacion(L,[X|P]) :- 
  pert_con_resto(X,L,R), 
  permutacion(R,P).
  
subcjto([],[]). %subcjto(L,S) es: "S es un subconjunto de L".
subcjto([X|C],[X|S]):-subcjto(C,S).
subcjto([_|C],S):-subcjto(C,S).

% Exercici 2
prod([], 1).
prod([X|L], P) :-
  prod(L, P1),
  P is X*P1.
  
% Exercici 3
pescalar([], [], 0):- !.
pescalar([], _, 0) :- fail.
pescalar(_, [], 0) :- fail.
pescalar([X|L1],[Y|L2], R) :-
  pescalar(L1, L2, R1),
  R is X*Y + R1.
  
% Exercici 4
union([], L2, L2) :- !.
union([X| L1], L2, L3) :- 
  member(X, L2), 
  !,
  union(L1, L2, L3).
union([X| L1], L2, [X | L3]) :- union(L1, L2, L3).
  
intersec([], _, []) :- !.
intersec([X| L1], L2, L3) :-
  member(X, L2),
  !,
  intersec(L1, L2, L4),
  L3 = [X | L4].
intersec([_| L1], L2, L3) :- intersec(L1, L2, L3).

% Exercici 5
last(L, X) :- concat(_, [X], L).

reverse([], []) :- !.
reverse([X|L], Lr) :- 
  reverse(L, Lr2),
  concat(Lr2, [X], Lr).
  
% Exercici 6
fib(0, 1) :- !.
fib(1, 1) :- !.
fib(N, F) :- 
  N < 0,
  !,
  F = 0.
fib(N, F) :-
  N1 is N-1,
  N2 is N-2,
  fib(N1, F1),
  fib(N2, F2),
  F is F1+F2.
  
% Exercici 7
list_sum([], 0) :- !.
list_sum([X], X).
list_sum([X, Y | L], T) :- 
  S is X+Y,
  list_sum([S|L], T).    
  
isAllB([], _, _) :- !.
isAllB([X |L], A, B) :-
  between(A, B, X),
  isAllB(L, A, B).
 
daus(P, N, L) :- 
  length(L, N),
  isAllB(L, 1, 6),
  list_sum(L, P).
  
% Exercici 8
concat3([], L2,L3,L4) :- concat(L2,L3,L4).
concat3([X|L1], L2, L3, [X|L4]) :- concat3(L1,L2,L3,L4).

suma_demas(L) :-
  list_sum(L, S),
  S2 is S/2,
  member(X,L),
  %concat3(L1, [X], L2, L),
  %list_sum(L1, S1),
  %list_sum(L2, S2),
  %S3 is S1 + S2,
  X == S2,
  !.

% Exercici 9
suma_ants_aux([X|_], S) :-
  X == S,
  !.
suma_ants_aux([X|L], S) :- 
  S1 is S + X,
  suma_ants_aux(L, S1).

suma_ants(L) :- suma_ants_aux(L, 0).

% Exercici 10
count(_, [], 0) :- !.
count(X, [X|L], N) :-
  !,
  count(X, L, N1),
  N is 1 + N1.
  
count(X, [_|L], N) :- count(X, L, N).

count_card([], _, []) :- !.
count_card([X|S1], L1, L2) :-
  count(X, L1, N),
  count_card(S1, L1, L3),
  concat([[X,N]], L3, L2).
  
card(L1, L2) :-
  list_to_set(L1,S),
  count_card(S, L1, L2).
  
% Exercici 11
esta_ordenada([]) :- !.
esta_ordenada([_]) :- !.
esta_ordenada([X,Y|L]) :-
  X =< Y,
  !,
  esta_ordenada([Y|L]).  