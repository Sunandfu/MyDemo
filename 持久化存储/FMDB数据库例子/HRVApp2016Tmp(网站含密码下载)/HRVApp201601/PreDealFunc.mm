#define _CRT_SECURE_NO_WARNINGS

#include "PreDealFunc.h"
#include "sing.h"
#include "header.h"

#define VSDEBUG 1
#define NOISE_TIME 1

maindetect::~maindetect()
{
}
double maindetect::get2double(double a)
{
	a = ((double)((int)(a * 100))) / 100;
	return a;
}

LONG_ARR maindetect::get_PSD_RRlist(LONG_ARR *RRlist, LONG_ARR *Rannolist,
	double fs)
{
	long i = 0;
	double RRmean = 0;
	LONG_ARR PSD_RRlist;
	PSD_RRlist.arr = (long *)malloc((RRlist->count) * sizeof(long));
	PSD_RRlist.count = 0;
	for (i = 0; i < 4; i++)
	{
		RRmean += RRlist->arr[i];
	}
	RRmean = RRmean / 4;
	for (i = 0; i < RRlist->count; i++)
	{
		if ((Rannolist->arr[i] == 0 && Rannolist->arr[i + 1] == 0) || (Rannolist->arr[i] == 6 && Rannolist->arr[i + 1] == 6)
			|| (Rannolist->arr[i] == 11 && Rannolist->arr[i + 1] == 11))
		{
			PSD_RRlist.arr[i] = RRlist->arr[i];
		}
		else if (i > 0)
		{
			PSD_RRlist.arr[i] = PSD_RRlist.arr[i - 1];
		}
		else
		{
			PSD_RRlist.arr[i] = (int)(RRmean);
		}
	}
	PSD_RRlist.count = RRlist->count;
	return PSD_RRlist;
}
LONG_ARR maindetect::get_NEW_RRlist(LONG_ARR *RRlist, LONG_ARR *Rannolist,
	double fs)
{
	long i = 0;
	double RRmean = 900;
	LONG_ARR new_RRlist;
	new_RRlist.arr = (long *)malloc((RRlist->count) * sizeof(long));
	new_RRlist.count = 0;

	while (i < Rannolist->count - 3)
	{
		if (Rannolist->arr[i] != -1 && Rannolist->arr[i + 1] != -1
			&& Rannolist->arr[i + 2] != -1 && Rannolist->arr[i] != 1
			&& Rannolist->arr[i + 1] != 1 && Rannolist->arr[i + 2] != 1
			&& Rannolist->arr[i] != 6 && Rannolist->arr[i + 1] != 6
			&& Rannolist->arr[i + 2] != 6)
		{
			RRmean = 0;
			RRmean = RRlist->arr[i] + RRlist->arr[i + 1] + RRlist->arr[i + 2];
			RRmean = RRmean / 3;
			break;
		}

		i++;
	}
	for (i = 0; i < RRlist->count; i++)
	{
		if (Rannolist->arr[i] != -1 && Rannolist->arr[i + 1] != -1)
		{
			new_RRlist.arr[i] = RRlist->arr[i];
		}
		else if (i > 0 && (new_RRlist.arr[i - 1] < 2 * RRmean)
			&& (new_RRlist.arr[i - 1] > 0.5 * RRmean))
		{
			new_RRlist.arr[i] = new_RRlist.arr[i - 1];
		}
		else
		{
			new_RRlist.arr[i] = (int)(RRmean);
		}
	}
	new_RRlist.count = RRlist->count;
	return new_RRlist;
}

int maindetect::GET_NEWRannolist_AFTER(LONG_ARR *Rlist, LONG_ARR *RRlist,
	LONG_ARR *Rannolist, struct data_buffer *buf, double fs)
{

	int j = 0;
	int i = 0;
	unsigned k = 0;
	vector<double> ecgsegment;
	double var_value = 0;
	double ecgmean = 0;
	double max = 0;
	double min = 0;

	for (j = 0; j < Rannolist->count - 1; j++)
	{
		if ((Rannolist->arr[j] == 1 || Rannolist->arr[j] == 2) && (Rlist->arr[j
			+ 1] - Rlist->arr[j] >(int) (0.7 * fs + 2)))
		{
			for (i = Rlist->arr[j] + (int)(0.4 * fs); i < Rlist->arr[j + 1]
				- (int)(0.3 * fs); i++)
			{
				ecgsegment.push_back(buf->orig00[i]);
			}
			max = ecgsegment[0];
			min = ecgsegment[0];

			for (k = 0; k < ecgsegment.size(); k++)
			{
				ecgmean += ecgsegment[k];
				if (max < ecgsegment[k])
					max = ecgsegment[k];
				if (min > ecgsegment[k])
					min = ecgsegment[k];
			}
			ecgmean = ecgmean / (ecgsegment.size());
			for (k = 0; k < ecgsegment.size(); k++)
			{
				var_value += (ecgsegment[k] - ecgmean) * (ecgsegment[k]
					- ecgmean);
			}
			var_value = sqrt(var_value / (ecgsegment.size()));

			if (var_value > 20 && (max - min > 0.7 * buf->temp_Rvalue))
			{
				if (Rannolist->arr[j] == 1)
					result.Arrest_Num--;
				else
					result.Missed_Num--;
				Rannolist->arr[j] = 0;
				if (j > 0)
					RRlist->arr[j] = RRlist->arr[j - 1];
				else
					RRlist->arr[j] = RRlist->arr[j + 1];
			}
			ecgsegment.clear();
		}
	}
	return 0;
}

int maindetect::GET_TEMPLATE_NEW(LONG_ARR *Rlist, LONG_ARR *RRlist,
struct data_buffer *buf, double fs, long ecgnum, long RRmean)
{
	int i = 0;
	int j = 0;
	int k = 0;
	unsigned m = 0;
	int flag = 0;
	double ecgmean = 0;
	double temp_ecgmean = 0;
	double max = 0;
	double min = 0;
	buf->temp_mean = 0;
	buf->temp_maxdiff = 0;
	double temp_Rvalue = 0;
	vector<double> template1;
	vector<double> template2;
	vector<double> template3;
	vector<double> template4;

	vector<int> FLAGRlist;
	int flagfinish = 0;

	int flag1 = 0;
	int flag2 = 0;

	for (i = 0; i<RRlist->count - 2; i++)
	{
		if (RRlist->arr[i + 1]>0.8*RRlist->arr[i] && RRlist->arr[i + 1]<1.2*RRlist->arr[i])
		{
			if (RRlist->arr[i]>0.8*RRmean&&RRlist->arr[i] < 1.3*RRmean)
				FLAGRlist.push_back(1);
			else
				FLAGRlist.push_back(0);
		}
		else
			FLAGRlist.push_back(-1);
	}
	i = 0;
	while (i < RRlist->count - 6)
	{
		if ((FLAGRlist[i] == 1) && (FLAGRlist[i + 1] == 1) && (FLAGRlist[i + 2] == 1) && (FLAGRlist[i + 3] == 1) && (FLAGRlist[i + 4] == 1) && (FLAGRlist[i + 5] == 1))
		{
			for (k = Rlist->arr[i + 1] - (int)(0.1*fs); k < Rlist->arr[i + 1]
				+ (int)(fs*0.4); k++)
			{
				template1.push_back(buf->orig00[k]);
			}

			for (k = Rlist->arr[i + 2] - (int)(0.1*fs); k < Rlist->arr[i + 2]
				+ (int)(fs*0.4); k++)
			{
				template2.push_back(buf->orig00[k]);

			}

			if (Rlist->arr[i + 3] + (int)(fs*0.4) >= ecgnum)
			{
				flag = 2;
				for (k = Rlist->arr[i + 2] - (int)(0.1*fs); k < Rlist->arr[i + 2]
					+ (int)(fs*0.4); k++)
				{
					template3.push_back(buf->orig00[k]);
					template4.push_back(buf->orig00[k]);
				}
			}
			if ((Rlist->arr[i + 4] + (int)(fs*0.4) >= ecgnum) && (flag != 2))
			{
				for (k = Rlist->arr[i + 3] - (int)(0.1*fs); k < Rlist->arr[i + 3]
					+ (int)(fs*0.4); k++)
				{
					template3.push_back(buf->orig00[k]);
					template4.push_back(buf->orig00[k]);
				}

			}
			if (flag == 0)
			{
				for (k = Rlist->arr[i + 3] - (int)(0.1*fs); k < Rlist->arr[i + 3]
					+ (int)(fs*0.4); k++)
				{
					template3.push_back(buf->orig00[k]);
				}
				for (k = Rlist->arr[i + 4] - (int)(0.1*fs); k < Rlist->arr[i + 4]
					+ (int)(fs*0.4); k++)
				{
					template4.push_back(buf->orig00[k]);
				}

			}
			flagfinish = 1;
			break;
		}

		i = i + 1;
	}

	if (flagfinish != 1)
	{
		for (k = Rlist->arr[2] - (int)(0.1*fs); k < Rlist->arr[2]
			+ (int)(fs*0.4); k++)
		{
			template1.push_back(buf->orig00[k]);

		}

		for (k = Rlist->arr[3] - (int)(0.1*fs); k < Rlist->arr[3]
			+ (int)(fs*0.4); k++)
		{
			template2.push_back(buf->orig00[k]);

		}
		for (k = Rlist->arr[4] - (int)(0.1*fs); k < Rlist->arr[4]
			+ (int)(fs*0.4); k++)
		{
			template3.push_back(buf->orig00[k]);

		}
		for (k = Rlist->arr[5] - (int)(0.1*fs); k < Rlist->arr[5]
			+ (int)(fs*0.4); k++)
		{
			template4.push_back(buf->orig00[k]);

		}
	}

	for (m = 0; m < template1.size(); m++)
	{
		buf->plate_data.push_back(
			(template1[m] + template2[m] + template3[m]
			+ template4[m]) / 4);
	}

	max = (int)(0.2*fs);
	buf->temp_Tvalue = buf->plate_data[max];
	for (m = (unsigned int)(0.2*fs); m < (unsigned int)(0.46*fs); m++)
	{
		if (buf->temp_Tvalue < buf->plate_data[m])
		{
			buf->temp_Tvalue = buf->plate_data[m];
			max = m;
		}
	}
	min = (int)(0.1*fs);
	buf->temp_Svalue = buf->plate_data[min];
	for (m = (unsigned int)(0.1*fs); m < (unsigned int)(0.3*fs); m++)
	{
		if (buf->temp_Svalue > buf->plate_data[m])
		{
			buf->temp_Svalue = buf->plate_data[m];
			min = m;
		}
	}

	ecgmean = 0;
	for (m = 0; m < template1.size(); m++)
	{
		temp_ecgmean += (buf->plate_data[m] - ecgmean)
			* (buf->plate_data[m] - ecgmean);
	}
	temp_ecgmean = sqrt(temp_ecgmean / (template1.size()));
	temp_Rvalue = buf->plate_data[(int)(0.1*fs)];

	buf->temp_Rvalue = temp_Rvalue;
	buf->temp_mean = temp_ecgmean;
	buf->temp_RT = (long)((max - (int)(0.1*fs)) / fs * 1000);
	if (buf->temp_RT<200)
		buf->temp_RT = 200;
	buf->temp_RS = (long)((min - (int)(0.1*fs)) / fs * 1000);
	if (fabs(buf->temp_Svalue - buf->temp_Rvalue)>fabs(buf->temp_Rvalue))
		buf->temp_maxdiff = fabs(buf->temp_Svalue - buf->temp_Rvalue);
	else
		buf->temp_maxdiff = fabs(buf->temp_Rvalue);

	return flagfinish;
}

int maindetect::GET_NEWRanno(int Ranno)
{

	switch (Ranno)
	{
	case 1:
		result.Arrest_Num--;

		break;
	case 2:
		result.Missed_Num--;

		break;
	case 3:
		result.PVB--;

		break;
	case 4:
		result.PAB--;

		break;
	case 5:
		result.Insert_PVBnum--;

		break;
	case 6:
		result.VT--;

		break;
	case 7:
		result.Bigeminy_Num--;

		break;
	case 8:
		result.Trigeminy_Num--;

		break;
	}
	return 0;

}

int maindetect::GET_NEWRannolist_NEW(LONG_ARR *Rlist, LONG_ARR *RRlist,LONG_ARR *Rannolist, 
struct data_buffer *buf, double fs, long ecgnum, long RRmean, LONG_ARR *QRSlist)
{
	int i = 0;
	int k = 0;
	int j = 0;
	int R_s = 0;
	int R_e = 0;
	unsigned m = 0;
	long start = 0;
	long end = 0;
	double ecgmean = 0;
	double square_mean = 0;
	double max = 0;
	double min = 0;
	double max1 = 0;
	double min1 = 0;
	result.Wrong_Num = 0;
	vector<double> template_t;

