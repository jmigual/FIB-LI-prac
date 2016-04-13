solve(L) :- 
  caminoPuzzle(L, [], [], C),
  writeln(C).

prova([[4,1],[4,2],[5,2],[5,3]]).

canMove([X, Y], [X2, Y2], L, [[X2,Y2] | Lout]) :-
  X1 is (X + X2)/2,
  Y1 is (Y + Y2)/2,
  member([X1,Y1], L),
  delete(L, [X1,Y1], Lout).
  

pasoPuzzle([X, Y], [X1, Y1]) :-
  XP is X + 2,
  XM is X - 2,
  YP is Y + 2,
  YM is Y - 2,
  member([X1,Y1],[[XP,Y],[XM,Y],[X,YP],[X,YM],[XP,YP],[XM,YM]]),
  between(1, 5, Y1),
  Yaux is 6 - Y1,
  between(1, Yaux, X1).

unPasoPuzzle(EA, Lout) :-
  member(X, EA),
  delete(EA, X, L),
  pasoPuzzle(X, Xout),
  canMove(X, Xout, L, Lout).
  

caminoPuzzle(E,E,C,C).
caminoPuzzle(EActual, EFinal, CHastaAhora, CTotal) :-
  writeln(EActual),
  unPasoPuzzle(EActual, ESiguiente),
  \+member(ESiguiente, CHastaAhora),
  caminoPuzzle(ESiguiente, EFinal, [ESiguiente | CHastaAhora], CTotal).