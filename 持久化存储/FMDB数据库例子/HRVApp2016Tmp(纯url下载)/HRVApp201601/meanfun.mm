#include "header.h"

void MoveMean(float *data, unsigned int start, float &sumNum, 
	unsigned int movwin, float &aver, float &SD, short &flag)
{
    unsigned long j, len = 2 * movwin+1;
	float var, s, ep;

	if (flag == 1)
		for (aver = 0.0, j = start - movwin; j <= start + movwin; j++) {
			sumNum += data[j];
			flag = 0;
		}
	else
		sumNum = sumNum - data[start-1-movwin] + data[start + movwin];	
	aver = sumNum / len;

	var = ep = 0.0;
	for (j = start - movwin; j <= start + movwin; j++) {
	s = data[j] - aver;
	ep += s;
	var += s*s;
    }
    var = (var - ep*ep/len)/(len - 1);
	SD = sqrt(var);
}


void meanfun(float *data, unsigned int len, float *aver, float *SD, unsigned int varflag)
{
    unsigned long j;
	float var, s, ep, sum = 0;

	for (j = 0; j < len; j++) {
		sum += data[j];
	}

	*aver = sum / (float)len;

	if (varflag == 1){
		var = ep = 0.0;
		for (j = 0; j < len; j++) {
		s = data[j] - *aver;
		ep += s;
		var += s*s;
		}
		var = (var - ep*ep/len)/(len - 1);
		*SD = sqrt(var);
	}
	else
		*SD = 0;
}