	double ecgdiff = 0;
	while (i < Rlist->count) {

		if (Rlist->arr[i] > 0)
			start = Rlist->arr[i];
		if (Rlist->arr[i] + (int)(fs * 0.2) < ecgnum)
			end = Rlist->arr[i] + (int)(fs * 0.2);
		else
			end = ecgnum - 1;

		for (k = start; k < end; k++)
		{
			template_t.push_back(buf->orig00[k]);
		}

		max = template_t[0];
		min = template_t[0];
		for (m = 0; m < template_t.size(); m++) {
			ecgmean += template_t[m];
			if (max < template_t[m])
				max = template_t[m];
			if (min > template_t[m])
				min = template_t[m];
		}
		ecgmean = ecgmean / (template_t.size());

		for (m = 0; m < template_t.size(); m++) {
			square_mean += (template_t[m] - ecgmean)
				* (template_t[m] - ecgmean);
		}
		square_mean = sqrt(square_mean / (template_t.size()));

		if (template_t.size() == buf->plate_data.size()) {
			for (m = 0; m < template_t.size(); m++) {
				ecgdiff += (template_t[m] - buf->plate_data[m])
					* (template_t[m] - buf->plate_data[m]);
			}
			ecgdiff = sqrt(ecgdiff / template_t.size());
		}

		if ((ecgdiff > 200) || (ecgdiff > 2 * fabs(buf->temp_Rvalue)) || (square_mean > 10 * buf->temp_mean 
			&& buf->temp_maxdiff > 10) || ((max - min) > 5 * buf->temp_maxdiff && buf->temp_maxdiff
	       > 50) || ((max - min) > 15 * buf->temp_maxdiff&& buf->temp_maxdiff > 50) || (max - min 
           > 2000 && buf->temp_maxdiff < 1000))
		{
			if (i > 0) {
				GET_NEWRanno(Rannolist->arr[i - 1]);
				Rannolist->arr[i - 1] = 0;

			}
			if (i < Rannolist->count - 1) {
				GET_NEWRanno(Rannolist->arr[i + 1]);
				Rannolist->arr[i + 1] = 0;
			}

			GET_NEWRanno(Rannolist->arr[i]);
			Rannolist->arr[i] = -1;
			result.Wrong_Num++;
		}

		if (Rannolist->arr[i] != 0 && Rannolist->arr[i] != -1)
		{
			if ((buf->orig00[Rlist->arr[i]] < 0 && (max - buf->orig00[Rlist->arr[i]]) < buf->temp_maxdiff * 0.7)
				|| (max - min < 80) || (buf->orig00[Rlist->arr[i]] > 0 && (buf->orig00[Rlist->arr[i]] - min) < buf->temp_maxdiff * 0.7)) 
			{
				if (Rannolist->arr[i] == 3) {
					RRlist->arr[i - 1] = (int)(RRmean);
					RRlist->arr[i] = (int)(RRmean);
					result.PVB--;
					GET_NEWRanno(Rannolist->arr[i - 1]);
					Rannolist->arr[i - 1] = 0;
					Rannolist->arr[i] = -1;
					result.Wrong_Num++;
				}
				if (Rannolist->arr[i] == 4) {
					RRlist->arr[i - 1] = (int)(RRmean);
					RRlist->arr[i] = (int)(RRmean);
					result.PAB--;
					GET_NEWRanno(Rannolist->arr[i - 1]);
					Rannolist->arr[i - 1] = 0;
					Rannolist->arr[i] = -1;
					result.Wrong_Num++;

				}
				if (Rannolist->arr[i] == 5) {
					RRlist->arr[i - 1] = (int)(RRmean);
					RRlist->arr[i] = (int)(RRmean);
					result.Insert_PVBnum--;
					GET_NEWRanno(Rannolist->arr[i - 1]);
					Rannolist->arr[i - 1] = 0;
					Rannolist->arr[i] = -1;
					result.Wrong_Num++;

				}
			}

			if (Rannolist->arr[i] == 3 || Rannolist->arr[i] == 4 || Rannolist->arr[i] == 7 
				|| Rannolist->arr[i] == 8) { 
				R_s = Rlist->arr[i - 1] + (int)(((RRlist->arr[i - 1] + RRlist->arr[i]) / 2000.0 - 0.2) * fs);
				R_e = R_s + (int)(0.4 * fs);
				max1 = 0;
				min1 = 0;
				for (j = R_s; j < R_e; j++) {
					if (max1 < buf->orig00[j])
						max1 = buf->orig00[j];
					if (min1 > buf->orig00[j])
						min1 = buf->orig00[j];

				}
				if ((max1 > 0.7 * buf->temp_Rvalue || (max1 - min1) > 0.8
					* buf->temp_maxdiff) && (max1 - min1 > max - min)) {

					switch (Rannolist->arr[i]) {
					case 3:
						result.PVB--;
						Rannolist->arr[i] = -1;
						result.Wrong_Num++;
						GET_NEWRanno(Rannolist->arr[i - 1]);
						Rannolist->arr[i - 1] = 0;
						RRlist->arr[i - 1] = (int)(RRmean);
						RRlist->arr[i] = (int)(RRmean);
						break;
					case 4:
						result.PAB--;
						Rannolist->arr[i] = -1;
						result.Wrong_Num++;
						GET_NEWRanno(Rannolist->arr[i - 1]);
						Rannolist->arr[i - 1] = 0;
						RRlist->arr[i - 1] = (int)(RRmean);
						RRlist->arr[i] = (int)(RRmean);
						break;
					case 7:
						result.Bigeminy_Num--;
						Rannolist->arr[i] = -1;
						result.Wrong_Num++;
						GET_NEWRanno(Rannolist->arr[i - 1]);
						Rannolist->arr[i - 1] = 0;
						RRlist->arr[i - 1] = (int)(RRmean);
						RRlist->arr[i] = (int)(RRmean);
						break;
					case 8:
						result.Trigeminy_Num--;
						Rannolist->arr[i] = -1;
						result.Wrong_Num++;
						GET_NEWRanno(Rannolist->arr[i - 1]);
						Rannolist->arr[i - 1] = 0;
						RRlist->arr[i - 1] = (int)(RRmean);
						RRlist->arr[i] = (int)(RRmean);
						break;
					}
				}

				max = 0;
				min = 0;
				R_s = Rlist->arr[i] - (int)(fs * 0.1);
				R_e = Rlist->arr[i] + (int)(fs * 0.4);
				if (Rannolist->arr[i] != 0) {
					for (j = R_s; j < R_e; j++) {
						if (max < buf->orig00[j])
							max = buf->orig00[j];
						if (min > buf->orig00[j])
							min = buf->orig00[j];
					}
				}

				if (Rannolist->arr[i] == 3) {
					if (buf->orig00[Rlist->arr[i]] > 0 && buf->temp_Rvalue > 0
						&& (max - min) < 1.3 * buf->temp_maxdiff
						&& QRSlist->arr[i] < 130) {
						Rannolist->arr[i] = 4;
						result.PVB--;
						result.PAB++;
					}

				}
				else if (Rannolist->arr[i] == 4)
				{
					if ((buf->orig00[Rlist->arr[i]] < -40 && buf->temp_Rvalue
					> 0) || ((max - min) > 1.6 * buf->temp_maxdiff)
					|| (max > 0.5 * buf->temp_Rvalue
					&& buf->temp_Rvalue > 0 && min < 2
					* buf->temp_Svalue && min < -100)) {
						Rannolist->arr[i] = 3;
						result.PVB++;
						result.PAB--;
					}
				}
			}
			if (Rannolist->arr[i] == 5) {
				if ((buf->orig00[Rlist->arr[i]] < -40 && buf->temp_Rvalue > 0)
					|| ((max - min) > 1.6 * buf->temp_maxdiff)
					|| QRSlist->arr[i] > 130) {
					Rannolist->arr[i] = 5;
				}
				else {
					Rannolist->arr[i] = 4;
					result.Insert_PVBnum--;
					result.PAB++;
					if (Rannolist->arr[i + 1] == 0) {
						Rannolist->arr[i + 1] = 4;
						result.PAB++;
					}
				}
			}
		}
		template_t.clear();
		i = i + 1;
	}
	return 0;
}

DOUB_ARR maindetect::ECG_NO_NOISE2(double *ecglistarr, long ecglistnum)
{

	DOUB_ARR ECG_NOlist;
	DOUB_ARR y1list;
	DOUB_ARR y2list;
	DOUB_ARR xlist;
	ECG_NOlist.arr = (double *)malloc((ecglistnum)* sizeof(double));
	y1list.arr = (double *)malloc((ecglistnum)* sizeof(double));
	y2list.arr = (double *)malloc((ecglistnum)* sizeof(double));
	xlist.arr = (double *)malloc((ecglistnum)* sizeof(double));

	int i = 0;
	for (i = 0; i < 160; i++)
	{
		y1list.arr[i] = 0;
		y2list.arr[i] = 0;
		xlist.arr[i] = 0;
		ECG_NOlist.arr[i] = 0;
	}
	for (i = 160; i < ecglistnum; i++)
	{

		xlist.arr[i] = ecglistarr[i];
		y1list.arr[i] = xlist.arr[i] - xlist.arr[i - 160] + y1list.arr[i - 5];
		y2list.arr[i] = y1list.arr[i] - y1list.arr[i - 160] + y2list.arr[i - 5];
		ECG_NOlist.arr[i - 155] = xlist.arr[i - 155] - (int)(y2list.arr[i] / 1024);
	}

	for (i = 0; i < 320; i++)
	{
		ECG_NOlist.arr[i] = 0;

	}
	for (i = ecglistnum - 160; i < ecglistnum; i++)
	{
		ECG_NOlist.arr[i] = 0;

	}
	ECG_NOlist.count = ecglistnum;
	free(y1list.arr);
	free(y2list.arr);
	free(xlist.arr);
	y1list.arr = NULL;
	y2list.arr = NULL;
	xlist.arr = NULL;

	return ECG_NOlist;
}

LONG_ARR maindetect::ECG_NO_NOISE(double *ecglistarr, long ecglistnum, double fs)
{
	vector<double> sec_ecg;
	LONG_ARR noiselist;
	int i = 0;
	int j = 0;
	int k = 0;

	int lensec = (int)(ecglistnum / fs / NOISE_TIME);
	int k_sec = 0;
	double sum_noise = 0;
	double meansec = 0;
	double max = 0;
	noiselist.arr = (long *)malloc((lensec)* sizeof(long));

	for (i = 0; i < ecglistnum; i++)
	{
		sec_ecg.push_back(ecglistarr[i]);
		sum_noise += (ecglistarr[i]);
		if (i == (k_sec + 1)*fs*NOISE_TIME)
		{
			max = 0;
			sum_noise = sum_noise / fs / NOISE_TIME;
			for (j = 0; j<fs*NOISE_TIME; j++)
			{
				meansec += fabs(sec_ecg[j] - sum_noise);
				if (max<fabs(sec_ecg[j] - sum_noise))
					max = fabs(sec_ecg[j] - sum_noise);
			}
			meansec = meansec / fs / NOISE_TIME;
			if ((meansec>120 && max>400) || meansec < 3)
			{
				noiselist.arr[k_sec] = 1;

				for (k = (int)((k_sec + 0)*fs*(NOISE_TIME)) - (int)(0.3*fs); k<(int)(k_sec + 1)*fs*(NOISE_TIME)+(int)(0.2*fs); k++)
				{
					if (k>0 && ((int)(k_sec + 1)*fs*(NOISE_TIME)+(int)(0.3*fs) < ecglistnum))
						ecglistarr[k] = 0;
				}
			}
			else
			{
				noiselist.arr[k_sec] = 0;
			}
			sum_noise = 0;
			meansec = 0;
			sec_ecg.clear();

			k_sec++;
		}
	}
	noiselist.count = lensec;

	for (i = 1; i < lensec - 1; i++)
	{
		if ((noiselist.arr[i] == 0) && (noiselist.arr[i - 1] == 1) && (noiselist.arr[i + 1] == 1 || noiselist.arr[i + 2] == 1))
		{
			noiselist.arr[i] = 1;
			for (k = (i + 0)*fs*NOISE_TIME; k < (i + 1)*fs*NOISE_TIME; k++)
			{
				ecglistarr[k] = 0;
			}
		}
	}
	return noiselist;
}

int maindetect::DROP_WRONG_RLIST(LONG_ARR *Rlist, LONG_ARR *QRS_startlist,
	LONG_ARR *QRS_endlist, LONG_ARR *RRlist, struct data_buffer *buf,
	double fs, long RRmean) {
	vector<long> Rvector;
	vector<long> QRS_startvec;
	vector<long> QRS_endvec;

	int i = 0;
	int m = 0;
	unsigned k = 0;
	double max = 0;
	double min = 0;
	int max_p = 0;
	int min_p = 0;
	Rvector.push_back(Rlist->arr[0]);
	QRS_startvec.push_back(QRS_startlist->arr[0]);
	QRS_endvec.push_back(QRS_endlist->arr[0]);
	for (i = 1; i <= RRlist->count; i++) {
		if ((RRlist->arr[i - 1] >= 1.5 * buf->temp_RT || RRlist->arr[i - 1]
			>= 350) && (RRlist->arr[i - 1] < 1.2 * RRmean)) {
			Rvector.push_back(Rlist->arr[i]);
			QRS_startvec.push_back(QRS_startlist->arr[i]);
			QRS_endvec.push_back(QRS_endlist->arr[i]);
		}
		else if (RRlist->arr[i - 1] < 1.2 * RRmean)
		{
			if ((Rvector[Rvector.size() - 1] == Rlist->arr[i - 1]) && fabs(buf->orig00[Rlist->arr[i]])>1.2*fabs(buf->orig00[Rvector[Rvector.size() - 1]]))
			{
				Rvector[Rvector.size() - 1] = Rlist->arr[i];
				QRS_startvec[QRS_startvec.size() - 1] = QRS_startlist->arr[i];
				QRS_endvec[QRS_endvec.size() - 1] = QRS_endlist->arr[i];
			}
			else if ((Rvector[Rvector.size() - 1] != Rlist->arr[i - 1]) && (fabs(buf->orig00[Rlist->arr[i]]) > 0.4*fabs(buf->temp_Rvalue)) && (fabs(buf->orig00[Rlist->arr[i]]) > 0.7*fabs(buf->orig00[Rvector[Rvector.size() - 1]])))
			{
				Rvector.push_back(Rlist->arr[i]);
				QRS_startvec.push_back(QRS_startlist->arr[i]);
				QRS_endvec.push_back(QRS_endlist->arr[i]);
			}
		}
		if (RRlist->arr[i - 1] >= 1.2 * RRmean) {
			if (buf->temp_Rvalue > 160) {
				max_p = Rlist->arr[i - 1] + (int)(0.25 * fs);
				min_p = max_p;
				max = buf->orig00[max_p];
				min = max;
				for (m = Rlist->arr[i - 1] + (int)(0.25 * fs); m
					< Rlist->arr[i] - (int)(0.15 * fs); m++) {
					if (buf->orig00[m] > max) {
						max = buf->orig00[m];
						max_p = m;
					}
					if (buf->orig00[m] < min) {
						min = buf->orig00[m];
						min_p = m;
					}
				}
				if (max > 0.65 * fabs(buf->temp_Rvalue) || (max - min > 0.7
					* buf->temp_maxdiff && (max > -0.9 * min))) {
					if ((max_p - Rlist->arr[i - 1]) > 0.4 * fs
						&& (Rlist->arr[i] - max_p > 0.25 * fs)) {
						if (abs(min_p - max_p) > (int)(0.06 * fs)) {
							Rvector.push_back(max_p);
							QRS_startvec.push_back(max_p - (int)(0.03 * fs));
							QRS_endvec.push_back(max_p + (int)(0.12 * fs));
						}
						else {
							Rvector.push_back(max_p);
							QRS_startvec.push_back(max_p - (int)(0.03 * fs));
							QRS_endvec.push_back(max_p + (int)(0.03 * fs));

						}

						Rvector.push_back(Rlist->arr[i]);
						QRS_startvec.push_back(QRS_startlist->arr[i]);
						QRS_endvec.push_back(QRS_endlist->arr[i]);

					}
					else {
						Rvector.push_back(Rlist->arr[i]);
						QRS_startvec.push_back(QRS_startlist->arr[i]);
						QRS_endvec.push_back(QRS_endlist->arr[i]);
					}
				}
				else if (min < -0.65 * fabs(buf->temp_Rvalue) || (max - min > 0.7 * buf->temp_maxdiff)) {
					if ((min_p - Rlist->arr[i - 1]) > 0.4 * fs && (Rlist->arr[i] - min_p > 0.25 * fs)) {
						if (abs(min_p - max_p) > (int)(0.06 * fs)) {
							Rvector.push_back(min_p);
							QRS_startvec.push_back(min_p - (int)(0.03 * fs));
							QRS_endvec.push_back(min_p + (int)(0.12 * fs));
						}
						else {
							Rvector.push_back(min_p);
							QRS_startvec.push_back(min_p - (int)(0.03 * fs));
							QRS_endvec.push_back(min_p + (int)(0.03 * fs));
						}

						Rvector.push_back(Rlist->arr[i]);
						QRS_startvec.push_back(QRS_startlist->arr[i]);
						QRS_endvec.push_back(QRS_endlist->arr[i]);
					}
					else {
						Rvector.push_back(Rlist->arr[i]);
						QRS_startvec.push_back(QRS_startlist->arr[i]);
						QRS_endvec.push_back(QRS_endlist->arr[i]);
					}
				}
				else {
					Rvector.push_back(Rlist->arr[i]);
					QRS_startvec.push_back(QRS_startlist->arr[i]);
					QRS_endvec.push_back(QRS_endlist->arr[i]);
				}
			}
			else {
				Rvector.push_back(Rlist->arr[i]);
				QRS_startvec.push_back(QRS_startlist->arr[i]);
				QRS_endvec.push_back(QRS_endlist->arr[i]);
			}
		}
	}

	for (k = 0; k < Rvector.size(); k++) {
		Rlist->arr[k] = Rvector[k];
		QRS_startlist->arr[k] = QRS_startvec[k];
		QRS_endlist->arr[k] = QRS_endvec[k];

	}
	Rlist->count = Rvector.size();
	QRS_startlist->count = Rvector.size();
	QRS_endlist->count = Rvector.size();
	return 0;
}

