padre(juan,pedro).
padre(maria,pedro).
hermano(pedro,vicente).
hermano(pedro,alvaro).

tio(X,Y) :- padre(X,Z), hermano(Z,Y).
