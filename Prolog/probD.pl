cities([1,2,3,4,5]).

road(1,3, 1).
road(1,2, 10).
road(1,4, 20).
road(1,5, 10).
road(2,3, 25).
road(3,4, 12).

roadsVisited([X, Y], K, CitiesNotVisited) :-
	road(X, Y, K),
	member(X, CitiesNotVisited), \+member(Y, CitiesNotVisited).
roadsVisited([X, Y], K, CitiesNotVisited) :-
	road(X, Y, K),
	\+member(X, CitiesNotVisited), member(Y, CitiesNotVisited).

backtrack(_, [], []).
backtrack(CurrentK, CitiesNotVisited, Roads) :-
	roadsVisited([X, Y], K, CitiesNotVisited),
	subtract(CitiesNotVisited, [X,Y], C1),
	K2 is CurrentK - K,
	K2 >= 0,
	backtrack(K2, C1, R1),
	Roads = [[X,Y]|R1].


mainroads(K, M) :-
	cities([_|C]),
	backtrack(K, C, M),
	!.

main :-
	mainroads(40, M),
	writeln(M).
