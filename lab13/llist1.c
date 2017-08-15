#include <stdio.h>
#include <stdlib.h>


typedef struct node_t
{
    int data;
    struct node_t *next;
} node;

void remove_duplicates(node * head);


// Fucnction to append nodes to the Linked list.
void append(node **head,int data)
{   
		
    node *temp,*n;

    temp = (node *)malloc(sizeof(node));
    temp->data=data;
    temp->next=NULL;

    n = *head;

    if(*head==NULL)
    {   
        *head=temp;
    }
    else
    {  
        while(n->next !=NULL)
	{  
	    n=n->next;
	}
	
	n->next=temp;
    }
}


void printList(node *head)
{
    node *n = head;
 
    while(n != NULL)
    {
	    printf("%d ",n->data);
	    n = n->next;
    }
    printf("\n");
}


int main()
{
    node* head = NULL;

    append(&head,10);
    append(&head,10);
    append(&head,20);
    append(&head,30);
    append(&head,30);
    append(&head,30);
    append(&head,40);
    append(&head,50);
    append(&head,60);

    printf("Before:\n");
    printList(head);

    remove_duplicates(head);
    
    printf("After:\n");
    printList(head);

    //free linked list here
    while(head!=NULL){
        node * temp = head->next;
        free(head);
        head = temp;
    }

    return 0;
}

void remove_duplicates(node * head)
{
    //fxn assumes that the list is pre-sorted 
    if(head==NULL) return;

    if(head->next!=NULL){
        if(head->next->data == head->data){
            node * temp = head->next;
            head->next = temp->next;
            free(temp);
        }
        remove_duplicates(head->next);
    }
}
