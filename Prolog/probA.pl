nat(0).
nat(N) :- nat(N1), N is N1+1 .

%%%%%%%%% AGUA %%%%%%%%%%%%
% Omplir o buidar
unPasoAgua([_, Y], [5, Y]).
unPasoAgua([_, Y], [0, Y]).
unPasoAgua([X, _], [X, 0]).
unPasoAgua([X, _], [X, 8]).
% Moure sense desbordament
% Moure Y -> X
unPasoAgua([X, Y], [X1, Y1]) :- 
  X1 is min(5, Y+X),
  Y1 is max(0, Y-X1+X).
% Moure X -> Y
unPasoAgua([X, Y], [X1, Y1]) :-
  Y1 is min(8, Y+X),
  X1 is max(0, X-Y1+Y).  
  
% Backtracking
caminoAgua(E,E, C,C).
caminoAgua(EActual, EFinal, CHastaAhora, CTotal) :-
  unPasoAgua(EActual, ESiguiente),
  \+member(ESiguiente, CHastaAhora),
  caminoAgua(ESiguiente, EFinal, [ESiguiente | CHastaAhora ], CTotal).
  
hacerAguas :-
  nat(N),
  caminoAgua([0,0],[0,4],[[0,0]],C),
  length(C,N),
  write(C),
  !.

%%%%%%%% CABALLO %%%%%%%%%

posDisp([X,Y], N) :-
  N1 is N-1,
  between(0, N1, X),
  between(0, N1, Y).

unPasoCaballo(N, [X,Y], [X1,Y1]) :-
  XP1 is X + 1,
  XM1 is X - 1,
  YP2 is Y + 2,
  YM2 is Y - 2,
  member(X1, [XP1, XM1]),
  member(Y1, [YP2, YM2]),
  posDisp([X1, Y1], N).

unPasoCaballo(N, [X,Y], [X1,Y1]) :-
  XP2 is X + 2,
  XM2 is X - 2,
  YP1 is Y + 1,
  YM1 is Y - 1,
  member(X1, [XP2, XM2]),
  member(Y1, [YP1, YM1]),
  posDisp([X1, Y1], N).

caminoCaballo(_, E,E,C,C, 0).
caminoCaballo(N, EActual, EFinal, CHastaAhora, CTotal, P) :-
  unPasoCaballo(N, EActual, ESiguiente),
  \+member(ESiguiente, CHastaAhora),
  P1 is P-1,
  P1 >= 0,
  caminoCaballo(N, ESiguiente, EFinal, [ESiguiente | CHastaAhora], CTotal, P1).

caballo(N, PosInicial, PosFinal, P) :-
  caminoCaballo(N, PosInicial, PosFinal, [PosInicial], C, P),
  write(C),
  !.
  