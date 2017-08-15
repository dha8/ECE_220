#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* function signature for getting V(N+1). Description and implementation in the 
 * bottommost section of the file.
 */
float getVnext(double omegaOne, double omegaTwo, double omegaC, double dt_, 
                double v_prev, double v_cur, int N);

// Do not modify anything. Write your code under the two if statements indicated below.
int main(int argc, char **argv)
{
	double omega1, omega2, omegac, T, dt;
	int N, method;
	FILE *in;

	int i;
	double Voutnew = 0, Voutcur = 0, Voutprev = 0;
        
	// Open the file and scan the input variables.
	if (argv[1] == NULL) {
		printf("You need an input file.\n");
		return -1;
	}

	in = fopen(argv[1], "r");

	if (in == NULL)
		return -1;

	fscanf(in, "%lf", &omega1);
	fscanf(in, "%lf", &omega2);
	fscanf(in, "%lf", &omegac);
	fscanf(in, "%d", &method);

	fclose(in);

	T = 3 * 2 * M_PI / omega1; 		// Total time
	N = 20 * T / (2 * M_PI / omega2); 	// Total number of time steps
	dt = T / N;				// Time step ("delta t")

	// Method number 1 corresponds to the finite difference method.
	if (method == 1) {
		// Write your code here!
        float v_p = 0.0; /*set v_previous to 0 by default*/
        float v_c = 0.0; /*set v_current to 0 by default*/
        float v_n = 0.0; /*initialize v_next to 0 by default*/

        /*
          now loop through N times, calculating V(next) each time and printing it.
          upon each calculation, v_prev gets updated with value of v_current, 
          and v_current gets updated with v_next.
        */
        for(int i=-1;i<N;i++){ 
            v_n = getVnext(omega1,omega2,omegac,dt,v_p,v_c,i);
            printf("%f\n",v_n);
            v_p = v_c;
            v_c = v_n;
        }
	}

	// Method number 2 corresponds to the Runge-Kutta method (only for challenge).
	else if (method == 2) {
		// Write your code here for the challenge problem.
	}

	else {
		// Print error message.
		printf("Incorrect method number.\n");
		return -1;
	}

	return 0;
}

/*
 *  implementation for getVnext(), which computes the Vout(n+1) specified by the
 *  equation given in the MP description. Takes input of:
 *  floating points: omegaOne, omegaTwo, omegaC, dt_, v_prev, v_cur, and int N
 */
float getVnext(double omegaOne, double omegaTwo, double omegaC, double dt_, 
                double v_prev, double v_cur, int N){
    if(N < 0 ) return 0.0;
    if(N == 0 ) return 0.0;
    //if(N == 1 ) return 0.0;
    double v_Next = 0.0;
	v_Next = pow( 1/( sqrt(2)*dt_*omegaC ) + 1/( pow(dt_,2)*pow(omegaC,2) ) ,-1);
	v_Next *= (2/( pow(dt_,2)*pow(omegaC,2) )-1)*v_cur + (1/( sqrt(2)*dt_*omegaC )-1/( pow(dt_,2)*pow(omegaC,2) ))*v_prev + sin(omegaOne*N*dt_) + .5*sin(omegaTwo*N*dt_);
	return v_Next;
}

