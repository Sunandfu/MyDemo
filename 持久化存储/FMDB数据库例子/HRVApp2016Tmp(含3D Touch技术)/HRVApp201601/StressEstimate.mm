
#include "header.h"
#include "lombPSD.h"

short StressEstimate(float *RRx, float *RRy, unsigned int ndata, unsigned int gender, StressAssess *stressAssess)
{
	float *rr = NULL;
	float *tm = NULL; 
	rr = new float[ndata];
	tm = new float[ndata];
	unsigned int lenNN = ndata;
	short RRfiltreust = 0;
	RRfiltreust = RRfilter(RRy, RRx, ndata, rr, tm, lenNN);
	if (lenNN < 50)
		return 0;
	TimeDomainResult TimeResult;

	TimeDomainIndex(rr, lenNN, &TimeResult);  //计算HRV时域参数


	unsigned int tmp;
	//FILE *fp; 
	//fp = fopen("D:\\ecg\\RRfilterout.txt","wt");
	//for (tmp = 0; tmp < lenNN; tmp++){
	//	if ( tmp == 417) 
	//	{
	//		tmp = tmp;
	//	}
	//	fprintf(fp, "%f %f\n",*(tm + tmp), *(rr + tmp));
	//}

	//fclose(fp);

	short Psdresult = 0;
	float *freq, *psdx;
	unsigned psdLen;
    
    unsigned OutcomeFreqDom;

	Psdresult = calLombPsd(tm, rr, lenNN, &freq, &psdx, psdLen);  //Lomb方法求功率谱

	FreqDomainResult FreqResult;

	OutcomeFreqDom = FreqDomainIndex(freq, psdx, psdLen, &FreqResult);
    if(OutcomeFreqDom == 0)
        return 0;


	CalStressScore(&TimeResult, &FreqResult, stressAssess, gender);



	return 1;
}


void errors(char *s)
{
    fprintf(stderr, ": %s\n",  s);
    
    //exit(1);
}