int maindetect::DROP_WRONG_RLIST1(LONG_ARR *Rlist, LONG_ARR *QRS_startlist, LONG_ARR *QRS_endlist, LONG_ARR *RRlist, struct data_buffer *buf, long RRmean)
{
	vector<long> Rvector;
	vector<long> QRS_startvec;
	vector<long> QRS_endvec;
	int RRsum = 0;
	int i = 0;
	unsigned int m = 0;
	Rvector.push_back(Rlist->arr[0]);
	QRS_startvec.push_back(QRS_startlist->arr[0]);
	QRS_endvec.push_back(QRS_endlist->arr[0]);
	for (i = 1; i < RRlist->count - 1; i++)
	{
		RRsum = RRlist->arr[i - 1] + RRlist->arr[i];
		if (((RRsum>0.8*RRmean&&RRsum<1.3*RRmean&&RRsum>0.7*RRlist->arr[i + 1]) || (i > 2 && i<(RRlist->count - 2) && RRsum>0.8*RRlist->arr[i + 1] && RRsum < 1.3*RRlist->arr[i + 1] && RRsum<1.3*RRlist->arr[i - 2] && RRsum>0.8*RRlist->arr[i - 2])) && (fabs(buf->orig00[Rlist->arr[i]]) < 0.7*fabs(buf->temp_Rvalue)))
		{
			Rvector.push_back(Rlist->arr[i + 1]);
			QRS_startvec.push_back(QRS_startlist->arr[i + 1]);
			QRS_endvec.push_back(QRS_endlist->arr[i + 1]);
			Rvector.push_back(Rlist->arr[i + 2]);
			QRS_startvec.push_back(QRS_startlist->arr[i + 2]);
			QRS_endvec.push_back(QRS_endlist->arr[i + 2]);
			i = i + 2;
		}
		else
		{
			Rvector.push_back(Rlist->arr[i]);
			QRS_startvec.push_back(QRS_startlist->arr[i]);
			QRS_endvec.push_back(QRS_endlist->arr[i]);
		}
	}

	if (Rvector[Rvector.size() - 1] != Rlist->arr[RRlist->count])
	{
		Rvector.push_back(Rlist->arr[RRlist->count - 1]);
		QRS_startvec.push_back(QRS_startlist->arr[RRlist->count - 1]);
		QRS_endvec.push_back(QRS_endlist->arr[RRlist->count - 1]);
		Rvector.push_back(Rlist->arr[RRlist->count]);
		QRS_startvec.push_back(QRS_startlist->arr[RRlist->count]);
		QRS_endvec.push_back(QRS_endlist->arr[RRlist->count]);
	}

	for (m = 0; m < Rvector.size(); m++)
	{
		Rlist->arr[m] = Rvector[m];
		QRS_startlist->arr[m] = QRS_startvec[m];
		QRS_endlist->arr[m] = QRS_endvec[m];
	}
	Rlist->count = Rvector.size();
	QRS_startlist->count = Rvector.size();
	QRS_endlist->count = Rvector.size();
	return 0;
}

int maindetect::GET_RRLIST_NOISELIST(LONG_ARR *Rlist, LONG_ARR *RRlist, LONG_ARR *noiselist, long RRmean, double fs, struct data_buffer *buf)
{
	int i = 0;
	int j = 0;
	int k = 0;
	int R_s = 0;
	int R_e = 0;
	int max = 0;
	int min = 0;
	int min_p = 0;
	int max_p = 0;
	int Rsec = 0;
	int R1sec = 0;
	int R10sec = 0;
	int flag0 = 0;
	for (i = 0; i<RRlist->count; i++)
	{
		flag0 = 0;
		if (RRlist->arr[i]>1100)
		{
			Rsec = (int)(Rlist->arr[i] / fs / NOISE_TIME);
			R1sec = (int)(Rlist->arr[i + 1] / fs / NOISE_TIME);
			R10sec = (int)((Rlist->arr[i + 1] - 0.3*fs) / fs / NOISE_TIME);
			for (j = Rsec; j < R1sec; j++)
			{
				if (noiselist->arr[j] == 1)
				{
					RRlist->arr[i] = RRmean;
					flag0 = 1;
					break;
				}
			}
			if ((noiselist->arr[R10sec] == 1) && (i<RRlist->count - 1))
				RRlist->arr[i + 1] = RRmean;

			if (flag0 == 0)
			{
				max = 0;
				min = 0;
				max_p = 0;
				min_p = 0;
				if (RRlist->arr[i]>1.5*RRmean&&RRlist->arr[i] < 2.5*RRmean)
				{
					R_s = (int)(Rlist->arr[i] + (RRlist->arr[i] / 2000.0 - 0.25)*fs);
					R_e = (int)(R_s + 0.5*fs);
					for (k = R_s; k < R_e; k++)
					{
						if (buf->orig00[k] < min)
						{
							min = buf->orig00[k];
							min_p = k;
						}
						if (buf->orig00[k] > max)
						{
							max = buf->orig00[k];
							max_p = k;
						}
					}

					if (max - min > 0.6*buf->temp_maxdiff&&buf->temp_maxdiff > 50)
					{
						RRlist->arr[i] = RRmean;
					}
				}
			}
		}
	}
	return 0;
}

int maindetect::GETHRVTI(long *pr, int **RRhis, int count)
{
	int maxRR = 0;
	int i = 0;
	int j = 0;
	while (i<count)
	{
		if (pr[i]>maxRR)
			maxRR = pr[i];
		i = i + 1;
	}
	i = 0;
	int nump = (int)(maxRR / 7.8125) + 1;
	int *pp = new int[nump];
	*RRhis = pp;
	while (j < nump)
	{
		i = 0;
		pp[j] = 0;
		while (i<count)
		{
			if ((pr[i]>7.8125*j) && (pr[i] <= 7.8125*(j + 1)))
			{
				pp[j]++;

			}
			i = i + 1;
		}
		j = j + 1;
	}
	return nump;
}

string maindetect::getrelative(int type)
{
	string typestring;
	switch (type)
	{
	case 1:
		typestring = "SA";
		break;
	case 2:
		typestring = "MB";
		break;
	case 3:
		typestring = "VPB";
		break;
	case 4:
		typestring = "APB";
		break;
	case 5:
		typestring = "IVBP";
		break;
	case 6:
		typestring = "VT";
		break;
	case 7:
		typestring = "BG";
		break;
	case 8:
		typestring = "TRG";
		break;
	case 9:
		typestring = "ST";
		break;
	case 10:
		typestring = "SB";
		break;
	case 11:
		typestring = "WS";
		break;

	case 12:
		typestring = "AR";
	}
	return typestring;
}

int* maindetect::getposL(LONG_ARR *Rannolist, int abNum, int abtype,
	LONG_ARR *Rlist, double fs)
{
	int ll;
	int j = 0;
	int *abpos = new int[abNum];
	for (ll = 0; (ll < Rannolist->count) && (j < abNum); ll++)
	{
		if (Rannolist->arr[ll] == abtype)
		{
			abpos[j] = (int)(Rlist->arr[ll] / fs);
			j++;
		}
	}
	return abpos;
}

int maindetect::findnextpos(LONG_ARR *Rannolist, long pos)
{
	int ll;
	int nextpos = 0;
	for (ll = pos; ll < Rannolist->count; ll++)
	{
		if (Rannolist->arr[ll] != 0 && Rannolist->arr[ll] != -1)
		{
			nextpos = ll;
			break;
		}
	}
	return nextpos;
}

int maindetect::getAbecgseg(LONG_ARR Rannolist, double *orig00, long ecgnum,
	LONG_ARR *Rlist, int length, double sample)
{
	int ll;
	int nextpos = 0;
	int start = 0;
	int end = 0;
	int Abseg = 0;
	char spos[10];
	char stime[10];
	long pos = 0;
	string stypestring;
	string stypespos;
	string segstime;
	int ARpos = 5;

	struct AbECG *useAbEcg = new AbECG[Rannolist.count];
	result.AbECG = useAbEcg;
	if (result.flagAR > 0)
	{
		Abseg++;
		start = storeAbecgfile(ARpos, orig00, ecgnum, Rlist, result.AbECG,
			length, Abseg - 1);
		pos = 0;
		pos = Rlist->arr[ARpos];
		sprintf(stime, "%ld", (long)(start / sample));
		segstime = string(stime);
		result.AbECG->AbECGTime = segstime;

		sprintf(spos, "%ld", pos - start); 
		stypespos = string(spos);

		result.AbECG->AbECGType = "AR:" + stypespos;
		result.AbECG++;
	}
	if (result.Polycardia > 0)
	{
		Abseg++;
		start = storeAbecgfile(result.Fastest_Time, orig00, ecgnum, Rlist,
			result.AbECG, length, Abseg - 1);
		pos = 0;
		pos = Rlist->arr[result.Fastest_Time];
		sprintf(stime, "%ld", (long)(start / sample)); 
		segstime = string(stime);
		result.AbECG->AbECGTime = segstime;
		sprintf(spos, "%ld", pos - start);
		stypespos = string(spos);

		result.AbECG->AbECGType = "ST:" + stypespos;
		result.AbECG++;
	}
	if (result.Bradycardia > 0)
	{
		Abseg++;
		start = storeAbecgfile(result.Slowest_Time, orig00, ecgnum, Rlist,
			result.AbECG, length, Abseg - 1);
		pos = 0;
		pos = Rlist->arr[result.Slowest_Time];//error pos = Rlist->arr[result.Slowest_Beat]
		sprintf(stime, "%ld", (long)(start / sample)); // // error
		segstime = string(stime);
		result.AbECG->AbECGTime = segstime;

		sprintf(spos, "%ld", pos - start); // 10xss
		stypespos = string(spos);

		result.AbECG->AbECGType = "SB:" + stypespos;
		result.AbECG++;
	}

	for (ll = 0; ll < Rannolist.count; ll++)
	{
		while (Rannolist.arr[ll] == 0 || Rannolist.arr[ll] == -1)
		{
			ll++;
		}
		if ((Rannolist.arr[ll] != 0) && (ll < Rannolist.count))
		{
			Abseg++;
			start = storeAbecgfile(ll, orig00, ecgnum, Rlist, result.AbECG,
				length, Abseg - 1);

			end = start + length;
			if (end >= ecgnum)
				end = ecgnum - 1;

			stypestring = getrelative(Rannolist.arr[ll]);
			sprintf(spos, "%ld", Rlist->arr[ll] - start);
			stypespos = string(spos);
			sprintf(stime, "%ld", (long)(start / sample));
			segstime = string(stime);
			result.AbECG->AbECGTime = segstime;
			result.AbECG->AbECGType = stypestring + ":" + stypespos;
		}
		while (Rlist->arr[ll] < end - 100)
		{
			nextpos = findnextpos(&Rannolist, ll + 1);
			if (nextpos == 0)
			{
				result.AbECG++;
				break;
			}
			if (Rlist->arr[nextpos] < end - 100)
			{
				stypestring = getrelative(Rannolist.arr[ll]);
				sprintf(spos, "%ld", Rlist->arr[nextpos] - start);
				stypespos = string(spos);
				result.AbECG->AbECGType = result.AbECG->AbECGType + ","
					+ stypestring + ":" + stypespos;
			}
			else
			{
				result.AbECG++;
				break;
			}
			ll = nextpos;
		}

	}
	result.AbECG = useAbEcg;
	result.AbECGNum = Abseg;
	return 0;
}

int maindetect::storeAbecgfile(int pos, double *orig00, long ecgnum,
	LONG_ARR *Rlist, struct AbECG *abECG, int length, int Abnum)
{

	ofstream ofs;

	long ll;
	long realpos = 0;
	long start = 0;
	long end = 0;
	realpos = Rlist->arr[pos];
	if ((realpos - (int)(length / 2)) > 0)
	{
		start = realpos - (int)(length / 2);
	}
	else
		start = 0;

	if ((realpos + (int)(length / 2)) < ecgnum)
	{
		end = realpos + (int)(length / 2);
		if (start == 0 && ecgnum > length)
			end = length;
	}
	else
		end = ecgnum - 1;

	char s[4];

	std::string Abnumstring = std::string(s);

	if (abECG)
		abECG->AbECGfile = filePath + Abnumstring + std::string(".txt");

	if (end > start)
	{

		ofs.open(abECG->AbECGfile.c_str(), ostream::app);

		for (ll = start; ll < end; ll++)
		{
			ofs << orig00[ll];
			ofs << "\n";
		}
		ofs.close();
	}
	else
	{
		return -1;
	}

	return start;

}

LONG_ARR maindetect::getQRSWIDTHlist(LONG_ARR *QRS_startlist,
	LONG_ARR *QRS_endlist, double fs)
{
	long i = 0;
	LONG_ARR QRSlist;
	QRSlist.arr = (long *)malloc((QRS_startlist->count) * sizeof(long));
	QRSlist.count = 0;

	for (i = 0; i < QRS_startlist->count; i++)
	{
		if (QRS_endlist->arr[i] * QRS_startlist->arr[i] == 0)
		{
			QRSlist.arr[i] = 100;
		}
		else
		{
			QRSlist.arr[i] = (long)((QRS_endlist->arr[i]
				- QRS_startlist->arr[i]) / fs * 1000);
		}
		QRSlist.count++;
	}
	return QRSlist;
}

double maindetect::getmean(LONG_ARR *list)
{
	double mean = 0;
	long i = 0;
	double sum = 0;
	for (i = 0; i < list->count; i++)
	{
		sum += list->arr[i];
	}
	if (i != 0)
	{
		mean = sum / i;
	}
	return mean;
}

double maindetect::getallRRmean(LONG_ARR *Rlist, LONG_ARR *RRlist, LONG_ARR *noiselist, double fs)
{
	int i = 0;
	int j = 0;
	int count = 0;
	int R_s = 0;
	int R_e = 0;
	int Rsec = 0;
	int R1sec = 0;
	int flag0 = 0;
	double allRRmean = 0;
	for (i = 0; i<RRlist->count; i++)
	{
		flag0 = 0;
		if (RRlist->arr[i]>1100)
		{
			Rsec = (int)(Rlist->arr[i] / fs / NOISE_TIME);
			R1sec = (int)(Rlist->arr[i + 1] / fs / NOISE_TIME);

			for (j = Rsec; j < R1sec; j++)
			{
				if (noiselist->arr[j] == 1)
				{
					flag0 = 1;
					break;
				}
			}
		}
		if (flag0 == 0)
		{
			allRRmean = allRRmean + RRlist->arr[i];
			count++;
		}
	}
	if (count != 0)
		allRRmean = allRRmean / count;
	else
		allRRmean = 0;
	return allRRmean;
}

double maindetect::getRRmean(LONG_ARR *RRlist)
{
	double RRmean = 0;
	long i = 0;
	int k = 0;
	double sum = 0;
	for (i = 0; i < RRlist->count; i++)
	{
		if (RRlist->arr[i]>350 && RRlist->arr[i] < 1500)
		{
			sum += RRlist->arr[i];
			k++;
		}
	}
	RRmean = sum / k;

	return RRmean;
}

