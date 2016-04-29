#file = sudoku
file = horari

$(file): $(file).pl
	swipl -quiet -O -g main --stand_alone=true -o $(file).exe -c $(file).pl
	./$(file).exe
