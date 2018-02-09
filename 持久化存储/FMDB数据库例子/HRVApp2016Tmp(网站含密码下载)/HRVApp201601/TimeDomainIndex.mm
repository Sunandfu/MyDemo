#include "header.h"

unsigned TimeDomainIndex(float *y, unsigned int lenNN, TimeDomainResult *TimeResult)
{
	unsigned int Result = 0;
	float meanNNtmp = 0;
	float SDNNtmp = 0;
	float rMSSDtmp = 0;
	float NN50tmp = 0;
	float PNN50tmp = 0;

	meanfun(y, lenNN, &meanNNtmp, &SDNNtmp, 1);

	unsigned i;
	float tmp = 0;
	float *diffNN, *diffNN2;

	if (lenNN < 2) errors("no enough data");

	if ((diffNN = (float *)malloc((lenNN - 1) * sizeof(float))) == NULL ||
		(diffNN2 = (float *)malloc((lenNN - 1) * sizeof(float))) == NULL) 
		errors("insufficient memory");
	
	for (i = 0; i < lenNN - 1; i ++) {
		*(diffNN + i) = *(y + i +1) - *(y + i);
		if (*(diffNN + i) > 0.05) NN50tmp ++ ;
		*(diffNN2 + i) = *(diffNN + i) * *(diffNN + i);
	}
	PNN50tmp = NN50tmp / (float)(lenNN - 1);

	meanfun(diffNN2, lenNN - 1, &rMSSDtmp, &tmp, 0);

	rMSSDtmp = sqrt(rMSSDtmp);

	TimeResult -> meanNN = meanNNtmp;
	TimeResult -> SDNN = SDNNtmp;
	TimeResult -> rMSSD = rMSSDtmp;
	TimeResult -> PNN50 = PNN50tmp;

	free(diffNN);
	free(diffNN2);

	Result = 1;
	return Result;
}