int maindetect::gethighlowheart(LONG_ARR *RRlist, LONG_ARR *Rlist,
	long heartneed, double fs, ecg_result *result)
{
	long iseg = 0;
	long i = 0, j = 0;
	iseg = (long)(RRlist->count / heartneed);
	double RRsum = 0;

	int falgchao = 0;
	int chaopos = 0;

	int heartrate = 0;
	int ratehigh = 0;
	int ratehighpos = 0;
	int ratelow = 0;
	int ratelowpos = 0;

	int segRRlong = 0;
	int segRRshort = 0;
	if (iseg > 0)
	{
		for (i = 0; i < iseg; i++)
		{
			segRRlong = 0;
			segRRshort = 0;
			RRsum = 0;
			for (j = 0; j < heartneed; j++)
			{
				if (j == 0)
				{
					segRRlong = RRlist->arr[i * heartneed + j];
					segRRshort = RRlist->arr[i * heartneed + j];
				}
				else
				{
					if (segRRlong < RRlist->arr[i * heartneed + j])
						segRRlong = RRlist->arr[i * heartneed + j];
					if (segRRshort > RRlist->arr[i * heartneed + j])
						segRRshort = RRlist->arr[i * heartneed + j];
				}

				RRsum += RRlist->arr[i * heartneed + j];
			}

			if ((segRRlong - segRRshort > 150) && (falgchao == 0))
			{
				falgchao = 1;
				chaopos = i * heartneed + (int)(heartneed / 2);
			}

			heartrate = (int)(60.0 * 1000 / (RRsum / heartneed));
			if (i == 0)
			{
				ratehigh = heartrate;
				ratehighpos = i * heartneed + (int)(heartneed / 2);
				ratelow = heartrate;
				ratelowpos = i * heartneed + (int)(heartneed / 2);

			}
			else
			{
				if (heartrate > ratehigh)
				{
					ratehigh = heartrate;
					ratehighpos = i * heartneed + (int)(heartneed / 2);
				}
				if (heartrate < ratelow)
				{
					ratelow = heartrate;
					ratelowpos = i * heartneed + (int)(heartneed / 2);
				}
			}
		}
	}
	else
	{
		for (j = 0; j < RRlist->count; j++)
		{
			if (segRRlong < RRlist->arr[j])
				segRRlong = RRlist->arr[j];
			if (segRRshort > RRlist->arr[j])
				segRRshort = RRlist->arr[j];

			RRsum += RRlist->arr[j];
		}

		if ((segRRlong - segRRshort > 0.14) && (falgchao == 0))
		{
			falgchao = 1;
			chaopos = (int)(RRlist->count / 2);
		}

		heartrate = (int)(60.0 * 1000 / (RRsum / RRlist->count));

		ratehigh = heartrate;
		ratehighpos = (int)(RRlist->count / 2);

		ratelow = heartrate;
		ratelowpos = (int)(RRlist->count / 2);

	}

	result->Fastest_Beat = ratehigh;
	result->Fastest_Time = ratehighpos;
	result->Slowest_Beat = ratelow;
	result->Slowest_Time = ratelowpos;

	return 0;
}

int maindetect::getothers(LONG_ARR *RRlist, LONG_ARR *QRSlist,
	LONG_ARR *Rannolist, ecg_result *result, double pvpercent,
	double papercent, long arrest_time, long VT_value, LONG_ARR *Rlist,
struct data_buffer *buf)
{
	int i, j;
	double RRmeannew = 0;

	int dropnum = 0;
	int pv = 0;
	int pa = 0;
	int insertnum = 0;
	int widenum = 0;
	int erlianlv = 0;
	int sanlianlv = 0;
	int shisu = 0;
	int arrest = 0;

	for (i = 0; i < 8; i++)
	{
		RRmeannew += RRlist->arr[i];
	}
	RRmeannew = RRmeannew / 8.0;

	for (i = 1; i < RRlist->count - 1; i++)
	{
		if (QRSlist->arr[i] > 120)
			widenum++;

		if (i >= 7)
		{
			RRmeannew = 0;
			for (j = 0; j < 8; j++)
			{
				RRmeannew += RRlist->arr[i - j];
			}
			RRmeannew = RRmeannew / 8.0;
		}

		if (RRlist->arr[i] < arrest_time)
		{
			if ((i >= 2) && (i + 7 < RRlist->count))
			{
				if (RRlist->arr[i] < (60000.0 / VT_value) && RRlist->arr[i + 1]
					< (60000.0 / VT_value) && RRlist->arr[i + 2] < (60000.0
					/ VT_value) && QRSlist->arr[i] > 130 && QRSlist->arr[i
					+ 1] > 130 && QRSlist->arr[i + 2] > 130)
				{
					if (fabs(buf->orig00[Rlist->arr[i]] - buf->ecgmean) > 0.8 * fabs(buf->orig00[Rlist->arr[i - 1]] - buf->ecgmean) && fabs(
						buf->orig00[Rlist->arr[i + 1]] - buf->ecgmean) > 0.8 * fabs(buf->orig00[Rlist->arr[i - 1]] - buf->ecgmean) && fabs(
		buf->orig00[Rlist->arr[i + 2]] - buf->ecgmean) > 0.8 * fabs(buf->orig00[Rlist->arr[i - 1]] - buf->ecgmean))
					{
						shisu++;
						Rannolist->arr[i] = 6;
						if (Rannolist->arr[i + 1] != 1)
						{
							shisu++;
							Rannolist->arr[i + 1] = 6;
						}
						if (Rannolist->arr[i + 2] != 1)
						{
							shisu++;
							Rannolist->arr[i + 2] = 6;
						}
					}
					i = i + 2;
				}
				else if (QRSlist->arr[i] > 125 && QRSlist->arr[i + 1] <= 120 && QRSlist->arr[i + 2] > 125 && QRSlist->arr[i + 3]
					<= 120 && QRSlist->arr[i + 4] > 125 && QRSlist->arr[i + 5] <= 120)
				{
					if ((RRlist->arr[i - 1] < (1 - pvpercent) * RRmeannew) && (RRlist->arr[i + 1] < (1 - pvpercent)
						* RRmeannew) && (RRlist->arr[i + 3] < (1 - pvpercent) * RRmeannew) && (RRlist->arr[i] > (1
						+ pvpercent) * RRmeannew) && (RRlist->arr[i + 2] > (1 + pvpercent) * RRmeannew) && (RRlist->arr[i
						+ 4] > (1 + pvpercent) * RRmeannew))
					{
						erlianlv++;
						Rannolist->arr[i] = 7;
						if (Rannolist->arr[i + 2] != 1)
						{
							erlianlv++;
							Rannolist->arr[i + 2] = 7;
						}
						if (Rannolist->arr[i + 4] != 1)
						{
							erlianlv++;
							Rannolist->arr[i + 4] = 7;
						}
						i = i + 5;
					}
				}
				else if (QRSlist->arr[i] > 125 && QRSlist->arr[i + 1] <= 120 && QRSlist->arr[i + 2] <= 120 && QRSlist->arr[i + 3]
	> 125 && QRSlist->arr[i + 4] <= 120 && QRSlist->arr[i + 5] <= 120 && QRSlist->arr[i + 6] > 125
	&& QRSlist->arr[i + 7] <= 120 && QRSlist->arr[i + 8] <= 120)
				{
					if ((RRlist->arr[i + 2] < (1 - pvpercent) * RRmeannew)
						&& (RRlist->arr[i + 1] < 1.1 * RRmeannew)
						&& (RRlist->arr[i + 1] > 0.9 * RRmeannew)
						&& (RRlist->arr[i + 5] < (1 - pvpercent)
						* RRmeannew) && (RRlist->arr[i + 4] < 1.1
						* RRmeannew) && (RRlist->arr[i + 4] > 0.9
						* RRmeannew) && (RRlist->arr[i + 3] > (1
						+ pvpercent) * RRmeannew) && (RRlist->arr[i + 6]
					> (1 + pvpercent) * RRmeannew))
					{
						sanlianlv++;
						Rannolist->arr[i] = 8;
						if (Rannolist->arr[i + 3] != 1)
						{
							sanlianlv++;
							Rannolist->arr[i + 3] = 8;
						}
						if (Rannolist->arr[i + 6] != 1)
						{
							sanlianlv++;
							Rannolist->arr[i + 6] = 8;
						}
						i = i + 8;
					}
				}
				else if (abs(RRlist->arr[i - 1] + RRlist->arr[i] - RRmeannew) < 0.3* RRmeannew && abs(RRlist->arr[i - 1] + RRlist->arr[i]
					- RRlist->arr[i - 2]) < 0.3* RRlist->arr[i - 2] && fabs(buf->orig00[Rlist->arr[i]] - buf->ecgmean) > 0.8
					* fabs(buf->orig00[Rlist->arr[i - 1]] - buf->ecgmean))
				{
					{
						insertnum++;
						Rannolist->arr[i] = 5;
						i = i + 1;
					}
				}
				else if ((RRlist->arr[i - 1] < (1 - pvpercent) * RRlist->arr[i - 2]) && (RRlist->arr[i] < (1 - pvpercent) * RRmeannew)
					&& (RRlist->arr[i + 1] > (1 + pvpercent) * RRmeannew) && (RRlist->arr[i + 1] > (1 + pvpercent)
					* RRlist->arr[i + 2]))
				{
					if (QRSlist->arr[i - 1] < 120 && QRSlist->arr[i] > 130
						&& QRSlist->arr[i + 1] > 130 && QRSlist->arr[i + 2] < 120)
					{
						pv++;
						Rannolist->arr[i] = 3;
						i++;
						if (Rannolist->arr[i] != 1)
						{
							pv++;
							Rannolist->arr[i] = 3;
						}
						i = i + 1;
					}
					else if (QRSlist->arr[i - 1] < 120 && QRSlist->arr[i] < 120 && QRSlist->arr[i + 1] < 120 && QRSlist->arr[i + 2]
						< 120 && (RRlist->arr[i - 1] < (1 - papercent) * RRlist->arr[i - 2]))
					{
						pa++;
						Rannolist->arr[i] = 4;
						i++;
						if (Rannolist->arr[i] != 1)
						{
							pa++;
							Rannolist->arr[i] = 4;
						}
						i = i + 1;
					}

				}
				else if (RRlist->arr[i - 1] < (1 - pvpercent) * RRmeannew && (RRlist->arr[i] > (1 + pvpercent)
					* RRlist->arr[i - 1]))
				{
					if (QRSlist->arr[i] > 120)
					{
						if ((RRlist->arr[i] > (1 + pvpercent) * RRmeannew) && (RRlist->arr[i - 1] < ((1 - 0.0)
							* RRlist->arr[i - 2])) && (fabs(buf->orig00[Rlist->arr[i]] - buf->ecgmean)
							> 0.35 * fabs(buf->orig00[Rlist->arr[i - 1]] - buf->ecgmean)))
						{
							pv++;
							Rannolist->arr[i] = 3;
							i = i + 1;
						}
					}
					else
					{
						if ((RRlist->arr[i] > ((1 + pvpercent) * RRmeannew))
							&& (RRlist->arr[i] > RRlist->arr[i + 1]) && (RRlist->arr[i - 1] < ((1 - pvpercent)
							* RRlist->arr[i - 2])) && fabs(buf->orig00[Rlist->arr[i]] - buf->ecgmean)
							> 0.65 * fabs(buf->orig00[Rlist->arr[i - 1]] - buf->ecgmean))

						{
							if ((buf->orig00[Rlist->arr[i]] - buf->ecgmean)
								* (buf->orig00[Rlist->arr[i - 1]]
								- buf->ecgmean) < 0
								&& (buf->orig00[Rlist->arr[i]]
								- buf->ecgmean)
								* (buf->orig00[Rlist->arr[i + 1]]
								- buf->ecgmean) < 0)
							{
								pv++;
								Rannolist->arr[i] = 3;
								i = i + 1;
							}
							else
							{
								pa++;
								Rannolist->arr[i] = 4;
								i = i + 1;
							}
						}
					}

				}
				else if ((abs(RRlist->arr[i] - 2 * RRmeannew) < 0.4 * RRmeannew)
					&& (abs(RRlist->arr[i] - 2 * RRlist->arr[i - 1]) < 0.2
					* RRlist->arr[i - 1]) && (abs(
					RRlist->arr[i] - 2 * RRlist->arr[i + 1]) < 0.2
					* RRlist->arr[i + 1]))
				{
					if (RRlist->arr[i] < arrest_time)
					{
						dropnum++;
						Rannolist->arr[i] = 2;
					}
				}
				else if (wideflag == 0 && QRSlist->arr[i] > 120
					&& QRSlist->arr[i + 1] > 120 && QRSlist->arr[i + 2]
					> 120 && QRSlist->arr[i + 3] > 120 && QRSlist->arr[i
					+ 4] > 120 && QRSlist->arr[i + 5] > 120
					&& QRSlist->arr[i + 6] > 120 && QRSlist->arr[i + 7]
						> 120)
				{
					Rannolist->arr[i] = 11;
					wideflag = i;
				}
			}
			else
			{
				if (RRlist->arr[i - 1] < (1 - pvpercent) * RRmeannew)
				{
					if (QRSlist->arr[i] > 120)
					{
						if ((RRlist->arr[i] > (1 + pvpercent) * RRmeannew)
							&& (RRlist->arr[i] > ((1 + pvpercent)* RRlist->arr[i - 1])))
						{
							pv++;
							Rannolist->arr[i] = 3;
							i = i + 1;
						}
					}
					else
					{
						if (RRlist->arr[i] > ((1 + pvpercent) * RRmeannew - 20))
						{
							pa++;
							Rannolist->arr[i] = 4;
							i = i + 1;
						}
					}
				}
				else if ((abs(RRlist->arr[i] - 2 * RRmeannew) < 0.4 * RRmeannew)
					&& (abs(RRlist->arr[i] - 2 * RRlist->arr[i - 1]) < 0.2* RRlist->arr[i - 1]) && (abs(
					RRlist->arr[i] - 2 * RRlist->arr[i + 1]) < 0.2* RRlist->arr[i + 1]))
				{
					if (RRlist->arr[i] < arrest_time)
					{
						dropnum++;
						Rannolist->arr[i] = 2;
					}
				}
				else if (i + 2 < RRlist->count)
				{
					if (RRlist->arr[i] < (60000.0 / VT_value) && RRlist->arr[i
						+ 1] < (60000.0 / VT_value) && RRlist->arr[i + 2]
						< (60000.0 / VT_value) && QRSlist->arr[i] > 130
						&& QRSlist->arr[i + 1] > 130 && QRSlist->arr[i + 2]
					> 130)
					{
						shisu++;
						Rannolist->arr[i] = 6;
						if (Rannolist->arr[i + 1] != 1)
						{
							shisu++;
							Rannolist->arr[i + 1] = 6;
						}

						if (Rannolist->arr[i + 2] != 1)
						{
							shisu++;
							Rannolist->arr[i + 2] = 6;
						}
						i = i + 2;
					}
				}
			}
		}
		else
		{
			Rannolist->arr[i] = 1;
			arrest++;
		}
	}

	if (wideflag != 0)
	{
		if (widenum > 0.6*Rlist->count)
		{
			widenum = 1;
		}
		else
		{
			Rannolist->arr[wideflag] = 0;
			widenum = 0;
		}
	}
	else
	{
		widenum = 0;
	}
	result->PAB = pa;
	result->PVB = pv;
	result->Insert_PVBnum = insertnum;
	result->Missed_Num = dropnum;
	result->Wide_Num = widenum;
	result->Bigeminy_Num = erlianlv;
	result->Trigeminy_Num = sanlianlv;
	result->VT = shisu;
	result->Arrest_Num = arrest;
	return 0;
}

int maindetect::fabsint(int a)
{
	if (a >= 0)
		return a;
	else
		return -a;
}

int maindetect::pre_process_data(double **values, long num)
{
	double *t;
	long l, w;

	t = (double *)malloc(sizeof(double)* num);

	w = 2;
	for (l = 0; l < (w - 1); l++)
		t[l] = (*values)[l];
	for (l = (w - 1); l < num; l++)
	{
		long m;
		double s = 0.0;
		for (m = 0; m < w; m++)
			s += (*values)[l - m];
		t[l] = s / w;
	}

	free(*values);
	*values = t;

	return 0;
} 

