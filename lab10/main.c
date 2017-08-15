#include <stdlib.h>
#include <stdio.h>
#include "verify.h"

/*  You only need to write code in backtracking. Don't change others.   */
/*  The gold solution will be stored in gold_output.txt                 */
/*  Your output will be stored in my_output.txt                         */

unsigned int N;
void backtracking( unsigned int index, int chosen[], unsigned int permutation[] ); 
void verify_output( int* chosen , unsigned int* permutation );

/* Don't modify main function */
int main()
{
	int i;

	// assume N is between 1 - 7
	printf("Input a number between 1 - 7 : ");
	scanf("%d", &N );
	if( N < 1 || N > 7 ){
		printf("Invalid Input!\n");
		return 0;
	}

	int chosen[N];
	unsigned int permutation[N];

	for( i = 0 ; i < N ; i ++ ) {
		chosen[i] = 0;
		permutation[i] = 0;
	}

	verify_output( chosen , permutation );
	return 0;
}


/* This is used to verify your output with gold solution, don't modify it */
void verify_output( int* chosen , unsigned int *permutation )
{
	freopen ("my_output.txt","w",stdout);
	backtracking( 0 ,  chosen , permutation );
	fclose (stdout);

	unsigned int i;
	for( i = 0 ; i < N ; i ++ ) {
		chosen[i] = 0;
		permutation[i] = 0;
	}

	freopen ("gold_output.txt","w",stdout);
	backtracking_gold( 0 ,  chosen , permutation );
	fclose (stdout);
}


/*  
 *  index  : position in permutation
 *  chosen : an array which indicates the corresponding number has been selected or not. 
 *			 If chosen[i] = 0, (i+1) is not selected
 *			 If chosen[i] = 1, (i+1) has been selected
 *	permutation : a 1-D array holds partial permutation  
*/

//Note: called on top of each other for 1 position each
void backtracking( unsigned int index, int chosen[], unsigned int permutation[]  )    
{

	if ( index == N )
        {        
		/* If a permutation is enumerated, use print_permutation to print it. Don't modify this */
		print_permutation( permutation );
	}
	else //build a permutation
        {
		//find an unused value
		for(int i=0;i<N;++i){
			if(chosen[i] == 0){
				permutation[index] = i+1; //assign unused value to that index
				chosen[i] = 1; // mark the value used
				//when passing onto next index, each call must have its own array.
				backtracking(index+1, chosen, permutation);// move onto next index
				chosen[i] = 0;
			}
		}
	}
	
}






