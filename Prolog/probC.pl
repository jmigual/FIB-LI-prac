% Numero nutrientes
numNutrients(8).

% Productos
product(milk,       [2,4,6] ).
product(meat,       [1,8]   ).
product(vegetables, [2,3,4] ).
product(rice,       [5,6,7] ).
product(energybar,  [1,2,3,4,5,6,7,8]).

nutrientsList(1, [1]).
nutrientsList(N, [N | L1]) :- N1 is N - 1, nutrientsList(N1, L1), !.

nutrient(N1, L) :-
    member(X, L),
    product(X, Y),
    member(N1, Y),
    !.

isValid([], _).
isValid([X | L1], L2) :- nutrient(X, L2), isValid(L1, L2).

allProducts([]).
allProducts(L) :-
    allProducts(L1),
    product(A, _),
    \+member(A, L1),
    L = [A|L1].

shoppingList(L, Lout) :- allProducts(Lout), isValid(L, Lout).
    
shopping(K, L) :-
    numNutrients(N),
    nutrientsList(N, L1),
    shoppingList(L1, L),
    length(L, C),
    between(1, K, C),
    !.
    
main :- 
    shopping(4, Lout),
    writeln(Lout).    