int maindetect::process_values(LONG_ARR *RRlist, LONG_ARR *Rlist,
	double **value, double samplerate_orig, double samplerate,
	long *real_num)
{
	long l;
	*real_num = (long)(RRlist->count);

	double *pos = (double *)malloc(sizeof(double)* RRlist->count);
	*value = (double *)malloc(sizeof(double)* RRlist->count);
	for (l = 0; l < RRlist->count; l++)
	{
		(pos)[l] = (long)(Rlist->arr[l]) / samplerate_orig;
		(*value)[l] = (long)(RRlist->arr[l]);
	}

	long num_i, idx_after;
	double *val_i, *pos_i;
	double range, pos_add, pos_before, pos_after, val_before, val_after,
		curr_pos;

	if ((samplerate <= 0.0) || (*real_num < 2))
		return -1;

	range = (pos)[*real_num - 1] - (pos)[0];
	num_i = (long)(range * samplerate);
	val_i = (double *)malloc(sizeof(double)* num_i);
	pos_i = (double *)malloc(sizeof(double)* num_i);

	pos_add = 1 / samplerate;
	idx_after = 1;
	pos_before = (pos)[0];
	pos_after = (pos)[1];
	val_before = (*value)[0];
	val_after = (*value)[1];
	curr_pos = pos_before;
	for (l = 0; l < num_i; l++)
	{
		double dist, slope;

		while (curr_pos > pos_after)
		{
			idx_after++;
			if (idx_after >= *real_num)
				break;

			pos_before = (pos)[idx_after - 1];
			pos_after = (pos)[idx_after];
			val_before = (*value)[idx_after - 1];
			val_after = (*value)[idx_after];
		}
		if (idx_after >= *real_num)
			break;

		dist = curr_pos - pos_before;
		slope = (val_after - val_before) / (pos_after - pos_before);
		val_i[l] = val_before + slope * dist;
		pos_i[l] = curr_pos;
		curr_pos += pos_add;
	}

	*real_num = l;
	free(*value);
	free(pos);
	free(pos_i);
	*value = val_i;

	pre_process_data(value, *real_num);

	return 0;
}

LONG_ARR maindetect::getRRlist(LONG_ARR *Rlist, double fs)
{
	long i = 0;
	LONG_ARR RRlist;
	RRlist.arr = (long *)malloc((Rlist->count - 1) * sizeof(long));
	RRlist.count = 0;

	for (i = 0; i < Rlist->count - 1; i++)
	{
		RRlist.arr[i]
			= (long)((Rlist->arr[i + 1] - Rlist->arr[i]) / fs * 1000);
		RRlist.count++;
	}

	return RRlist;
}

int maindetect::getAR_high(LONG_ARR *RRlist, LONG_ARR *Rannolist, double RRmean)//LSJ
{
	long i = 0;
	LONG_ARR HRVlist;
	HRVlist.arr = (long *)malloc((RRlist->count - 1) * sizeof(long));
	HRVlist.count = 0;
	double HRVmean = 0;
	long HRVABnum = 0;
	int flagSA = 0;

	for (i = 0; i < RRlist->count - 1; i++)
	{
		HRVlist.arr[i] = RRlist->arr[i + 1] - RRlist->arr[i];//
		HRVlist.count++;
	}
	for (i = 1; i < HRVlist.count; i++)
	{
		if (abs(HRVlist.arr[i]) < 2000)
		{
			if ((Rannolist->arr[i + 2] == 0 || Rannolist->arr[i + 2] == 4)
				&& (Rannolist->arr[i + 1] == 0) && (Rannolist->arr[i] == 0
				|| Rannolist->arr[i] == 4) && (Rannolist->arr[i - 1] == 0
				|| Rannolist->arr[i - 1] == 4))
			{
				HRVABnum = HRVABnum + 1;
				HRVmean += abs(HRVlist.arr[i]);
			}
		}
	}
	HRVmean /= HRVABnum;
	if (HRVmean > 0.10 * RRmean && HRVABnum > 5)
		flagSA = 1;

	return flagSA;
}

int maindetect::find_peaks(struct data_buffer *buf, double *sig_use,
	long start, long num, double threshold, double area_filt,
struct peak_buffer **peaks, long *num_peaks, long *morph_type,
	long ms30, int allow_look_before, int allow_look_after)
{
	int ret = 0;
	int *flag = NULL;
	struct peak_buffer *p_temp = NULL;
	long l, m, idx, start_use, num_use;
	double max;
	int look_begin;

	if ((buf == NULL) || (sig_use == NULL) || (peaks == NULL) || (num_peaks
		== NULL) || (morph_type == NULL))
		return -1;

	*num_peaks = 0;
	start_use = start;
	num_use = num;

	if (allow_look_before)
	{
		for (l = start_use; l >= 0; l--)
		{
			if (fabs(sig_use[l]) <= threshold)
				break;
			if ((sig_use[l + 1] >= threshold) && (sig_use[l] <= threshold))
				break;
			if ((sig_use[l + 1] <= threshold) && (sig_use[l] >= threshold))
				break;
			start_use--;
			num_use++;
		}
	}
	if (allow_look_after)
	{
		for (l = (start_use + num_use); l < buf->num_data; l++)
		{
			if (fabs(sig_use[l]) <= threshold)
				break;
			if ((sig_use[l - 1] >= threshold) && (sig_use[l] <= threshold))
				break;
			if ((sig_use[l - 1] <= threshold) && (sig_use[l] >= threshold))
				break;
		}
		num_use = l - start_use + 1;

	}

	if (num_use > 0)
	{
		flag = (int *)calloc(num_use, sizeof(int));
		if (!flag)
		{
			printf("Not Enough Memory!\n");
			return 0;
		}

		for (l = 0; l < num_use; l++)
		{
			if (sig_use[start_use + l] > threshold)
				flag[l] = 1;
			if (sig_use[start_use + l] < -threshold)
				flag[l] = -1;
		}
	}

	look_begin = 1;
	for (l = 1; l < num_use; l++)
	{
		if (flag[l] == flag[l - 1])
			continue;
		if (look_begin)//
		{
			if (flag[l] != 0)
			{
				(*num_peaks)++;
				(*peaks) = (peak_buffer *)realloc(*peaks,
					sizeof(struct peak_buffer) * (*num_peaks));
				(*peaks)[*num_peaks - 1].start = l + start_use;
				look_begin = 0;
			}
		}
		else
		{
			if (flag[l - 1] != 0)
			{
				(*peaks)[*num_peaks - 1].end = l - 1 + start_use;

				(*peaks)[*num_peaks - 1].amp
					= sig_use[(*peaks)[*num_peaks - 1].start];
				(*peaks)[*num_peaks - 1].idx = (*peaks)[*num_peaks - 1].start;
				for (m = ((*peaks)[*num_peaks - 1].start + 1); m < (l
					+ start_use); m++)//
				{
					if ((flag[l - 1] > 0) && (sig_use[m] > (*peaks)[*num_peaks
						- 1].amp))
					{
						(*peaks)[*num_peaks - 1].amp = sig_use[m];
						(*peaks)[*num_peaks - 1].idx = m;
					}
					if ((flag[l - 1] < 0) && (sig_use[m] < (*peaks)[*num_peaks
						- 1].amp))
					{
						(*peaks)[*num_peaks - 1].amp = sig_use[m];
						(*peaks)[*num_peaks - 1].idx = m;
					}
				}
			}

			if (fabsint(flag[l - 1] - flag[l]) == 2)
			{
				(*num_peaks)++;
				(*peaks) = (peak_buffer *)realloc(*peaks,
					sizeof(struct peak_buffer) * (*num_peaks));
				(*peaks)[*num_peaks - 1].start = l + start_use;
				look_begin = 0;
			}
			else
				look_begin = 1;
		}
	}

	if (look_begin == 0)
		(*num_peaks)--;

	if (flag)
		free(flag);

	if (*peaks == NULL)
	{
		*num_peaks = 0;
		return 0;
	}

	if (*num_peaks >= 4)
	{
		max = fabs((*peaks)[0].amp);
		idx = 0;
		for (l = 1; l < (*num_peaks); l++)
		{
			if (fabs((*peaks)[l].amp) > max)
			{
				max = fabs((*peaks)[l].amp);
				idx = l;
			}
		}

		for (l = idx + 1; l < (*num_peaks); l++)
		{
			if ((*peaks)[l].idx - (*peaks)[l - 1].idx > 4 * ms30)
			{
				*num_peaks = l;
				break;
			}
		}
		for (l = idx - 1; l >= 0; l--)
		{
			if (-(*peaks)[l].idx + (*peaks)[l + 1].idx > 4 * ms30)
			{
				*num_peaks -= (l + 1);
				memmove((*peaks), (*peaks) + l + 1, sizeof(struct peak_buffer) * (*num_peaks));
				break;
			}
		}
	}

	double sum4peak = 0;
	if (*num_peaks > 4)
	{
		max = fabs((*peaks)[0].amp);
		idx = 0;
		for (l = 0; l < (*num_peaks) - 3; l++)
		{
			sum4peak = fabs((*peaks)[l].amp) + fabs((*peaks)[l + 1].amp)
				+ fabs((*peaks)[l + 2].amp) + fabs((*peaks)[l + 3].amp);
			if (sum4peak > max)
			{
				max = sum4peak;
				idx = l;
			}
		}
		memmove((*peaks), (*peaks) + idx, sizeof(struct peak_buffer) * 4);
		*num_peaks = 4;
	}

	*morph_type = 0;
	for (l = 0; l < *num_peaks; l++)
	{
		if (l > 0)
			(*morph_type) *= 10;
		if ((*peaks)[l].amp > 0)
			(*morph_type) += 2;
		else
			(*morph_type) += 1;
	}

	if (p_temp)
		free(p_temp);

	return ret;
}

int maindetect::get_peaks(struct data_buffer *buf, double *sig_use, long start,
	long num, double threshold, double area_filt,struct peak_buffer **peaks, long *num_peaks, long *morph_type,
	long ms30, int allow_look_before, int allow_look_after)
{
	int ret;
	static int runs = 0; 

	if (runs > 30)
		return 0;
	ret = find_peaks(buf, sig_use, start, num, threshold, area_filt, peaks,
		num_peaks, morph_type, ms30, allow_look_before, allow_look_after);
	return ret;
}

int maindetect::get_qrs_complex(struct data_buffer *buf, long *curr_pos,
	long ms100, long ms50, long ms30, long *QRS_START,
	long *QRS_END, int noise)
{
	int ret = 0;
	long l, m, start_pos, end_pos, pos;
	double threshold;
	struct peak_buffer *peaks;
	long num_peaks, morph_type;
	double *sig_use;
	long max_pos = 0;
	long min_pos = 0;
	pos = *curr_pos;
	start_pos = (pos - buf->data_offset) - 4 * ms30;
	if (start_pos < 0)
		start_pos = 0;
	end_pos = (pos - buf->data_offset) + 2 * ms100;

	if (end_pos >= buf->num_data)
		end_pos = buf->num_data - 1;

	sig_use = buf->s1;

	threshold = fabs(sig_use[start_pos]);
	for (l = start_pos; l <= end_pos; l++)
	{
		if (fabs(sig_use[l]) > threshold)
			threshold = fabs(sig_use[l]);
	}
	if (noise == 0)
		threshold *= 0.25;
	else
		threshold *= 0.4;

	peaks = NULL;

	get_peaks(buf, sig_use, start_pos, (end_pos - start_pos + 1), threshold,
		0.0, &peaks, &num_peaks, &morph_type,ms30, 1, 1);

	if (num_peaks <= 0)
	{
		free(peaks);
		return -1;
	}

	double max_raw = buf->orig[peaks[0].start];

	double min_raw = buf->orig[peaks[0].start];

	max_pos = peaks[0].start;
	min_pos = peaks[0].start;

	for (m = peaks[0].start; m <= peaks[num_peaks - 1].end; m++)
	{
		if (buf->orig[m] > max_raw)
		{
			max_raw = buf->orig[m];
			max_pos = m;

		}
		if (buf->orig[m] < min_raw)
		{
			min_raw = buf->orig[m];
			min_pos = m;
		}
	}

	if (fabs((double)(buf->orig[*curr_pos - buf->data_offset] - min_raw))
		< fabs(
		(double)(buf->orig00[*curr_pos - buf->data_offset]
		- max_raw)) && (fabs(
		(double)(*curr_pos - buf->data_offset - min_pos)) < 30))
	{
		if (fabs(min_raw - buf->ecgmean) > 1.2 * fabs(max_raw - buf->ecgmean))
			*curr_pos = min_pos + buf->data_offset;
		else
			*curr_pos = max_pos + buf->data_offset;

	}
	else if (fabs((double)(buf->orig[*curr_pos - buf->data_offset] - min_raw))
		>= fabs(
		(double)(buf->orig[*curr_pos - buf->data_offset] - max_raw))
		&& (fabs((double)(*curr_pos - buf->data_offset - max_pos)) < 30))
	{
		*curr_pos = max_pos + buf->data_offset;
	}

	threshold = (0.8 * threshold);
	*QRS_START = peaks[0].start + buf->data_offset;
	for (l = peaks[0].start; l >= peaks[0].start - 30 && peaks[0].start > 43; l--)
	{
		if (fabs(sig_use[l]) < threshold && fabs(sig_use[l - 1]) < threshold
			&& fabs(sig_use[l - 3]) < threshold && fabs(sig_use[l - 5])
			< threshold && fabs(sig_use[l - 8]) < threshold && fabs(
			sig_use[l - 12]) < threshold)
		{
			*QRS_START = l + buf->data_offset;
			break;
		}
	}

	*QRS_END = peaks[num_peaks - 1].end + buf->data_offset;
	for (l = peaks[num_peaks - 1].end; l <= peaks[num_peaks - 1].end + 30
		&& peaks[num_peaks - 1].end < buf->num_data - 13; l++)
	{
		if (fabs(sig_use[l]) < threshold && fabs(sig_use[l + 1]) < threshold
			&& fabs(sig_use[l + 3]) < threshold && fabs(sig_use[l + 5])
			< threshold && fabs(sig_use[l + 8]) < threshold && fabs(
			sig_use[l + 12]) < threshold)
		{
			*QRS_END = l + buf->data_offset;
			break;
		}
	}

	free(peaks);
	return ret;
}

