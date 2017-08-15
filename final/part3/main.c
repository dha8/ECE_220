#include <stdio.h>
#include <stdlib.h>
#include "llist.h"

int main ()
{
    int i, n, val, removed;
    node *head=NULL;
    node *current = NULL;

    printf ("How many elements in the linked list? ");
    scanf ("%d", &n);

    printf("Enter linked list:\n");
    for (i = 0; i < n; i++)
    {
        printf ("Enter %dth element: ", i);
        scanf ("%d", &val);
        
        if (i == 0)
        {
            head = malloc(sizeof(node));
            current = head;
        }
        else
        {
            current->next = malloc(sizeof(node));
            current = current->next;
        }
        
        current->data = val;
        current->next = NULL;  
    }

    printf("\nList contains %d nodes with data values larger than their previous node's value\n", get_node_count_rec(head));

    /* print list before */
    printf("Original list: ");
    current = head;
    while (current != NULL)
    {
        printf("%d ", current->data);
        current = current->next;
    }

    removed = remove_negative_nodes_rec(&head);

    /* print list after */
    printf("\nModified list: ");    
    current = head;
    while (current != NULL)
    {
        printf("%d ", current->data);
        current = current->next;
    }

    printf("\n%d nodes were removed\n", removed);

    return 0;
}

