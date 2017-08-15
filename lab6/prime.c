#include "prime.h"

int is_prime(int n) 
{
    if(n==1) return 0;
    /* Return 1 if prime, or 0 otherwise */
    for(int i=1;i<=n;i++){
	if(i==n) return 1;
        if(n%i == 0){
		    if(i==1) continue;
            else return 0;
	    }
    }    
    return 1;
}