int maindetect::fir_filter_design(long order, double cut_low, double cut_high,
	double **b, long *num)
{
	double sum, temp;
	int coef_num, half_len, i;

	coef_num = order;
	if (order % 2 == 0)
	{
		coef_num++;
	}
	*num = coef_num;
	half_len = (coef_num - 1) / 2;

	if (b == NULL)
		return -1;
	*b = (double *)malloc(sizeof(double)* coef_num);

	if ((cut_low == 0.0) && (cut_high < 1.0))
	{
		(*b)[half_len] = cut_high;
		for (i = 1; i <= half_len; i++)
		{
			temp = PI * i;
			(*b)[half_len + i] = sin(cut_high * temp) / temp;
			(*b)[half_len - i] = (*b)[half_len + i];
		}

		temp = 2.0 * PI / (coef_num - 1.0);
		sum = 0.0;
		for (i = 0; i < coef_num; i++)
		{
			(*b)[i] *= (0.54 - 0.46 * cos(temp * i));
			sum += (*b)[i];
		}

		for (i = 0; i < coef_num; i++)
			(*b)[i] /= fabs(sum);

		return 0;
	}

	if ((cut_low > 0.0) && (cut_high == 1.0))
	{
		(*b)[half_len] = cut_low;
		for (i = 1; i <= half_len; i++)
		{
			temp = PI * i;
			(*b)[half_len + i] = sin(cut_low * temp) / temp;
			(*b)[half_len - i] = (*b)[half_len + i];
		}

		temp = 2.0 * PI / (coef_num - 1.0);
		sum = 0.0;
		for (i = 0; i < coef_num; i++)
		{
			(*b)[i] *= -(0.54 - 0.46 * cos(temp * i));
			if (i % 2 == 0)
				sum += (*b)[i];
			else
				sum -= (*b)[i];
		}

		(*b)[half_len] += 1;
		sum += 1;

		for (i = 0; i < coef_num; i++)
			(*b)[i] /= fabs(sum);

		return 0;
	} 

	if ((cut_low > 0.0) && (cut_high < 1.0) && (cut_low < cut_high))
	{
		(*b)[half_len] = cut_high - cut_low;
		for (i = 1; i <= half_len; i++)
		{
			temp = PI * i;
			(*b)[half_len + i] = 2.0 * sin((cut_high - cut_low) / 2.0 * temp)
				* cos((cut_high + cut_low) / 2.0 * temp) / temp;
			(*b)[half_len - i] = (*b)[half_len + i];
		}

		temp = 2.0 * PI / (coef_num - 1.0);
		sum = 0.0;
		for (i = 0; i < coef_num; i++)
		{
			(*b)[i] *= (0.54 - 0.46 * cos(temp * i));
			sum += (*b)[i];
		}

		for (i = 0; i < coef_num; i++)
			(*b)[i] /= fabs(sum);

		return 0;

	}
	if ((cut_low > 0.0) && (cut_high < 1.0) && (cut_low > cut_high))
	{
		(*b)[half_len] = cut_low - cut_high;
		for (i = 1; i <= half_len; i++)
		{
			temp = PI * i;
			(*b)[half_len + i] = 2.0 * sin((cut_low - cut_high) / 2.0 * temp)
				* cos((cut_high + cut_low) / 2.0 * temp) / temp;
			(*b)[half_len - i] = (*b)[half_len + i];
		}
		temp = 2.0 * PI / (coef_num - 1.0);
		sum = 0.0;
		for (i = 0; i < coef_num; i++)
		{
			(*b)[i] *= -(0.54 - 0.46 * cos(temp * i));
			sum += (*b)[i];
		}

		(*b)[half_len] += 1;
		sum += 1;
		for (i = 0; i < coef_num; i++)
			(*b)[i] /= fabs(sum);

		return 0;
	}
	return -1;
}

int maindetect::prepare_data_access(long do_interpolation, struct ecg_info *ci,
struct data_buffer *buf)
{
	long temp = 0;
	if (do_interpolation && (ci->samplerate_orig < 500))
	{
		temp = (long)(ci->samplerate_orig) / 10;
		if (((ci->samplerate_orig / 10.0) - (double)temp) != 0)
			ci->interp_factor = 512 / (long)(ci->samplerate_orig);
		else
			ci->interp_factor = 500 / (long)(ci->samplerate_orig);
		ci->samplerate = ci->samplerate_orig * (double)(ci->interp_factor);
	}

	temp = (long)(ci->samplerate * 0.1);
	ci->ms100 = temp;
	if ((temp - (double)ci->ms100) >= 0.5)
		ci->ms100++;
	temp = (long)(ci->samplerate * 0.05);
	ci->ms50 = temp;
	if ((temp - (double)ci->ms50) >= 0.5)
		ci->ms50++;
	temp = (long)(ci->samplerate * 0.03);
	ci->ms30 = temp;
	if ((temp - (double)ci->ms30) >= 0.5)
		ci->ms30++;
	temp = (long)(ci->samplerate * 0.01);
	ci->ms10 = temp;
	if ((temp - (double)ci->ms10) >= 0.5)
		ci->ms10++;

	ci->s5 = (long)(5.0 * ci->samplerate);

	buf->orig = (double*)malloc(
		sizeof(double)* BUFFER_SIZE * ci->interp_factor);
	buf->f0 = (double *)malloc(
		sizeof(double)* BUFFER_SIZE * ci->interp_factor);
	buf->f1 = (double *)malloc(
		sizeof(double)* BUFFER_SIZE * ci->interp_factor);
	buf->s1 = (double *)malloc(
		sizeof(double)* BUFFER_SIZE * ci->interp_factor);

	return 0;

}

int maindetect::filter(double *b, double *a, long order, double *data,
	long num_samples, int direction)
{
	long l, m, curr, add;
	double *xv, *yv;
	double sum_a, sum_b;

	xv = (double *)calloc(order, sizeof(double));
	yv = (double *)calloc(order, sizeof(double));

	if (direction == 0)
	{
		for (l = 0; l < order; l++)
			xv[l] = yv[l] = data[0];

		curr = 0;
		add = 1;
	}
	else
	{
		for (l = 0; l < order; l++)
			xv[l] = yv[l] = data[num_samples - 1];

		curr = num_samples - 1;
		add = -1;
	}

	for (l = 0; l < num_samples; l++)
	{
		for (m = order - 1; m > 0; m--)
		{
			xv[m] = xv[m - 1];
			yv[m] = yv[m - 1];
		}
		xv[0] = data[curr];

		sum_a = sum_b = 0.0;
		for (m = 0; m < order; m++)
		{
			if (a && (m > 0))
				sum_a += (yv[m] * a[m]);
			sum_b += (xv[m] * b[m]);
		}
		yv[0] = sum_a + sum_b;

		data[curr] = yv[0];

		curr += add;
	}
	if (xv)
		free(xv);
	if (yv)
		free(yv);

	return 0;
}

int maindetect::filtfilt(double *b, double *a, long order, double *data,
	long num_samples)
{
	int ret;
	if ((ret = filter(b, a, order, data, num_samples, 0)) != 0)
		return ret;

	if ((ret = filter(b, a, order, data, num_samples, 1)) != 0)
		return ret;

	return 0;
}

int maindetect::interp(double *in, double *out, long num_samples, long factor)
{
	int ret;
	long l;
	double *b = NULL;
	long num = 0;

	if ((in == NULL) || (out == NULL) || (num_samples <= 0) || (factor <= 0))
		return -1;
	if (factor == 1)
	{
		memcpy(out, in, sizeof(double)* num_samples);
		return 0;
	}

	ret = fir_filter_design(2 * factor + 1, 0.0, 0.5 / factor, &b, &num);
	if (ret != 0)
		return ret;

	memset(out, 0, sizeof(double)* num_samples * factor);
	for (l = 0; l < num_samples; l++)
		out[l * factor] = (double)factor * in[l];

	ret = filtfilt(b, NULL, num, out, (num_samples * factor));

	free(b);

	return ret;
}

long maindetect::get_data_new(long ch_pos,struct data_buffer *buf, long num_to_read, 
	long interp_factor,double gain, int M_WIDTH, double H_HIGHT)
{
	long l, num_read;
	double mean = 0.0;
	int ll = 0;
	long start = 0;
	num_read = num_to_read / interp_factor;
	memset((buf->orig), 0, BUFFER_SIZE * interp_factor);

	start = (long)(ch_pos / interp_factor);

	for (l = 0; l < num_read; l++)
	{
		buf->orig[l] = buf->orig00[start];//LSJ
		start = start + 1;
		mean += buf->orig[l];
	}
	mean /= (double)num_read;
	buf->ecgmean = mean;

	buf->num_data = num_read;
	if (num_read <= 0)
		return 0;

	if (interp_factor != 1)
	{
		double *buf_temp;

		buf_temp = (double *)malloc(sizeof(double)* num_read);
		memcpy(buf_temp, buf->orig, sizeof(double)* num_read);
		interp(buf_temp, buf->orig, num_read, interp_factor);

		num_read *= interp_factor;
		buf->num_data *= interp_factor;
		free(buf_temp);
	}

	double *Kvector = (double *)malloc(sizeof(double)* M_WIDTH);
	Kvector[0] = 0.0;
	Kvector[1] = 50.0;
	Kvector[2] = 100.0;
	Kvector[3] = 50.0;
	Kvector[4] = 0.0;

	memcpy(buf->f0, buf->orig, sizeof(double)* num_read);
	memcpy(buf->f1, buf->orig, sizeof(double)* num_read);
	double fmin = 0;
	double fnew = 0;
	double fmax = 0;

	int j = 0;
	for (l = 0; l < num_read - M_WIDTH; l++)
	{
		j = 0;
		fmin = buf->orig[l + j] - Kvector[j];
		for (j = 1; j < M_WIDTH; j++)
		{
			fnew = buf->orig[l + j] - Kvector[j];
			if (fnew < fmin)
				fmin = fnew;
		}
		buf->f0[l] = fmin;

	}
	for (l = num_read - M_WIDTH; l < num_read; l++)
	{
		buf->f0[l] = buf->orig[l];
	}

	for (l = 0; l < num_read - M_WIDTH; l++)
	{
		j = 0;
		fmax = buf->f0[l + j] + Kvector[j];
		for (j = 1; j < M_WIDTH; j++)
		{
			fnew = buf->f0[l + j] + Kvector[j];
			if (fnew > fmax)
				fmax = fnew;
		}
		buf->f1[l] = fmax;

	}
	for (l = num_read - M_WIDTH; l < num_read; l++)
	{
		buf->f1[l] = buf->orig[l];
	}
	buf->s1mean = 0;
	for (ll = 0; ll < num_read; ll++)
	{
		buf->s1[ll] = buf->orig[ll] - buf->f1[ll];
		buf->s1mean = buf->s1mean + fabs(buf->s1[ll]);
	}
	buf->s1mean = buf->s1mean / num_read;
	return num_read;
}

double maindetect::get_min(double *values, long num, long *pos)
{
	long l, p;
	double min;

	min = values[0];
	p = 0;
	for (l = 1; l < num; l++)
	{
		if (values[l] < min)
		{
			min = values[l];
			p = l;
		}
	}
	if (pos)
		*pos = p;

	return min;
}

double maindetect::get_max(double *values, long num, long *pos)
{
	long l, p;
	double max;

	max = values[0];
	p = 0;
	for (l = 1; l < num; l++)
	{
		if (values[l] > max)
		{
			max = values[l];
			p = l;
		}
	}
	if (pos)
		*pos = p;

	return max;
}

double maindetect::mean(double *values, long num)
{
	long l;
	double mean = 0.0;

	for (l = 0; l < num; l++)
		mean += values[l];
	mean /= (double)num;

	return mean;
}

int maindetect::remove_mean(double * v, long n)
{
	double m;
	long l;

	m = mean(v, n);
	for (l = 0; l < n; l++)
	{
		v[l] -= m;
	}
	return 0;
}

int maindetect::histogram(double *values, long num, long **hist,
	long *hist_start, long *hist_size, int bin)
{
	long l, min, max;

	if (bin <= 0)
		return -1;

	min = (long)(get_min(values, num, NULL));
	min -= (abs(min) % bin);
	max = (long)(get_max(values, num, NULL));
	max += (abs(max) % bin);

	*hist = NULL;
	*hist_size = (max - min) / bin;
	if (*hist_size <= 0)
		return 0;
	(*hist_size)++;

	*hist_start = min;
	*hist = (long *)calloc(sizeof(long), (*hist_size));

	for (l = 0; l < num; l++)
	{
		long idx = ((long)values[l] - min);
		idx /= bin;
		if ((idx >= 0) && (idx < *hist_size))
			(*hist)[idx]++;
	}
	return 0;
}

double maindetect::stddev(double *values, long num)
{
	long l;
	double s = 0.0;
	double m = mean(values, num);

	for (l = 0; l < num; l++)
	{
		double t = values[l] - m;
		s += (t * t);
	}
	s /= (double)num;
	s = sqrt(s);

	return s;
} 

double maindetect::calc_sdnn(LONG_ARR *RRlist)
{
	long l;
	long num;
	double *v;
	num = RRlist->count;

	v = (double *)malloc(sizeof(double)* num);
	for (l = 0; l < num; l++)
		v[l] = RRlist->arr[l];
	double ret = stddev(v, num);
	free(v);
	v = NULL;
	return ret;
}

double maindetect::calc_pnn50(LONG_ARR *RRlist)
{
	long l, cnt;
	double *v;
	long num50 = 0;
	double r = 0;
	long num;
	num = RRlist->count;

	v = (double *)malloc(sizeof(double)* num);
	cnt = 0;
	for (l = 1; l < num; l++)
	{
		v[cnt] = abs(RRlist->arr[l] - RRlist->arr[l - 1]);
		cnt++;
	}

	for (l = 0; l < cnt; l++)
	{
		if (v[l] >= 50)
			num50++;
	}

	r = ((double)num50 / (double)cnt) * 100.0;

	if (v)
		free(v);
	return r;
}

double maindetect::calc_rmssd(LONG_ARR *RRlist)
{
	long l, cnt;
	double *v;
	long num;
	num = RRlist->count;
	double r = 0;

	v = (double *)malloc(sizeof(double)* num);
	cnt = 0;
	for (l = 1; l < num; l++)
	{
		double t;
		t = RRlist->arr[l] - RRlist->arr[l - 1];
		v[cnt] = t * t;
		cnt++;
	}
	r = sqrt(mean(v, cnt));
	free(v);
	return r;
}

double maindetect::calc_hrvi(LONG_ARR *RRlist)
{
	long l, max_pos;
	double *v, *hist_d;
	long *hist;
	long hist_start, hist_size;
	double scale;

	long num;
	num = RRlist->count;

	double r = 0;

	scale = 128.0 / 1000.0;

	v = (double *)malloc(sizeof(double)* num);
	for (l = 0; l < num; l++)
	{
		v[l] = (RRlist->arr[l]) * scale;
		if ((v[l] - (long)v[l]) >= 0.5)
			v[l] += 1.0;
	}

	if (histogram(v, num, &hist, &hist_start, &hist_size, 1) != 0)
	{
		free(v);
		return 0;
	}
	if (hist_size <= 0)
	{
		free(v);
		free(hist);
		return 0;
	}

	hist_d = (double *)malloc(sizeof(double)* hist_size);
	for (l = 0; l < hist_size; l++)
		hist_d[l] = hist[l];

	get_max(hist_d, hist_size, &max_pos);

	if (hist[max_pos] > 0)
	{
		r = (double)num / hist[max_pos];
	}

	free(v);
	free(hist);
	free(hist_d);
	return r;
}

int maindetect::calc_poincare(LONG_ARR *RRlist, double *SD1, double *SD2)
{
	long l, cnt;
	double *x, *y, *a;
	double mean_rri;
	long num;
	num = RRlist->count;

	x = (double *)malloc(sizeof(double)* num);
	y = (double *)malloc(sizeof(double)* num);
	cnt = 0;
	for (l = 1; l < num; l++)
	{
		x[cnt] = RRlist->arr[l - 1];
		y[cnt] = RRlist->arr[l];
		cnt++;
	}

	a = (double *)malloc(sizeof(double)* cnt);
	for (l = 0; l < cnt; l++)
	{
		double t = y[l] - x[l];
		a[l] = sqrt((t * t) / 2.0);
	}
	*SD1 = stddev(a, cnt);

	mean_rri = mean(x, cnt);
	for (l = 0; l < cnt; l++)
	{
		double t = y[l] - (-x[l] + 2.0 * mean_rri);
		a[l] = sqrt((t * t) / 2.0);
	}
	*SD2 = stddev(a, cnt);

	free(a);
	free(x);
	free(y);

	return 0;
}

long calc_idx_from_freq(double samplefreq, long n_sample, double freq)
{
	double freq_step;
	long idx;

	freq_step = samplefreq / (double)n_sample;
	idx = (long)((freq / freq_step) + 0.5);

	return idx;
}

double maindetect::calc_power(double start, double end, double sample_dist_ms,
	DOUB_ARR *axislist, long n)
{
	long start_idx, end_idx, l;
	double sum;
	double freq_step;
	start_idx = calc_idx_from_freq((1000.0 / sample_dist_ms), n * 2, start) + 1;
	end_idx = calc_idx_from_freq((1000.0 / sample_dist_ms), n * 2, end);
	if (end_idx > n)
		end_idx = n;
	freq_step = (1000.0 / sample_dist_ms) / ((double)n * 2.0);
	sum = 0.0;

	for (l = start_idx; l <= end_idx; l++)
		sum += axislist->arr[l];
	sum *= freq_step;

	return sum;
}

