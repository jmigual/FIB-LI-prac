len([], 0).
len([_|L], N) :- len(L, N1), N is N1 + 1.
