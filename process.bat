win_bison -d calc.y
rename calc.tab.h calc.h
rename  calc.tab.c calc.y.c
win_flex calc.l
rename  lex.yy.c calc.lex.c
gcc -c calc.lex.c -o calc.lex.o
gcc -c calc.y.c -o calc.y.o
gcc -c arbre.c -o arbre.o
gcc -o calc calc.lex.o calc.y.o arbre.o

