% Numero nutrientes
numNutrients(8).

% Productos
product(milk,       [2,4,6] ).
product(meat,       [1,8]   ).
product(vegetables, [2,3,4] ).
product(rice,       [5,6,7] ).

nutrients(1, [1]).
nutrients(N, [N | L1]) :- N1 is N - 1, nutrients(N1, L1), !.

nutrient(N1, L) :-
    member(X, L),
    product(X, Y),
    member(N1, Y).

isValid(L1, L2) :-
    member(X, L1),
    nutrient(X, L2).

shoppingL(L, Lout) :-
    product(A, B),
    \+member(A, Lout),
    shopping(L, [A|Lout])
    .
    
shopping(K, L) :-
    numNutrients(N),
    nutrients(N, L1),
    shoppingL(L1, L),
    length(L, C),
    between(1, K, C),
    !.
    
    