void maindetect::window_hanning(double *v, long n, double *power)
{
	long l;
	long n2 = n / 2;

	v[n - 1] = 0.0;

	*power = 0.0;
	for (l = -n2; l < n2; l++)
	{
		v[l + n2] = 0.5 + 0.5 * cos(PI * (double)l / (double)n2);
		*power += (v[l + n2] * v[l + n2]);
	}
	*power /= (double)n;
}

int maindetect::window_data(double *v, long n,double *w_power)
{
	double *w;
	long l;

	w = (double *)malloc(sizeof(double)* n);
	memset(w, 0, sizeof(double)* n);

	*w_power = 1.0;
	window_hanning(w, n, w_power);

	for (l = 0; l < n; l++)
		v[l] *= w[l];
	free(w);

	return 0;
}

int maindetect::calc_fft(double *data, long n, complex *out)
{
	int ret;
	long l;
	double *data_real, *data_complex;

	ret = 0;

	data_real = (double *)calloc(n, sizeof(double));
	data_complex = (double *)calloc(n, sizeof(double));

	for (l = 0; l < n; l++)
		data_real[l] = data[l];

	ret = fft_sing(data_real, data_complex, n, n, n, 1);

	for (l = 0; l < (n / 2 + 1); l++)
	{
		out[l].r = data_real[l];
		out[l].i = data_complex[l];
	}

	free(data_real);
	free(data_complex);

	return ret;
}

DOUB_ARR maindetect::calc_periodogram(double *values, long n,
	double samplefreq,long *n_spec)
{
	long n_fft, l;
	double w_power = 1.0;
	complex *out = NULL;
	double *v_use = NULL;

	double *v = NULL;
	v = (double *)calloc(n, sizeof(double));
	for (l = 0; l < n; l++)
	{
		v[l] = (double)(values[l]);
	}

	DOUB_ARR speclist;

	remove_mean(v, n);

	window_data(v, n,&w_power);

	if (*n_spec > n)
		n_fft = *n_spec;
	else
		n_fft = n;
	v_use = (double *)calloc(n_fft, sizeof(double));
	memcpy(v_use, v, sizeof(double)* n);

	out = (complex *)malloc(sizeof(complex)* n_fft);
	memset(out, 0, sizeof(complex)* n_fft);

	calc_fft(v_use, n_fft, out);

	if (((n_fft / 2) % 2) == 1)
		*n_spec = (n_fft + 1) / 2;
	else
		*n_spec = (n_fft / 2);

	speclist.arr = (double *)malloc((*n_spec) * sizeof(double));
	speclist.count = *n_spec;

	for (l = 0; l < (*n_spec); l++)
	{
		speclist.arr[l] = (pow(out[l].r, 2.0) + pow(out[l].i, 2.0)) / (w_power
			* (double)n);
		if ((l != 0) && (l != (*n_spec - 1)))
			speclist.arr[l] *= 2.0;
		speclist.arr[l] /= samplefreq;
	}

	if (out)
		free(out);
	if (v_use)
		free(v_use);

	if (v)
	{
		free(v);
		v = NULL;
	}

	return speclist;
}
void maindetect::getQRSlist(LONG_ARR *Rlist, LONG_ARR *QRS_startlist,
	LONG_ARR *QRS_endlist, struct ecg_info *ci, struct data_buffer *buf)
{
	long posR = 0;
	int num_read = 0;
	long ch_pos = 0;
	long curr_pos, curr_pos_use, end_pos, l, blanktime, get_next_th;
	int state_prev, state, last_peak;
	long last_peak_idx;
	long pos_offset = 0;

	long QRS_START = 0;
	long QRS_END = 0;

	long beat_range = 0;
	double th_s1 = 0;
	double th_s1_old = 0;
	double th_s2_old = 0;
	double th_s2 = 0;
	double th_s1_m = 0;
	double th_s2_m = 0;

	double th_mean = 0;
	int noise = 0;

	int ret = 0;

	beat_range = (long)(0.2 * ci->samplerate);
	curr_pos = -1;
	blanktime = 0;
	state = state_prev = last_peak = 0;
	last_peak_idx = 0;
	get_next_th = 0;

	curr_pos = pos_offset * ci->interp_factor;
	end_pos = ci->num_samples * ci->interp_factor;//

	if (curr_pos < 0)
		curr_pos = 0;

	ch_pos = curr_pos;
	Rlist->count = 0;
	QRS_startlist->count = 0;
	QRS_endlist->count = 0;

	Rlist->arr = (long *)malloc(((long)(ci->num_samples / ci->samplerate * 6)) * sizeof(long));//*5300/
	QRS_startlist->arr = (long *)malloc(((long)(ci->num_samples / ci->samplerate * 6)) * sizeof(long));
	QRS_endlist->arr = (long *)malloc(((long)(ci->num_samples / ci->samplerate * 6)) * sizeof(long));

	while (curr_pos < end_pos - 4)
	{
		if (blanktime > 0)
			blanktime--;

		curr_pos++;

		if (curr_pos > ch_pos)
		{
			long num_to_read;
			long read_start = curr_pos;

			read_start -= (long)(ci->samplerate);
			if (read_start < 0)
				read_start = 0;

			num_to_read = BUFFER_SIZE;
			if ((end_pos - read_start) < num_to_read)
			{
				num_to_read = end_pos - read_start;

			}
			if (num_to_read < ci->samplerate)
				break;

			int M_WIDTH = 5;
			double H_HIGHT = 100;
			num_read = get_data_new(read_start, buf, num_to_read,
				ci->interp_factor, ci->gain, M_WIDTH, H_HIGHT);

			if (num_read <= ci->samplerate)
				break;
			buf->data_offset = read_start;
			ch_pos = read_start + num_read - (long)(ci->samplerate);

			if (num_to_read < BUFFER_SIZE)
			{
				ch_pos = read_start + num_read;
			}

			get_next_th = 0;
		}

		get_next_th--;
		if (get_next_th <= 0)
		{
			long start, num;

			start = curr_pos - buf->data_offset;
			if (start < 0)
				start = 0;
			num = ci->s5;
			if ((start + num) > buf->num_data)
				num = buf->num_data - start;

			th_s1 = 0.0;//+
			th_s2 = 0.0;//-
			th_s1_m = 0.0;
			th_s2_m = 0.0;
			for (l = start; l < (start + num); l++)
			{
				if (buf->s1[l] > th_s1_m)
					th_s1_m = buf->s1[l];
				if (buf->s1[l] < th_s1_m && buf->s1[l] > th_s1)
					th_s1 = buf->s1[l];
				if (buf->s1[l] < th_s2_m)
					th_s2_m = buf->s1[l];
				if (buf->s1[l] > th_s2_m && buf->s1[l] < th_s2)
					th_s2 = buf->s1[l];
			}
			for (l = start; l < (start + num); l++)
			{
				if (buf->s1[l] > th_s2 / 3 && buf->s1[l] < th_s1 / 3)
					th_mean += fabs(buf->s1[l]);
			}
			th_mean = th_mean / num;

			noise = 0;
			if ((th_mean > 0.5 * buf->s1mean && th_mean > 7) || (th_s1 < 100))
			{
				if (th_mean > 0.5 * buf->s1mean && th_mean > 7)
					noise = 1;

				th_s1 = 0.32 * th_s1; 
				th_s2 = 0.32 * th_s2;
			}
			else
			{
				th_s1 = 0.2 * th_s1;
				th_s2 = 0.2 * th_s2;

				noise = 0;
			}

			if (th_s1 > 500 || th_s2<-500 || th_s1<10 || th_s2>-3)
			{
				th_s1 = 10000;
				th_s2 = -10000;
			}


			if (th_s1_old != 0)
			{
				if (((th_s1 > 2.5 * th_s1_old && th_s1_old > 10) || th_s1
					< (th_s1_old / 4 && th_s1_old < 500)) && ((fabs(th_s2) > 2.5 * fabs(th_s2_old) && th_s2_old < -10)
					|| ((fabs(th_s2) < fabs(th_s2_old / 10)) && th_s2_old > -400)))
				{

				}
			}
			th_s1_old = th_s1;

			if (th_s2_old != 0)
			{
				if ((fabs(th_s2) > 2.5 * fabs(th_s2_old) && th_s2_old < -10)
					|| ((fabs(th_s2) < fabs(th_s2_old / 10)) && th_s2_old
					> -400))
				{
				}
			}
			th_s2_old = th_s2;
			get_next_th = ci->s5;
		}

		state_prev = state;
		if (buf->s1[curr_pos - buf->data_offset] > th_s1 && buf->s1[curr_pos
			- buf->data_offset + 1] > th_s1)
			state = 1;
		else if (buf->s1[curr_pos - buf->data_offset] < th_s2
			&& buf->s1[curr_pos - buf->data_offset + 1] < th_s2)
			state = -1;
		else
			state = 0;

		if ((state == 0) && (state_prev != 0))
		{
			last_peak_idx = curr_pos - 1;
			last_peak = state_prev;
		}

		if ((state_prev == state) || (state == 0))
			continue;

		if (last_peak == state || last_peak == 0)
			continue;

		if ((curr_pos - last_peak_idx) > ci->ms30 * 3.5)
		{
			last_peak = state;
			last_peak_idx = curr_pos;
			continue;
		}

		if (blanktime > 0)
			continue;

		curr_pos_use = curr_pos;
		ret = 0;

		if (Rlist->count == 0)
		{
			Rlist->arr[Rlist->count] = curr_pos_use;

			ret = get_qrs_complex(buf, &curr_pos_use, ci->ms100, ci->ms50,
				ci->ms30, &QRS_START, &QRS_END, noise);
			Rlist->arr[Rlist->count] = curr_pos_use;
			QRS_startlist->arr[Rlist->count] = QRS_START;
			QRS_endlist->arr[Rlist->count] = QRS_END;

			Rlist->count++;
		}
		else
		{
			posR = Rlist->arr[Rlist->count - 1];
			if ((posR + beat_range) < curr_pos_use)
			{

				Rlist->arr[Rlist->count] = curr_pos_use;
				ret = get_qrs_complex(buf, &curr_pos_use, ci->ms100, ci->ms50,
					ci->ms30, &QRS_START, &QRS_END, noise);
				Rlist->arr[Rlist->count] = curr_pos_use;
				QRS_startlist->arr[Rlist->count] = QRS_START;
				QRS_endlist->arr[Rlist->count] = QRS_END;
				Rlist->count++;
			}
			else if ((posR - beat_range) > curr_pos_use)
			{
				Rlist->count--;
			}
			else if ((posR + beat_range) > curr_pos_use)
			{
				ret = get_qrs_complex(buf, &curr_pos_use, ci->ms100, ci->ms50,
					ci->ms30, &QRS_START, &QRS_END, noise);
				if (fabs(buf->orig00[curr_pos_use - buf->data_offset]) > 3
					* fabs(buf->orig00[posR - buf->data_offset]))
				{
					Rlist->count--;
					Rlist->arr[Rlist->count] = curr_pos_use;
					QRS_startlist->arr[Rlist->count] = QRS_START;
					QRS_endlist->arr[Rlist->count] = QRS_END;
					Rlist->count++;
				}
			}
		}
		blanktime = (int)(2.3 * ci->ms100);
	}

	if ((end_pos - Rlist->arr[Rlist->count - 1]) < (long)(ci->samplerate_orig / 2))
		Rlist->count--;
	QRS_startlist->count = Rlist->count;
	QRS_endlist->count = Rlist->count;
	free(buf->orig);
	free(buf->f0);
	free(buf->f1);
	free(buf->s1);

	buf->orig = NULL;
	buf->f0 = NULL;
	buf->f1 = NULL;
	buf->s1 = NULL;
}

