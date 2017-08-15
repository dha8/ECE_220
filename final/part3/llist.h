
typedef struct node_t 
{
    int data;
    struct node_t *next;
} node;

int remove_negative_nodes_rec(node **head);
int get_node_count_rec(node *head);

