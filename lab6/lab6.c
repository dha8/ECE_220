#include <stdio.h>
#include "prime.h"

int main() 
{
    /* Write the code to take a number n from user and print all the prime numbers between 1 and n. */
    int n = 0;
    printf("Enter the value of n: ");
    scanf("%i",&n);
    printf("printing primes less than or equal to %i:\n",n);
    for(int i=1;i<=n;++i){
	    if(is_prime(i))
            printf("%i, ",i);
    }
    printf("\n");
    return 0;
}

