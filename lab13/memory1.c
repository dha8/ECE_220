#include<stdio.h>
#include<stdlib.h>
#include<string.h>
 
int main()
{
    char *p = malloc(sizeof(char)*11);
    // Assign some value to p
    // p = "hello";this will actually make p point to new literal
    strncpy(p,"hello",5);
 
    char *name = malloc(sizeof(char)*11);
    // Assign some value to name
    strncpy(name,"Bye",3);
 
    memcpy(p,name,sizeof(char)*11); // Problem begins here

    free(p);
    free(name); 
    return 0;
}


