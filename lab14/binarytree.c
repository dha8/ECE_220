/**********************
 *  * binarytree.c:
 *   ***********************/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "binarytree.h"

BTREE new_node()
{
    return ((BTREE)malloc(sizeof(NODE)));
}

BTREE init_node(DATA d1, BTREE p1, BTREE p2)
{
    BTREE t;

    t = new_node();
    t->d = d1;
    t->left = p1;
    t->right = p2;

    return t;
}

/* create a linked binary tree from an array */
BTREE create_tree(DATA a[], int i, int size)
{
    if (i >= size)
        return NULL;
    else
        return(init_node(a[i],

    create_tree(a, 2*i+1, size),
    create_tree(a, 2*i+2, size)));
}

/* preorder traversal */
void preorder (BTREE root)
{
    if(root == NULL) return;
    printf("%c ",root->d);
    preorder(root->left);
    preorder(root->right);
}

/* Inorder traversal */
void inorder (BTREE root)
{
/* your code goes here */
    if(root == NULL) return;
    inorder(root->left);
    printf("%c ",root->d);
    inorder(root->right);
}

/* postorder binary tree traversal */
void postorder (BTREE root)
{
 /* your code goes here */
    if(root == NULL) return;
    postorder(root->left);
    postorder(root->right);
    printf("%c ",root->d);
}

