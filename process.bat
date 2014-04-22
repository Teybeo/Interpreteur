win_bison -d calc.y
rename calc.tab.h calc.h
rename  calc.tab.c calc.y.c
win_flex calc.l
rename  lex.yy.c calc.lex.c
gcc -g -c calc.lex.c -o calc.lex.o
gcc -g -c calc.y.c -o calc.y.o
gcc -g -c arbre.c -o arbre.o
gcc -g -o calc calc.lex.o calc.y.o arbre.o