struct ecg_result maindetect::getecgresult(double *orig00, long ecgnum,
	double Fs, double GainK)
{
	ofstream ofs;

	struct ecg_info ci;
	struct data_buffer buf;

	result.AbECGNum = 0;
	result.AnalysisOk = 0;
	result.Arrest_Num = 0;
	result.Bigeminy_Num = 0;
	result.Bradycardia = 0;
	result.Fastest_Beat = 0;
	result.Fastest_Time = 0;
	result.HF = 0;
	result.HFLevel = 0;
	result.HRVI = 0;
	result.HRVILevel = 0;
	result.HeartNum = 0;
	result.HeartRate = 0;
	result.HRLevel = 0;
	result.ImageNum = 0;
	result.Insert_PVBnum = 0;
	result.iCount = 0;
	result.LF = 0;
	result.LFLevel = 0;
	result.LF_HF_Ratio = 0;
	result.LHRLevel = 0;
	result.Missed_Num = 0;
	result.Wide_Num = 0;
	result.PAB = 0;
	result.PNN50 = 0;
	result.PNN50Level = 0;
	result.PSDfile = "";
	result.PSDfileID = "";
	result.PVB = 0;
	result.Polycardia = 0;
	result.RMSSD = 0;
	result.RMSSDLevel = 0;
	result.RRfile = "";
	result.RRfileID = "";
	result.SD1 = 0;
	result.SD2 = 0;
	result.SDNN = 0;
	result.SDNNLevel = 0;
	result.TimeLength = 0;
	result.Slowest_Beat = 0;
	result.Slowest_Time = 0;
	result.TP = 0;
	result.TPLevel = 0;
	result.Trigeminy_Num = 0;
	result.VLF = 0;
	result.VLFLevel = 0;
	result.VT = 0;
	result.ECGResult = 0;
	result.flagAR = 0;
	result.Wrong_Num = 0;

	wideflag = 0;

	result.AbECG = NULL;
	result.Arrest_posL = NULL;
	result.Missed_posL = NULL;
	result.PVBposL = NULL;
	result.PABposL = NULL;
	result.Insert_PVBposL = NULL;
	result.VT_posL = NULL;
	result.Bigeminy_posL = NULL;
	result.Trigeminy_posL = NULL;
	result.Wide_posL = NULL;

	buf.num_data = 0;
	buf.data_offset = 0;
	buf.orig = NULL;
	buf.orig00 = NULL;
	buf.f0 = NULL;
	buf.f1 = NULL;
	buf.s1 = NULL;
	buf.ecgmean = 0;
	buf.s1mean = 0;
	buf.temp_mean = 0;
	buf.temp_maxdiff = 0;
	buf.temp_Rvalue = 0;
	buf.temp_Tvalue = 0;
	buf.temp_Svalue = 0;
	buf.temp_RT = 0;
	buf.temp_RS = 0;
	memset(&ci, 0, sizeof(struct ecg_info));

	int do_interpolation = 0;
	int ret = 0;
	int flagabnormal = 1;
	long l = 0;

	LONG_ARR Rlist;
	LONG_ARR PSD_RRlist;
	LONG_ARR Rannolist;
	LONG_ARR QRS_startlist;
	LONG_ARR QRS_endlist;
	LONG_ARR QRSlist;
	LONG_ARR RRlist;
	LONG_ARR new_RRlist;
	LONG_ARR noiselist;

	DOUB_ARR ECGlist1;

	double SD1;
	double SD2;


	ci.samplerate_orig = Fs;
	ci.samplerate = ci.samplerate_orig;
	ci.interp_factor = 1;
	ci.gain = GainK;
	ci.hearthigh = 100;
	ci.heartlow = 55;
	ci.heartneed = 10;
	ci.papercent = 0.16;
	ci.pvpercent = 0.13;
	ci.arrest_time = 2000;
	ci.VT_value = 120;

	double RRmean = 0;
	double allRRmean = 0;
	long allR = 0;

	if (ci.samplerate_orig <= 0)
		int storelength = (int)(ci.samplerate_orig * 6);

	ret = prepare_data_access(do_interpolation, &ci, &buf);
	if (ret != 0)
	{
		return result;
	}

	ci.num_samples = ecgnum;
	result.TimeLength = (long)(ci.num_samples / ci.samplerate_orig);


	ECGlist1 = ECG_NO_NOISE2(orig00, ci.num_samples);

	noiselist = ECG_NO_NOISE(ECGlist1.arr, ci.num_samples, ci.samplerate_orig);
	buf.orig00 = ECGlist1.arr;

	getQRSlist(&Rlist, &QRS_startlist, &QRS_endlist, &ci, &buf);
	if (Rlist.count <= 10)
	{
		free(Rlist.arr);
		free(QRS_startlist.arr);
		free(QRS_endlist.arr);
		free(noiselist.arr);
		result.AnalysisOk = 1;
	}
	else
	{
		Rannolist.arr = (long *)malloc((Rlist.count) * sizeof(long));
		Rannolist.count = Rlist.count;
		memset(Rannolist.arr, 0, Rlist.count);
		int ll;

		for (ll = 0; ll < Rannolist.count; ll++)
		{
			Rannolist.arr[ll] = 0;
		}

		RRlist = getRRlist(&Rlist, ci.samplerate_orig);

		allRRmean = 0;
		allR = Rlist.count;
		allRRmean = getallRRmean(&Rlist, &RRlist, &noiselist, ci.samplerate_orig);

		RRmean = getRRmean(&RRlist);
		if (allRRmean<1450 && allRRmean>500)
		{
			flagabnormal = GET_TEMPLATE_NEW(&Rlist, &RRlist, &buf, ci.samplerate_orig,
				ci.num_samples, RRmean);

			DROP_WRONG_RLIST(&Rlist, &QRS_startlist, &QRS_endlist, &RRlist, &buf, ci.samplerate_orig, RRmean);
			free(RRlist.arr);
			RRlist.arr = NULL;
			RRlist = getRRlist(&Rlist, ci.samplerate_orig);

			DROP_WRONG_RLIST1(&Rlist, &QRS_startlist, &QRS_endlist, &RRlist, &buf, RRmean);
			free(RRlist.arr);
			RRlist.arr = NULL;
			RRlist = getRRlist(&Rlist, ci.samplerate_orig);

			DROP_WRONG_RLIST1(&Rlist, &QRS_startlist, &QRS_endlist, &RRlist, &buf, RRmean);
			Rlist.count = Rlist.count - 1;
			free(RRlist.arr);
			RRlist.arr = NULL;
			RRlist = getRRlist(&Rlist, ci.samplerate_orig);

			GET_RRLIST_NOISELIST(&Rlist, &RRlist, &noiselist, RRmean, ci.samplerate_orig, &buf);
		}

		QRSlist = getQRSWIDTHlist(&QRS_startlist, &QRS_endlist,
			ci.samplerate_orig);

		ret = getothers(&RRlist, &QRSlist, &Rannolist, &result, ci.pvpercent,
			ci.papercent, ci.arrest_time, ci.VT_value, &Rlist, &buf);

		if (allRRmean<1450 && allRRmean>500)
		{
			ret = GET_NEWRannolist_NEW(&Rlist, &RRlist, &Rannolist, &buf,
				ci.samplerate_orig, ci.num_samples, RRmean, &QRSlist);
		}

		new_RRlist = get_NEW_RRlist(&RRlist, &Rannolist, ci.samplerate_orig);

		if (result.Missed_Num > 0 || result.Arrest_Num > 0)
		{
			if (allRRmean<1450 && allRRmean>500)
			{
				ret = GET_NEWRannolist_AFTER(&Rlist, &new_RRlist, &Rannolist, &buf,
					ci.samplerate_orig);
			}
		}

		ret = gethighlowheart(&new_RRlist, &Rlist, ci.heartneed,
			ci.samplerate_orig, &result);

		PSD_RRlist = get_PSD_RRlist(&new_RRlist, &Rannolist, ci.samplerate_orig);

		RRmean = getRRmean(&PSD_RRlist);

		result.flagAR = getAR_high(&new_RRlist, &Rannolist, RRmean);

		if (result.Fastest_Beat > ci.hearthigh)
			result.Polycardia = 1;
		if (result.Slowest_Beat < ci.heartlow)
			result.Bradycardia = 1;

		result.Fastest_Time = (int)(Rlist.arr[result.Fastest_Time]
			/ ci.samplerate_orig);

		result.Slowest_Time = (int)(Rlist.arr[result.Slowest_Time]
			/ ci.samplerate_orig);
		int i = 0;
		int highRR = 0;
		if (RRmean > 700) {
			for (i = 0; i < new_RRlist.count - 2; i++) {
				if (new_RRlist.arr[i] < 350)
					highRR++;
			}
		}

		int abtype_num = (result.Polycardia != 0) + (result.Bradycardia != 0)
			+ (result.Bigeminy_Num != 0) + (result.Trigeminy_Num != 0)
			+ (result.Arrest_Num != 0) + (result.Missed_Num != 0)
			+ (result.PVB != 0) + (result.PAB != 0) + (result.VT != 0) + (result.Insert_PVBnum != 0)
			+ (result.Wide_Num != 0) + (result.flagAR != 0);
		if ((result.Wrong_Num > 0.2 * Rlist.count && abtype_num > 0) || allRRmean == 0)
		{
			result.AnalysisOk = 1;

			result.Rlist = Rlist;
			result.RRlist = new_RRlist;
			result.Rannolist = Rannolist;
			result.Qlist = QRS_startlist;
			result.Slist = QRS_endlist;
			result.QRSlist = QRSlist;

			return result;
		}
		else if (((allR - Rlist.count) > 0.3*Rlist.count) || abtype_num >= 5 || (result.VT != 0 && abtype_num >= 3) || (allRRmean >= 1450 && abtype_num >= 2) || (allRRmean <= 500 && abtype_num >= 2) || (flagabnormal == 0 && result.flagAR != 1 && abtype_num >= 3) || ((highRR >= 2) && (abtype_num >= 2) && (result.Fastest_Beat < 110)))
		{
			result.AnalysisOk = 2;
		}

		if (result.Polycardia + result.Bradycardia + result.Arrest_Num
			+ result.Missed_Num + result.PVB + result.PAB
			+ result.Insert_PVBnum + result.VT + result.Bigeminy_Num
			+ result.Trigeminy_Num + result.Wide_Num + result.flagAR > 0)
		{
			result.ECGResult = 1;

			int abtype = 0;

			if (result.Arrest_Num > 0)
			{
				abtype = 1;
				result.Arrest_posL = getposL(&Rannolist, result.Arrest_Num,
					abtype, &Rlist, ci.samplerate_orig);
			}
			if (result.Missed_Num > 0)
			{
				abtype = 2;
				result.Missed_posL = getposL(&Rannolist, result.Missed_Num,
					abtype, &Rlist, ci.samplerate_orig);
			}
			if (result.Wide_Num > 0)
			{
				abtype = 11;
				result.Wide_posL = getposL(&Rannolist, result.Wide_Num, abtype,
					&Rlist, ci.samplerate_orig);
			}

			if (result.PVB > 0)
			{
				abtype = 3;
				result.PVBposL = getposL(&Rannolist, result.PVB, abtype,
					&Rlist, ci.samplerate_orig);
			}
			if (result.PAB > 0)
			{
				abtype = 4;
				result.PABposL = getposL(&Rannolist, result.PAB, abtype,
					&Rlist, ci.samplerate_orig);
			}
			if (result.Insert_PVBnum > 0)
			{
				abtype = 5;
				result.Insert_PVBposL = getposL(&Rannolist,result.Insert_PVBnum, abtype, &Rlist,
					ci.samplerate_orig);
			}
			if (result.VT > 0)
			{
				abtype = 6;
				result.VT_posL = getposL(&Rannolist, result.VT, abtype, &Rlist,
					ci.samplerate_orig);
			}
			if (result.Bigeminy_Num > 0)
			{
				abtype = 7;
				result.Bigeminy_posL = getposL(&Rannolist, result.Bigeminy_Num,
					abtype, &Rlist, ci.samplerate_orig);
			}

			if (result.Trigeminy_Num > 0)
			{
				abtype = 8;
				result.Trigeminy_posL = getposL(&Rannolist,
					result.Trigeminy_Num, abtype, &Rlist,
					ci.samplerate_orig);
			}
		}
		else
		{
			result.ECGResult = 0;
		}

		result.HeartNum = Rlist.count;
		if (RRmean > 0)
		{
			result.HeartRate = (long)(60000 / RRmean);
		}
		else
		{
			result.HeartRate = (long)((Rlist.count - 1)
				/ ((double)(Rlist.arr[Rlist.count - 1] - Rlist.arr[0])
				/ ci.samplerate) * 60);

		}
		if (result.HeartRate > ci.hearthigh)
		{
			result.HRLevel = 1;
		}
		else if (result.HeartRate < ci.heartlow)
		{
			result.HRLevel = -1;
		}
		else
		{
			result.HRLevel = 0;
		}

		result.SDNN = calc_sdnn(&PSD_RRlist);
		result.SDNN = get2double(result.SDNN);

		if (result.SDNN > SDNNStd_H)
		{
			result.SDNNLevel = 1;
		}
		else if (result.SDNN < SDNNStd_L)
		{
			result.SDNNLevel = -1;
		}
		else
		{
			result.SDNNLevel = 0;
		}

		result.HRVI = calc_hrvi(&PSD_RRlist);
		result.HRVI = get2double(result.HRVI);

		if (result.HRVI > HRVIStd_H)
		{
			result.HRVILevel = 1;
		}
		else if (result.HRVI < HRVIStd_L)
		{
			result.HRVILevel = -1;
		}
		else
		{
			result.HRVILevel = 0;
		}

		result.PNN50 = calc_pnn50(&PSD_RRlist);
		result.PNN50 = get2double(result.PNN50);

		if (result.PNN50 > PNN50Std_H)
		{
			result.PNN50Level = 1;
		}
		else if (result.PNN50 < PNN50Std_L)
		{
			result.PNN50Level = -1;
		}
		else
		{
			result.PNN50Level = 0;
		}

		result.RMSSD = calc_rmssd(&PSD_RRlist);
		result.RMSSD = get2double(result.RMSSD);

		if (result.RMSSD > RMSSDStd_H)
		{
			result.RMSSDLevel = 1;
		}
		else if (result.RMSSD < RMSSDStd_L)
		{
			result.RMSSDLevel = -1;
		}
		else
		{
			result.RMSSDLevel = 0;
		}

		ret = calc_poincare(&PSD_RRlist, &SD1, &SD2);
		result.SD1 = get2double(SD1);
		result.SD2 = get2double(SD2);

		result.iCount = (long)(ecgnum / ci.samplerate_orig / 40) + 1;
		result.ImageNum = 3 + result.iCount + result.AbECGNum;

		long n_spec = 0;
		DOUB_ARR speclist;
		DOUB_ARR axislist;

		double usesample = 1000.0 / EQUIDIST_MS;
		double *values;
		long real_num = 0;
		ret = process_values(&PSD_RRlist, &Rlist, &values, ci.samplerate_orig,
			usesample, &real_num);

		speclist = calc_periodogram(values, real_num, usesample, &n_spec);
		axislist.arr = (double *)malloc((n_spec)* sizeof(double));
		axislist.count = n_spec;

		long storelengthpsd = 0;
		int flagfirst = 0;
		double curr_freq;
		double freq_step;
		curr_freq = 0;
		freq_step = usesample / (double)(n_spec * 2);
		for (l = 0; l < n_spec; l++)
		{
			axislist.arr[l] = curr_freq;
			curr_freq += freq_step;
			if ((curr_freq > 1.0) && (flagfirst == 0))
			{
				storelengthpsd = l;
				flagfirst = 1;
			}
		}

		result.TP = calc_power(TOTAL_POWER_START, TOTAL_POWER_END, EQUIDIST_MS,
			&speclist, n_spec);
		result.TP = get2double(result.TP);
		if (result.TP > TPStd_H)
		{
			result.TPLevel = 1;
		}
		else if (result.TP < TPStd_L)
		{
			result.TPLevel = -1;
		}
		else
		{
			result.TPLevel = 0;
		}

		result.LF = calc_power(LF_START, LF_END, EQUIDIST_MS, &speclist, n_spec);
		result.LF = get2double(result.LF);
		if (result.LF > LFStd_H)
		{
			result.LFLevel = 1;
		}
		else if (result.LF < LFStd_L)
		{
			result.LFLevel = -1;
		}
		else
		{
			result.LFLevel = 0;
		}

		result.HF = calc_power(HF_START, HF_END, EQUIDIST_MS, &speclist, n_spec);
		result.HF = get2double(result.HF);
		if (result.HF > HFStd_H)
		{
			result.HFLevel = 1;
		}
		else if (result.HF < HFStd_L)
		{
			result.HFLevel = -1;
		}
		else
		{
			result.HFLevel = 0;
		}

		result.VLF = calc_power(VLF_START, VLF_END, EQUIDIST_MS, &speclist,
			n_spec);
		result.VLF = get2double(result.VLF);
		if (result.VLF > VLFStd_H)
		{
			result.VLFLevel = 1;
		}
		else if (result.VLF < VLFStd_L)
		{
			result.VLFLevel = -1;
		}
		else
		{
			result.VLFLevel = 0;
		}

		result.LF_HF_Ratio = result.LF / result.HF;
		result.LF_HF_Ratio = get2double(result.LF_HF_Ratio);
		if (result.LF_HF_Ratio > LF_HF_RatioStd_H)
		{
			result.LHRLevel = 1;
		}
		else if (result.LF_HF_Ratio < LF_HF_RatioStd_L)
		{
			result.LHRLevel = -1;
		}
		else
		{
			result.LHRLevel = 0;
		}

		result.RRfile = filePath + "RR.txt";
		result.PSDfile = filePath + "R.txt";

		result.Rlist = Rlist;
		result.RRlist = new_RRlist;
		result.Rannolist = Rannolist;
		result.Qlist = QRS_startlist;
		result.Slist = QRS_endlist;
		result.QRSlist = QRSlist;
		result.speclist = speclist;
		result.axislist = axislist;
	}
	return result;
}

void maindetect::releaseecgresult()
{
	if (result.AbECG != 0)
	{
		delete[] result.AbECG;
		result.AbECG = NULL;
	}
	if (result.Arrest_posL)
	{
		delete[] result.Arrest_posL;
		result.Arrest_posL = NULL;
	}
	if (result.Missed_posL)
	{
		delete[] result.Missed_posL;
		result.Missed_posL = NULL;
	}
	if (result.PVBposL)
	{
		delete[] result.PVBposL;
		result.PVBposL = NULL;
	}
	if (result.PABposL)
	{
		delete[] result.PABposL;
		result.PABposL = NULL;
	}
	if (result.Insert_PVBposL)
	{
		delete[] result.Insert_PVBposL;
		result.Insert_PVBposL = NULL;
	}
	if (result.VT_posL)
	{
		delete[] result.VT_posL;
		result.VT_posL = NULL;
	}
	if (result.Bigeminy_posL)
	{
		delete[] result.Bigeminy_posL;
		result.Bigeminy_posL = NULL;
	}
	if (result.Trigeminy_posL)
	{
		delete[] result.Trigeminy_posL;
		result.Trigeminy_posL = NULL;
	}
	if (result.Wide_posL)
	{
		delete[] result.Wide_posL;
		result.Wide_posL = NULL;
	}
}
