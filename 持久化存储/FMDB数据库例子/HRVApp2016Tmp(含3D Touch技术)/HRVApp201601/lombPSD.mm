



/* file: lomb.c		G. Moody	12 February 1992
			Last revised:	  27 July 2010
-------------------------------------------------------------------------------
lomb: Lomb periodogram of real data
________________________

The default input to this program is a text file containing a sampled time
series, presented as two columns of numbers (the sample times and the sample
values).  The intervals between consecutive samples need not be uniform (in
fact, this is the most significant advantage of the Lomb periodogram over other
methods of power spectral density estimation).  This program writes the Lomb
periodogram (the power spectral density estimate derived from the input time
series) on the standard output.

The original version of this program was based on the algorithm described in
Press, W.H, and Rybicki, G.B., Astrophysical J. 338:277-280 (1989).  It has
been rewritten using the versions of this algorithm presented in Numerical
Recipes in C (Press, Teukolsky, Vetterling, and Flannery;  Cambridge U. Press,
1992).

This version agrees with 'fft' output (amplitude spectrum up to the Nyquist
frequency with total power equal to the variance);  thanks to Joe Mietus.
*/

#include "lombPSD.h"

static long lmaxarg1, lmaxarg2;
#define LMAX(a,b) (lmaxarg1 = (a),lmaxarg2 = (b), (lmaxarg1 > lmaxarg2 ? \
						   lmaxarg1 : lmaxarg2))
static long lminarg1, lminarg2;
#define LMIN(a,b) (lminarg1 = (a),lminarg2 = (b), (lminarg1 < lminarg2 ? \
						   lminarg1 : lminarg2))
#define MOD(a,b)	while (a >= b) a -= b
#define MACC 4
#define SIGN(a,b) ((b) > 0.0 ? fabs(a) : -fabs(a))
static float sqrarg;
#define SQR(a) ((sqrarg = (a)) == 0.0 ? 0.0 : sqrarg*sqrarg)
#define SWAP(a,b) tempr=(a);(a)=(b);(b)=tempr

float pwr;



	/* Initial buffer size (must be a power of 2).
			   Note that input() will increase this value as
			   necessary by repeated doubling, depending on
			   the length of the input series. */

short calLombPsd(float *tm, float *rr, unsigned int lenNN, float **freq, float **psdx, unsigned &psdLen)
{
	short PsdResult = 0;
	float *wk1, *wk2;
	unsigned nmax = 512;
    float prob;
    int aflag = 0, i, sflag = 0, zflag = 0;  //经过测试，如此设置，计算结果和.m代码一致
	/* no smooth output */ /* output powers instead of amplitudes */ /* no zero-mean the input */
    unsigned long n, nout, jmax, maxout;

	float *x, *y;
	if ((x = (float *)malloc(lenNN * sizeof(float))) == NULL ||
	(y = (float *)malloc(lenNN * sizeof(float))) == NULL) {
	error("insufficient memory");
    }
	for (unsigned jt = 0; jt < lenNN; jt++){
		*(x + jt) = *(tm + jt);
		*(y + jt) = *(rr + jt);
	}

    /* 准备需要的空间 */
    nmax = input(&x, &y, &wk1, &wk2, lenNN, nmax);

    /* Zero-mean the input if requested. */
    if (zflag) zeromean(y, lenNN);

    /* Compute the Lomb periodogram. */
    fasper(x-1, y-1, lenNN, 2.0, 1.0, wk1-1, wk2-1, 64*nmax, &nout, &jmax, &prob);

    /* Write the results.  Output only up to Nyquist frequency, so that the
       results are directly comparable to those obtained using conventional
       methods.  The normalization is by half the number of output samples; the
       sum of the outputs is (approximately) the mean square of the inputs.

       Note that the Nyquist frequency is not well-defined for an irregularly
       sampled series.  Here we use half of the mean sampling frequency, but
       the Lomb periodogram can return (less reliable) estimates of frequency
       content for frequencies up to half of the maximum sampling frequency in
       the input.  */

    maxout = nout/2;

		FILE *fp;
	//char outfile[50];
	//strcat(outfile,"data\lombPsdVC.txt"); 
	char *outfile;
	outfile=new char[50];	
	outfile = "D\\ecg\\lombPsdVC.txt";
//	fp=fopen(outfile,"wt");

	float *freqtmp, *psdxtmp;
	if ((freqtmp = (float *)malloc(nout * sizeof(float))) == NULL ||
	(psdxtmp = (float *)malloc(nout * sizeof(float))) == NULL) {
	error("insufficient memory");
    }

    if (sflag) {        /* smoothed */

        pwr /= 4;

        if (aflag)      /* smoothed amplitudes */
	    for (n = 0; n < maxout; n += 4){
	        printf("%g\t%g\n", wk1[n],
		      sqrt((wk2[n]+wk2[n+1]+wk2[n+2]+wk2[n+3])/(nout/(8.0*pwr))));
//			fprintf(fp,"%g\t%g\n", wk1[n],
//		      sqrt((wk2[n]+wk2[n+1]+wk2[n+2]+wk2[n+3])/(nout/(8.0*pwr))));
		}

        else            /* smoothed powers */
	    for (n = 0; n < maxout; n += 4){
	        printf("%g\t%g\n", wk1[n],
		      (wk2[n]+wk2[n+1]+wk2[n+2]+wk2[n+3])/(nout/(8.0*pwr)));
	//		fprintf(fp,"%g\t%g\n", wk1[n],
	//	      (wk2[n]+wk2[n+1]+wk2[n+2]+wk2[n+3])/(nout/(8.0*pwr)));
		}

    }
    else {    	        /* oversampled */

        if (aflag)      /* amplitudes */
	    for (n = 0; n < maxout; n++){
	        printf("%g\t%g\n", wk1[n], sqrt(wk2[n]/(nout/(2.0*pwr))));
	//		fprintf(fp,"%g\t%g\n", wk1[n], sqrt(wk2[n]/(nout/(2.0*pwr))));
		}

        else            /* powers */
	 //   for (n = 0; n < maxout; n++){
	 //       printf("%g\t%g\n", wk1[n], wk2[n]/(nout/(2.0*pwr)));
		//	fprintf(fp,"%g\t%g\n", wk1[n], wk2[n]/(nout/(2.0*pwr)));
		//}
		for (n = 0; n < nout; n++){   
	        //printf("%g\t%g\n", wk1[n], wk2[n]);
//			fprintf(fp,"%g\t%g\n", wk1[n], wk2[n]);
				
			*(freqtmp + n) = *(wk1 + n);
			*(psdxtmp + n) = *(wk2 + n);

			psdLen = nout;
		}
    }

//	fclose(fp);

	*freq = freqtmp;  //输出的功率谱
	*psdx = psdxtmp;
	

    free(x);
    free(y);
    free(wk1);
    free(wk2);

    //exit(0);
	PsdResult = 1;
	return PsdResult;
}

