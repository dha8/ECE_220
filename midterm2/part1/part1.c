#include <stdio.h>

int function(int array[], int *n);

int main()
{
    int a, b=5;
    int array[5] = { 5, 4, 3, 2, 1 };

    a = function(array, &b);

    printf("a=%d, b=%d\n", a, b);

    return 0;
}

int function(int array[], int *n)
{
    /* terminal case */
    if (*n == 0) return 0;

    /* reduction case */
    *n = *n - 1;
    return array[*n] + function(array, n);
}


