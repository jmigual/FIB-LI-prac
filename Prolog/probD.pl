cities([1,2,3,4]).

road(1,2, 10).
road(1,4, 20).
road(2,3, 25).
road(3,4, 12).

allRoads([]).
allRoads(L) :-
	allRoads(L1),
	road(X, Y, _),
	\+member([X,Y], L1),
	L = [[X,Y] | L1].

roadsFromCity([], _, []).
roadsFromCity([X | L1], City, L) :-
	roadsFromCity(L1, City, L),
	\+member(City, X),
	!.
roadsFromCity([X|L1], City, L) :-
	roadsFromCity(L1, City, L2),
	member(City, X),
	L = [X | L2].

mainroads(K, M) :-
	cities(C),
	
	!.