void error(char *s)
{
    fprintf(stderr, ": %s\n",  s);
    return;
    //exit(1);
}



/* Read input data, allocating and filling x[] and y[].  The return value is
   the number of points read.

   This function allows the input buffers to grow as large as necessary, up to
   the available memory (assuming that a long int is large enough to address
   any memory location). */

unsigned long input(float **x, float **y, float **wk1, float **wk2, unsigned int npts, unsigned int nmax)
{

   	float *xt, *yt, *w1t, *w2t;
	if (npts < nmax){
		if ((xt = (float *)realloc(*x, nmax * sizeof(float))) == NULL ||
		   (yt = (float *)realloc(*y, nmax * sizeof(float))) == NULL) {
			error("insufficient memory");
		}
		*x = xt;
		*y = yt;
	}
	if ((w1t = (float *)malloc(64 * nmax * sizeof(float))) == NULL ||
	(w2t = (float *)malloc(64 * nmax * sizeof(float))) == NULL) {
	error("insufficient memory");
    }

	*wk1 = w1t;
	*wk2 = w2t;

        while (npts >= nmax) {	/* double the size of the input buffers */
	    unsigned long nmaxt = nmax << 1;

	    if (64 * nmaxt * sizeof(float) < nmax) {
		fprintf(stderr,
		      ": insufficient memory, truncating input at row %lu\n",
		       npts);
	        break;
	    }
	    if ((xt = (float *)realloc(*x, nmaxt * sizeof(float))) == NULL) {
		fprintf(stderr,
		      ": insufficient memory, truncating input at row %lu\n",
		       npts);
	        break;
	    }
	    *x = xt;
	    if ((yt = (float *)realloc(*y, nmaxt * sizeof(float))) == NULL) {
		fprintf(stderr,
		      ": insufficient memory, truncating input at row %lu\n",
		       npts);
	        break;
	    }
	    *y = yt;
	    if ((w1t = (float *)realloc(*wk1,64*nmaxt*sizeof(float))) == NULL){
		fprintf(stderr,
		      ": insufficient memory, truncating input at row %lu\n",
		       npts);
	        break;
	    }
	    *wk1 = w1t;
	    if ((w2t = (float *)realloc(*wk2,64*nmaxt*sizeof(float))) == NULL){
		fprintf(stderr,
		      ": insufficient memory, truncating input at row %lu\n",
		       npts);
	        break;
	    }
	    *wk2 = w2t;
	    nmax = nmaxt;
	}

    if (npts < 1) error("no data read");
    return (nmax);
}

