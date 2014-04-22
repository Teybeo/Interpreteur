#ifndef _GUARD_ARBRE
#define _GUARD_ARBRE

#include <stdlib.h>

typedef struct Node_var {
	
	char* name;
	float value;
	struct Node_var* next;
	
} Node_var;

typedef struct Node { 

	int type;
	union {
		double val;
		Node_var* var; 
		struct Node** children;
	};
	int nb_children;
	
} Node;

extern Node_var* list_var;

Node* set_children(Node* parent, Node* child_1, Node* child_2);
void display_tree(Node* root, int level);
Node* create_node(int type);
void eval(Node* root);

#endif