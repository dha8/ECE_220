#include <stdio.h>

/* IMPLEMENT ME: write function prototype here */
int FastExp(int a, int n, int m); //fxn prototype

/* ! DO NOT MODIFY MAIN() ! */
int main()
{
    int a, n, m;

    printf("Enter three positive numbers a n m: ");
    scanf("%d %d %d", &a, &n, &m);
    printf("%d^%d(mod %d) is %d\n", a, n, m, FastExp (a, n, m));

    return 0;
}


/*
 * FastExp(a, 0, m) is 1.
 * FastExp(a, 1, m) is a.
 * x = FastExp(a, n/2, m)
 * FastExp(a, n, m) is x2(mod m) if n is even
 * FastExp(a, n, m) is x2a(mod m) if n is odd
 */
int FastExp(int a, int n, int m)
{ 
 /* implement me */
 if(n == 0) return 1; // base case
 if(n == 1) return a;
 int x = FastExp(a, n/2, m);
 if(n%2==0) return (x*x)%m;
 if(n%2==1) return (x*x*a)%m;
 //if(n%2 == 0) return FastExp((FastExp(a,n/2,m),2),2,m); //case where n is even
 //if(n%2 == 1) return a*FastExp((FastExp(a,(n-1)/2,m),2),2,m); //case where n is odd
}

