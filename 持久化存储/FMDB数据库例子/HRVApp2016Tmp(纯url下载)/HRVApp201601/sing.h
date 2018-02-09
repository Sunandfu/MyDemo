
#ifndef SING_H_
#define SING_H_

int fft_sing(double *a, double *b, long ntot, long n, long nspan, int isn);
void realtr(double *a, double *b, long half_length, int isn);

#endif
