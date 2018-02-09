#ifndef _PARMETERDEFINE_H
#define _PARMETERDEFINE_H


#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include "math.h"
#include <string>
#include <sstream>
#include <iostream>
#include <cstdio>
#include <fstream>



#include <vector>
using namespace std;

#define BUFFER_SIZE  100000 //一次读取的数据个数
#define EQUIDIST_MS   300
#define SDNNStd_L 17
#define SDNNStd_H 79
#define PNN50Std_L 8
#define PNN50Std_H 16
#define HRVIStd_L 20
#define HRVIStd_H 52
#define RMSSDStd_L 15
#define RMSSDStd_H 39
#define TPStd_L 3466-1018
#define TPStd_H 3466+1018
#define VLFStd_L 0
#define VLFStd_H 2000
#define LFStd_L 1170-416
#define LFStd_H 1170+416
#define HFStd_L 975-203
#define HFStd_H 975+203
#define LF_HF_RatioStd_L 1.5
#define LF_HF_RatioStd_H 2.0

#ifndef PI
#define PI 3.14159265358979323846
#endif 

#define TOTAL_POWER_START  0.0000
#define TOTAL_POWER_END    0.4000
#define ULF_START          0.0000
#define ULF_END            0.0030
#define VLF_START          0.0030
#define VLF_END            0.0400
#define LF_START           0.0400
#define LF_END             0.1500
#define HF_START           0.1500
#define HF_END             0.4000
#define POWER_LAW_START    0.0001
#define POWER_LAW_END      0.0100

typedef struct _DOUB_ARR {
	double * arr;
	int count;
} DOUB_ARR;

typedef struct _LONG_ARR {
	long * arr;
	int count;
} LONG_ARR;

struct peak_buffer {
	double amp;
	long idx;
	long start;
	long end;
}; 

typedef struct {
	double r, i;
} complex;

struct AbECG {
	string AbECGfile;
	string AbECGfileID;
	string AbECGType;
	string AbECGTime;
};

struct ecg_result {
	long ImageNum;
	long iCount;
	long TimeLength;

	long AbECGNum;
	long HeartRate;
	long HRLevel;
	string RRfile;
	string RRfileID;
	double SDNN;
	long SDNNLevel;

	double PNN50;
	long PNN50Level;
	double HRVI;
	long HRVILevel;
	double RMSSD;
	long RMSSDLevel;
	double TP;
	long TPLevel;
	double VLF;
	long VLFLevel;
	double LF;
	long LFLevel;
	double HF;
	long HFLevel;
	double LF_HF_Ratio;
	long LHRLevel;
	double SD1;
	double SD2;
	string PSDfile;
	string PSDfileID;
	int ECGResult;
	int AnalysisOk;
	long HeartNum;
	int Slowest_Beat;
	int Slowest_Time;
	int Fastest_Beat;
	int Fastest_Time;
	int Polycardia;
	int Bradycardia;

	int Arrest_Num;
	int *Arrest_posL;

	int Missed_Num;
	int *Missed_posL;


	int Wide_Num; 
	int *Wide_posL;

	int flagAR;
	int PVB;
	int *PVBposL;

	int PAB;
	int *PABposL;

	int Insert_PVBnum;
	int *Insert_PVBposL;

	int VT;
	int *VT_posL;

	int Bigeminy_Num;
	int *Bigeminy_posL;

	int Trigeminy_Num;
	int *Trigeminy_posL;

	int Wrong_Num; 

	struct AbECG *AbECG;
	DOUB_ARR ECGlist;
	LONG_ARR Rlist;
	LONG_ARR RRlist;
	LONG_ARR Qlist;
	LONG_ARR Slist;
	LONG_ARR QRSlist;
	LONG_ARR Rannolist;
	DOUB_ARR speclist;
	DOUB_ARR axislist;
};

struct ecg_info {
	double samplerate;
	double samplerate_orig;
	double gain;
	long num_samples;
	long heartneed;
	double pvpercent;
	double papercent;
	long arrest_time;

	long hearthigh;
	long heartlow;
	long VT_value;
	long interp_factor;
	long s5;
	long ms100;
	long ms50;
	long ms30;
	long ms10;
};

struct data_buffer {
	long num_data;
	long data_offset;
	double *orig;
	double *orig00;
	double *f0;
	double *f1;
	double *s1;

	double ecgmean;
	double s1mean;
	double temp_mean;
	double temp_maxdiff;
	double temp_Rvalue;
	double temp_Tvalue;
	double temp_Svalue;
	long   temp_RT;
	long   temp_RS;
	vector<double> plate_data;

};


#endif