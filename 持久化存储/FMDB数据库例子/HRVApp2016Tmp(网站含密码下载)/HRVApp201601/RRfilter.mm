#include "header.h"

short RRfilter(float *RRy, float *RRx, unsigned int ndata, float *filty, float *filtx, unsigned int &lenNN)
{
	unsigned short j = 0;
	unsigned short toalNum = 0; //保存每轮滤波后的数据个数
	short flag = 1;
	float *NNxx, *NNyy;
	float aver, SD;
	float sumNum = 0;
	NNxx = new float[ndata];  //保存第一轮滤波的结果，其为第二轮滤波的原始数据
	NNyy = new float[ndata];
	for (unsigned int i = 0; i < ndata; i++){
		if (*(RRy + i) < 2 && *(RRy + i) > 0.4){   //第一轮对单个点滤波
			if (j > 0){
				if (abs(*(RRy+i) - *(RRy+i-1)) < 0.3 * *(NNyy+j-1)){
					*(NNxx + j) = *(RRx + i);
					*(NNyy + j) = *(RRy + i);
					j++;
				}
			}
			else{
				*(NNxx + j) = *(RRx + i);
				*(NNyy + j) = *(RRy + i);
				j++;
			}
		}
	}
	toalNum = j;

	float *NNx = NULL, *NNy = NULL;
	NNx = new float[toalNum]; //保存第二轮滤波的结果
	NNy = new float[toalNum];

	short filtstart = 20, movwin = 20;  //filtstart必须大于等于movwin

	if (toalNum <= filtstart) return -1;
	short filtend = toalNum - 1 - movwin;

	j = filtstart;
	for (unsigned int i = filtstart; i <= filtend; i++){  //第二轮使用滑动窗口来滤波
		MoveMean(NNyy, i, sumNum, movwin, aver, SD, flag);
		if (NNyy[i] < 1.2 * aver && NNyy[i] > 0.8 * aver){
			if (abs(NNyy[i] - NNyy[i-1]) < 5 * SD){
				*(NNx + j) = *(NNxx + i);
				*(NNy + j) = *(NNyy + i);
				j++;
			}
			else
				j = j;  //测试代码
		}
		else
			j = j;   //测试代码
	}
	toalNum = j;

	unsigned int ii, k;
	for (ii=0; ii < filtstart; ii++){
		*(filtx + ii) = *(NNxx + ii);
		*(filty + ii) = *(NNyy + ii);
	}
	for (; ii < toalNum; ii++){
		*(filtx + ii) = *(NNx + ii);
		*(filty + ii) = *(NNy + ii);
	}
	k = filtend + 1;
	lenNN = toalNum + movwin;
	for (; ii < lenNN; ii++){
		*(filtx + ii) = *(NNxx + k);
		*(filty + ii) = *(NNyy + k);
		k++;
	}	

	if (NNxx){delete [] NNxx; NNxx = NULL;}
	if (NNyy){delete [] NNyy; NNyy = NULL;}
	if (NNx){delete [] NNx; NNx = NULL;}
	if (NNy){delete [] NNy; NNy = NULL;}

	return 1;

}