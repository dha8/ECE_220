#include <stdio.h>
 
int main()
{
    double iray[5];
    double* ipoint = &iray[0];
 
    for(int i = 0; i < 5; i++)
    {
        *ipoint = i;
        printf("%p\n", ipoint);
        ipoint = ipoint + 1;
    }
 
    for(int i = 0; i < 5; i++)
    {
        printf("%d\n", iray[i]);
    }
    return 0;
}

