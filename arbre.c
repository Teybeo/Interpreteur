#include "arbre.h"
#include <stdlib.h>
#include <stdio.h>
#include "calc.h"

#define DECALE_TEXTE(nb) 			\
    for (_my_i=0; _my_i<nb ;_my_i++)\
        printf("    ");
		
extern char* yytext;
Node_var* list_var = NULL;
double evaluate(Node* root);
Node_var* create_var(char* name);
Node_var* search_var(char* name);
void set_var(Node_var* variable, Node* expression_src);
void push_var(Node_var* var);

void eval(Node* root) {

	display_tree(root, 0);
	putchar('\n');
	
	
	printf("Res: %f\n", evaluate(root));
}

double evaluate(Node* root) {
	
	if (root == NULL)
		return 1;
	
	if (root->type == AFFECTATION)
	{
		set_var(root->children[0]->var, root->children[1]);
		return evaluate(root->children[0]);
	}
	if (root->type == NOMBRE)
		return root->val;
	if (root->type == VARIABLE)
		return root->var->value;
	if (root->type == PLUS)
		return evaluate(root->children[0]) + evaluate(root->children[1]);
	if (root->type == MOINS)
		return evaluate(root->children[0]) - evaluate(root->children[1]);
	if (root->type == MULT)
		return evaluate(root->children[0]) * evaluate(root->children[1]);
	if (root->type == DIVISION)
		return evaluate(root->children[0]) / evaluate(root->children[1]);
	if (root->type == SUPERIOR)
		return (evaluate(root->children[0]) > evaluate(root->children[1]));
	if (root->type == INFERIOR)
		return (evaluate(root->children[0]) < evaluate(root->children[1]));
	if (root->type == EQUAL)
		return (evaluate(root->children[0]) == evaluate(root->children[1]));
	if (root->type == DIFFERENT)
		return (evaluate(root->children[0]) != evaluate(root->children[1]));
	if (root->type == SUPERIOR_EQUAL)
		return (evaluate(root->children[0]) >= evaluate(root->children[1]));
	if (root->type == INFERIOR_EQUAL)
		return (evaluate(root->children[0]) <= evaluate(root->children[1]));
	if (root->type == TEST)
	{
		// On évalue la valeur de la condition
		int condition = evaluate(root->children[0]);
		
		if (condition)
		{
			// Si vraie, on exécute chacune des lignes associées
			int j;
			for (j = 0; j < root->nb_children - 1; j++)
				evaluate(root->children[1 + j]);
		}
		
		return condition;
	}
	if (root->type == MULTITEST) {
		
		int i;
		for (i = 0; i < root->nb_children; i++) {
			if (evaluate(root->children[i]) == 1)
				return 0;
		}

	}
}

Node* create_node(int type) {

	Node* node = malloc(sizeof(Node));
	node->type = type;

	if (type == NOMBRE)
		node->val = atof(yytext);
	if (type == VARIABLE) {
		
		node->var = search_var(yytext);
		if (node->var == NULL) 
		{
			node->var = create_var((char*)_strdup(yytext));
			push_var(node->var);
		}
	}
	
	return node;
}

Node_var* search_var(char* name) {

	Node_var* tmp = list_var;
	
	while (tmp != NULL) {
		if (strcmp(tmp->name, name) == 0)
			return tmp;
		tmp = tmp->next;
	}

	return NULL;

}

void push_var(Node_var* var) {

	var->next = list_var;
	list_var = var;

}

Node_var* create_var(char* name) {

	Node_var* var = malloc(sizeof(Node_var));
	var->value = 0;
	var->name = name;
	var->next = NULL;
	
	return var;

}

void set_var(Node_var* variable, Node* expression_src) {

	variable->value = evaluate(expression_src);

}

Node* set_children(Node* parent, Node* child_1, Node* child_2) {

	parent->children = malloc(sizeof(Node) * 2);
	parent->children[0] = child_1;
	parent->children[1] = child_2;
	//display_tree(parent, 0);
//	puts("-------");
	return parent;
}

void display_tree(Node* root, int level) {

	char op_symbol[][4] = {
		"+ " ,
		"- " ,
		"* " ,
		"/ " ,
		"== ",
		"> " ,
		"< " ,
		"!= ",
		">= ",
		"<= ",
		"= "
	};
	
	if (root == NULL)
		return;
	
	
	int _my_i;
	
	switch (root->type)
	{
		case NOMBRE:
			DECALE_TEXTE(level)
			printf("%f\n", root->val);
			break;
		case VARIABLE:
			DECALE_TEXTE(level)
			printf("%s\n", root->var->name);
			break;
		case PLUS:
		case MOINS:
		case MULT:
		case DIVISION:
		case EQUAL:
		case SUPERIOR:
		case INFERIOR:
		case DIFFERENT:
		case SUPERIOR_EQUAL:
		case INFERIOR_EQUAL:
		case AFFECTATION:
			display_tree(root->children[0], level+1);
			DECALE_TEXTE(level)
			printf("%s\n", op_symbol[root->type - PLUS]);
			display_tree(root->children[1], level+1);
			break;
		default:
			puts("default node type");
			break;
	}
}