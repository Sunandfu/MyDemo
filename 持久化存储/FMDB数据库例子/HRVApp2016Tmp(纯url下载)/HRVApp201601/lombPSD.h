
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
extern void exit();

short calLombPsd(float *x, float *y, unsigned int lenNN, float **freq, float **psdx, unsigned &psdLen);
void fasper(float x[], float y[], unsigned long n, float ofac, float hifac, float wk1[],
	float wk2[], unsigned long nwk, unsigned long *nout, unsigned long *jmax, float *prob);
void spread(float y, float yy[], unsigned long n, float x, int m);
void avevar(float *data, unsigned long n, float *ave, float *var);
void realft(float data[], unsigned long n, int isign);
void four1(float data[],unsigned long nn,int isign);
void error(char *s);
unsigned long input(float **x, float **y, float **wk1, float **wk2, unsigned int npts, unsigned int nmax);
void zeromean(float *y, unsigned long n);