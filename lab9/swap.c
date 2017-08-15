#include <stdio.h>

/* provide swap function prototype here */
void swap (int* px, int* py);

int main()
{
    /* complete main function to demonstrate the use of swap */
	int a_ = 1;
	int b_ = 2;
	int * a = &a_;
	int * b = &b_;
	printf("a: %d\nb: %d\n",*a,*b);
	swap(a,b);
	printf("after swap:\na: %d\nb: %d\n",*a,*b);
}


void swap (int* px, int* py)
{
	int temp = *px; // gets the addr of mmr pointed by px
	*px = *py; // px now points to mmr pointed by py
	*py = temp; // py now points to temp.
}