/* This function calculates the mean of all sample values and subtracts it
   from each sample value, so that the mean of the adjusted samples is zero. */

void zeromean(float *y, unsigned long n)
{
    unsigned long i;
    double ysum = 0.0;

    for (i = 0; i < n; i++)
	ysum += y[i];
    ysum /= n;
    for (i = 0; i < n; i++)
	y[i] -= ysum;
}


void fasper(float x[], float y[], unsigned long n, float ofac, float hifac, float wk1[],
	float wk2[], unsigned long nwk, unsigned long *nout, unsigned long *jmax, float *prob)  //ofac, hifac, 4,2
{
	unsigned long j, k, ndim, nfreq, nfreqt;
    float ave, ck, ckk, cterm, cwt, den, df, effm, expy, fac, fndim, hc2wt,
          hs2wt, hypo, pmax, sterm, swt, var, xdif, xmax, xmin;

    *nout = 0.5*ofac*hifac*n;  //过采样后PSD频率点长度
    nfreqt = ofac*hifac*n*MACC;  //用扩展后信号计算三角函数时的最小FFT长度
    nfreq = 64;
    while (nfreq < nfreqt) nfreq <<= 1;
    ndim = nfreq << 1;  //用扩展后信号计算三角函数时的输出长度（wk长度)，其大于最小FFT长度的两倍，因为正、余弦一前一后保存在wk数组中
    if (ndim > nwk)  //申请的nwk内存空间不小于输入信号长度的64倍
	error("workspaces too small\n");
    avevar(y, n, &ave, &var);
    xmax = xmin = x[1];
    for (j = 2; j <= n; j++) {
	if (x[j] < xmin) xmin = x[j];
	if (x[j] > xmax) xmax = x[j];
    }
    xdif = xmax - xmin;
    for (j = 1; j <= ndim; j++) wk1[j] = wk2[j] = 0.0;
    fac = ndim/(xdif*ofac);  //??  1/(xdif*ofac)表示过采样后的PSD频率点间隔
    fndim = ndim;
    for (j = 1; j <= n; j++) {   //信号扩展
	ck = (x[j] - xmin)*fac;  //在x的fac倍处扩展信号（一个点扩展为MACC个点），fac必须大于2倍的（MACC-1），不然会有重叠
	MOD(ck, fndim);
	ckk = 2.0*(ck++);
	MOD(ckk, fndim);
	++ckk;
	spread(y[j] - ave, wk1, ndim, ck, MACC);  //在wk1[ck]周围扩展出MACC个数据，其和等于y[j] - ave
	spread(1.0, wk2, ndim, ckk, MACC);
    }
    realft(wk1, ndim, 1); // wk1[k]=Ch,wk1[k+1]=Sh
    realft(wk2, ndim, 1); // wk2[k]=C2,wk2[k+1]=S2
    df = 1.0/(xdif*ofac);
    pmax = -1.0;
    for (k = 3, j = 1; j <= (*nout); j++, k += 2) {
	hypo = sqrt(wk2[k]*wk2[k] + wk2[k+1]*wk2[k+1]);
	hc2wt = 0.5*wk2[k]/hypo;  // 0.5cos(2wtao)
	hs2wt = 0.5*wk2[k+1]/hypo; // 0.5sin(2wtao)
	cwt = sqrt(0.5+hc2wt);  //cos(wtao)
	swt = SIGN(sqrt(0.5-hc2wt), hs2wt);  //sin(wtao)
	den = 0.5*n + hc2wt*wk2[k] + hs2wt*wk2[k+1];  //sum(cos^2(w(t-tao)))=0.5*n+0.5*sin(2wtao)*C2+0.5*sin(2wtao)*S2
	cterm = SQR(cwt*wk1[k] + swt*wk1[k+1])/den;  //SQR(cos(wtao)*Ch+sin(wt)*Sh)/sum(cos^2(w(t-tao)))
	sterm = SQR(cwt*wk1[k+1] - swt*wk1[k])/(n - den); //SQR(Sh*cos(wtao)-Ch*sin(wtao))/sum(sin^2(w(t-tao)))
	wk1[j] = j*df;
	wk2[j] = (cterm+sterm)/(2.0*var);
	if (wk2[j] > pmax) pmax = wk2[(*jmax = j)];
    }
    expy = exp(-pmax);
    effm = 2.0*(*nout)/ofac;
    *prob = effm*expy;
    if (*prob > 0.01) *prob = 1.0 - pow((float)(1.0 - expy), (float)effm);
}

