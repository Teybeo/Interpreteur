%{
#include "arbre.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern FILE * yyin;
%}

%union {
	struct Node *node; 
}

// L'ordre ici affecte les valeurs affectées au constantes
%token	 NOMBRE VARIABLE 
%token   PLUS  MOINS  MULT  DIVISION AFFECTATION 
%token   SUPERIOR INFERIOR  DIFFERENT SUPERIOR_EQUAL INFERIOR_EQUAL EQUAL 
%token 	 TEST MULTITEST
%token   PARENTHESE_GAUCHE PARENTHESE_DROITE PUISSANCE
%token   FIN

%type   <node> NOMBRE
%type   <node> Expression
%type 	<node> PLUS
%type 	<node> MOINS
%type 	<node> MULT
%type 	<node> DIVISION
%type 	<node> EQUAL
%type 	<node> SUPERIOR
%type 	<node> INFERIOR
%type 	<node> DIFFERENT
%type 	<node> SUPERIOR_EQUAL
%type 	<node> INFERIOR_EQUAL
%type 	<node> TEST
%type 	<node> Ligne
%type 	<node> MULTITEST
%type	<node> AFFECTATION
%type   <node> VARIABLE

%left PLUS  MOINS
%left MULT  DIVISION
%left NEG
%right  PUISSANCE

%start Input
%%

Input:
	/* Vide */ 
  | Input Ligne { eval($2); }
  ;

Ligne:
	//FIN				{ YYACCEPT; }
   Expression FIN    { $$ = $1; /*eval($1);*/ }
  | TEST Expression FIN Ligne { $$ = set_children($1, $2, $4); }
  | VARIABLE AFFECTATION Expression FIN { $$ = set_children($2, $1, $3); /*eval($2);*/ }
  ;

/* Une expression représente une valeur, cela peut être:
	Un nombre littéral
	Une variable
	Le résultat d'un calcul
	Le résultat d'une comparaison
*/
Expression:
	NOMBRE      { $$=$1; }
  | VARIABLE { $$ = $1;}
  | Expression PLUS 		      Expression  { $$= set_children($2, $1, $3); }
  | Expression MOINS 		      Expression  { $$= set_children($2, $1, $3); }
  | Expression MULT 		      Expression  { $$= set_children($2, $1, $3); }
  | Expression DIVISION		      Expression  { $$= set_children($2, $1, $3); }
  | Expression EQUAL 		      Expression  { $$= set_children($2, $1, $3); }
  | Expression SUPERIOR 	      Expression  { $$= set_children($2, $1, $3); }
  | Expression INFERIOR 	      Expression  { $$= set_children($2, $1, $3); }
  | Expression DIFFERENT  	 	  Expression  { $$= set_children($2, $1, $3); }
  | Expression SUPERIOR_EQUAL 	  Expression  { $$= set_children($2, $1, $3); }
  | Expression INFERIOR_EQUAL 	  Expression  { $$= set_children($2, $1, $3); }
  //| MOINS Expression %prec NEG  { $$=-$2; }
  //| Expression PUISSANCE Expression { $$=pow($1,$3); }
  //| PARENTHESE_GAUCHE Expression PARENTHESE_DROITE  { $$=$2; }
  ;

%%

int yyerror(char *s) {
  printf("yyerror: %s\n",s);
}

int main() {

	yyin = fopen("source.txt", "r");

	yyparse();
}