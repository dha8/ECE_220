#include <stdlib.h>
#include "llist.h"


int get_node_count_rec(node *head)
{
    if(head == NULL || head->next == NULL) return 0;
	return (head->data < head->next->data ? 1: 0) + get_node_count_rec(head->next);
}

/*removes all negative nodes, returns # of deleted nodes*/
int remove_negative_nodes_rec(node **head)
{
   if(*head == NULL || head == NULL ) return 0;
   
   /*case where negative is found*/
   if((*head)->data < 0 ){
		node * temp = *head;
		*head = ((*head)->next);
		free(temp);
		return 1 + remove_negative_nodes_rec(head);
   }

   /*positive value found*/
   return remove_negative_nodes_rec(&(*head)->next);
}


