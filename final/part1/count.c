#include <stdlib.h>

struct s_node {
    int value;
    struct s_node *left;
    struct s_node *right;
};

typedef struct s_node node;

int CountNodes(node *nd, int parent_value);

int CountNodes(node *nd, int parent_value)
{
    int count = 0;

    if (nd == NULL) return 0;

    if (nd->value > parent_value) count = 1;

    count += CountNodes(nd->left, nd->value);
    count += CountNodes(nd->right, nd->value);

    return count;
}