void spread(float y, float yy[], unsigned long n, float x, int m)
{
    int ihi, ilo, ix, j, nden;
    static int nfac[11] = { 0, 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880 };
    float fac;

    if (m > 10)    //???
	error("factorial table too small");
    ix = (int)x;
    if (x == (float)ix) yy[ix] += y; //若x是整数
    else {
	ilo = LMIN(LMAX((long)(x - 0.5*m + 1.0), 1), n - m + 1);  //若x是小数，则结果中位置位于x前m/2-1到x后m/2+1的共m个数要扩展
	ihi = ilo + m - 1;
	nden = nfac[m];
	fac = x - ilo;
	for (j = ilo + 1; j <= ihi; j++) fac *= (x - j);
	yy[ihi] += y*fac/(nden*(x - ihi));
	for (j = ihi-1; j >= ilo; j--) {
	    nden = (nden/(j + 1 - ilo))*(j - ihi);
	    yy[j] += y*fac/(nden*(x - j));
	}
    }
}

void avevar(float *data, unsigned long n, float *ave, float *var)
{
    unsigned long j;
    float s, ep;

    for (*ave = 0.0, j = 1; j <= n; j++) *ave += data[j];
    *ave /= n;
    *var = ep = 0.0;
    for (j = 1; j <= n; j++) {
	s = data[j] - (*ave);
	ep += s;
	*var += s*s;
    }
    *var = (*var - ep*ep/n)/(n-1);
    pwr = *var;
}

void realft(float data[], unsigned long n, int isign)
{
    unsigned long i, i1, i2, i3, i4, np3;
    float c1 = 0.5, c2, h1r, h1i, h2r, h2i;
    double wr, wi, wpr, wpi, wtemp, theta;

    theta = 3.141592653589793/(double)(n>>1);
    if (isign == 1) {
	c2 = -0.5;
	four1(data, n>>1, 1);
    } else {
	c2 = 0.5;
	theta = -theta;
    }
    wtemp = sin(0.5*theta);
    wpr = -2.0*wtemp*wtemp;
    wpi = sin(theta);
    wr = 1.0 + wpr;
    wi = wpi;
    np3 = n+3;
    for (i = 2; i <= (n>>2); i++) {
	i4 = 1 + (i3 = np3 - (i2 = 1 + (i1 = i + i - 1)));
	h1r =  c1*(data[i1] + data[i3]);
	h1i =  c1*(data[i2] - data[i4]);
	h2r = -c2*(data[i2] + data[i4]);
	h2i =  c2*(data[i1] - data[i3]);
	data[i1] =  h1r + wr*h2r - wi*h2i;
	data[i2] =  h1i + wr*h2i + wi*h2r;
	data[i3] =  h1r - wr*h2r + wi*h2i;
	data[i4] = -h1i +wr*h2i + wi*h2r;
	wr = (wtemp = wr)*wpr - wi*wpi + wr;
	wi = wi*wpr + wtemp*wpi + wi;
    }
    if (isign == 1) {
	data[1] = (h1r = data[1]) + data[2];
	data[2] = h1r - data[2];
    } else {
	data[1] = c1*((h1r = data[1]) + data[2]);
	data[2] = c1*(h1r - data[2]);
	four1(data, n>>1, -1);
    }
}

void four1(float data[],unsigned long nn,int isign)
{
    unsigned long n, mmax, m, j, istep, i;
    double wtemp, wr, wpr, wpi, wi, theta;
    float tempr, tempi;

    n = nn << 1;
    j = 1;
    for (i = 1; i < n; i += 2) {
	if (j > i) {
	    SWAP(data[j], data[i]);
	    SWAP(data[j+1], data[i+1]);
	}
	m = n >> 1;
	while (m >= 2 && j > m) {
	    j -= m;
	    m >>= 1;
	}
	j += m;
    }
    mmax = 2;
    while (n > mmax) {
	istep = mmax << 1;
	theta = isign*(6.28318530717959/mmax);
	wtemp = sin(0.5*theta);
	wpr = -2.0*wtemp*wtemp;
	wpi = sin(theta);
	wr = 1.0;
	wi = 0.0;
	for (m = 1; m < mmax; m += 2) {
	    for (i = m;i <= n;i += istep) {
		j = i + mmax;
		tempr = wr*data[j] - wi*data[j+1];
		tempi = wr*data[j+1] + wi*data[j];
		data[j] = data[i] - tempr;
		data[j+1] = data[i+1] - tempi;
		data[i] += tempr;
		data[i+1] += tempi;
	    }
	    wr = (wtemp = wr)*wpr - wi*wpi + wr;
	    wi = wi*wpr + wtemp*wpi + wi;
	}
	mmax = istep;
    }
}