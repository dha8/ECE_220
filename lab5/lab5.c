/* compute a function */

#include <stdio.h>
#include <math.h>

int main()
{
    /* declarte variables */
	int n;
	float w1, w2;
    /* prompt user for input */
	printf("Enter n, w1, and w2(each followed by enter): \n");
    /* get user input */
	scanf("%i",&n);
	scanf("%f",&w1);
	scanf("%f",&w2);
    /* for i from 0 to n-1 */
	float x;
	for(int i=0;i<n;++i){
       /* compute and print xi and f(xi) */
		x = i*M_PI/(n-1);
       /* use sin() function from math.h */
		printf("%f	%f\n", x, sin(w1*x)+0.5*sin(w2*x));
	}
    /* exit the program */
    return 0;
}

