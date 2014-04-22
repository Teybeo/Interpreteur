%option noyywrap
%{

#include "arbre.h"
#include "calc.h"
#include <stdlib.h>

extern YYSTYPE yylval;

%}

blancs    [ \t]+

chiffre   [0-9]
entier    {chiffre}+
exposant  [eE][+-]?{entier}

reel    {entier}("."{entier})?{exposant}?

lettre  [_a-zA-Z]
identifiant {lettre}({lettre}|{chiffre})*

%%

{blancs}  { /* On ignore */ }

{reel}    {
	yylval.node = create_node(NOMBRE);
	return NOMBRE;
}

"SI" {
	yylval.node = create_node(TEST);
	return TEST;
}

{identifiant}    {
	yylval.node = create_node(VARIABLE);
	return(VARIABLE);
}

"+" {
	yylval.node = create_node(PLUS);
	return PLUS;
}

"-"  {
	yylval.node = create_node(MOINS);
	return MOINS;
}

"*" {
	yylval.node = create_node(MULT);
	return MULT;
}

"/"  {
	yylval.node = create_node(DIVISION);
	return DIVISION;
}

"!=" {
	yylval.node = create_node(DIFFERENT);
	return(DIFFERENT);
}

"==" {
	yylval.node = create_node(EQUAL);
	return(EQUAL);
}

"=" {
	yylval.node = create_node(AFFECTATION);
	return(AFFECTATION);
}

">" {
	yylval.node = create_node(SUPERIOR);
	return(SUPERIOR);
}

"<" {
	yylval.node = create_node(INFERIOR);
	return(INFERIOR);
}

">=" {
	yylval.node = create_node(SUPERIOR_EQUAL);
	return(SUPERIOR_EQUAL);
}

"<=" {
	yylval.node = create_node(INFERIOR_EQUAL);
	return(INFERIOR_EQUAL);
}

"^"   return(PUISSANCE);
"("   return(PARENTHESE_GAUCHE);
")"   return(PARENTHESE_DROITE);
"\n"  return(FIN);
