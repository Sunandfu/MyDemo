#ifndef _PREDEALFUNC_H
#define _PREDEALFUNC_H

#include "ParameterDefine.h"

#include <cstdio>
#include <cstring>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string>
#include <math.h>
#include "time.h"
#include <vector>
#include <fstream>

using namespace std;

class maindetect {
public:
	virtual ~maindetect();
	int  GETHRVTI(long *pr, int **RRhis, int count);
	struct ecg_result getecgresult(double *orig00, long ecgnum, double Fs,
		double GainK);
	DOUB_ARR readdate();
	DOUB_ARR readdatetest();
	DOUB_ARR readfromstring();
	DOUB_ARR ECG_NO_NOISE2(double *ecglistarr, long ecglistnum);
	void releaseecgresult();

private:
	int wideflag;
	string filePath;
	ecg_result result;
	string getrelative(int type);
	int GET_NEWRanno(int Ranno);
	int GET_TEMPLATE(LONG_ARR *Rlist, LONG_ARR *Rannolist, struct data_buffer *buf);
	LONG_ARR ECG_NO_NOISE(double *ecglistarr, long ecglistnum, double fs);
	int DROP_WRONG_RLIST(LONG_ARR *Rlist, LONG_ARR *QRS_startlist, LONG_ARR *QRS_endlist, LONG_ARR *RRlist, struct data_buffer *buf, double fs, long RRmean);
	int GET_RRLIST_NOISELIST(LONG_ARR *Rlist, LONG_ARR *RRlist, LONG_ARR *noiselist, long RRmean, double fs, struct data_buffer *buf);
	int GET_NEWRannolist(LONG_ARR *Rlist, LONG_ARR *Rannolist, struct data_buffer *buf, double fs, long datanum);
	int DROP_WRONG_RLIST1(LONG_ARR *Rlist, LONG_ARR *QRS_startlist, LONG_ARR *QRS_endlist, LONG_ARR *RRlist, struct data_buffer *buf, long RRmean);
	int GET_NEWRannolist_NEW(LONG_ARR *Rlist, LONG_ARR *RRlist, LONG_ARR *Rannolist,
	struct data_buffer *buf, double fs, long ecgnum, long RRmean, LONG_ARR *QRSlist);
	int GET_TEMPLATE_NEW(LONG_ARR *Rlist, LONG_ARR *RRlist, struct data_buffer *buf, double fs, long ecgnum, long RRmean);
	int GET_NEWRannolist_AFTER(LONG_ARR *Rlist, LONG_ARR *RRlist, LONG_ARR *Rannolist, struct data_buffer *buf, double fs);
	double get_var(vector<double> ecgvector);

	LONG_ARR get_NEW_RRlist(LONG_ARR *Rlist, LONG_ARR *Rannolist, double fs);

	LONG_ARR get_PSD_RRlist(LONG_ARR *RRlist, LONG_ARR *Rannolist, double fs);

	int findnextpos(LONG_ARR *Rannolist, long pos);
	int getAbecgseg(LONG_ARR Rannolist, double *orig00, long ecgnum,
		LONG_ARR *Rlist, int length, double sample);

	int* getposL(LONG_ARR *Rannolist, int abNum, int abtype, LONG_ARR *Rlist, double fs);

	int storeAbecgfile(int pos, double *orig00, long ecgnum, LONG_ARR *Rlist,
	struct AbECG *AbECG, int length, int Abnum);
	double get2double(double a);
	double getmean(LONG_ARR *list);
	double getRRmean(LONG_ARR *RRlist);
	double getallRRmean(LONG_ARR *Rlist, LONG_ARR *RRlist, LONG_ARR *noiselist, double fs);
	LONG_ARR getQRSWIDTHlist(LONG_ARR *QRS_startlist, LONG_ARR *QRS_endlist,
		double fs);

	int gethighlowheart(LONG_ARR *RRlist, LONG_ARR *Rlist, long heartneed,
		double fs, ecg_result *result);

	int getothers(LONG_ARR *RRlist, LONG_ARR *QRSlist, LONG_ARR *Rannolist,ecg_result *result, double pvpercent,
		double papercent, long arrest_time, long VT_value, LONG_ARR *Rlist, struct data_buffer *buf);

	int fabsint(int a);

	int pre_process_data(double **values, long num);
	int process_values(LONG_ARR *RRlist, LONG_ARR *Rlist, double **value,
		double samplerate_orig, double samplerate, long *real_num); 

	LONG_ARR getRRlist(LONG_ARR *Rlist, double fs);
	int getAR_high(LONG_ARR *RRlist, LONG_ARR *Rannolist, double RRmean);


	int find_peaks(struct data_buffer *buf, double *sig_use, long start,
		long num, double threshold, double area_filt,
	struct peak_buffer **peaks, long *num_peaks, long *morph_type,
		long ms30, int allow_look_before, int allow_look_after);
	int get_peaks(struct data_buffer *buf, double *sig_use, long start,
		long num, double threshold, double area_filt,
	struct peak_buffer **peaks, long *num_peaks, long *morph_type,
		long ms30, int allow_look_before, int allow_look_after);

	int get_qrs_complex(struct data_buffer *buf, long *curr_pos,
		long ms100, long ms50, long ms30,long *QRS_START,
		long *QRS_END, int noise);

	int fir_filter_design(long order, double cut_low, double cut_high,
		double **b, long *num);
	int prepare_data_access(long do_interpolation, struct ecg_info *ci,
	struct data_buffer *buf);
	int filter(double *b, double *a, long order, double *data,
		long num_samples, int direction);
	int filtfilt(double *b, double *a, long order, double *data,
		long num_samples);
	int interp(double *in, double *out, long num_samples, long factor);
	long get_data_new(long ch_pos,
	struct data_buffer *buf, long num_to_read, long interp_factor, double gain, int M_WIDTH, double H_HIGHT);
	long look_for_next_beat(double *data, long num_data, long pos,
		double threshold, long blanktime, long ms30);
	double get_min(double *values, long num, long *pos);
	double get_max(double *values, long num, long *pos);
	double mean(double *values, long num);
	int remove_mean(double * v, long n);
	int histogram(double *values, long num, long **hist, long *hist_start,
		long *hist_size, int bin);
	double stddev(double *values, long num);
	double calc_sdnn(LONG_ARR *RRlist);
	double calc_pnn50(LONG_ARR *RRlist);
	double calc_rmssd(LONG_ARR *RRlist);
	double calc_hrvi(LONG_ARR *RRlist);
	int calc_poincare(LONG_ARR *RRlist, double *SD1, double *SD2);
	double calc_power(double start, double end, double sample_dist_ms,
		DOUB_ARR *axislist, long n);
	void window_hanning(double *v, long n, double *power);
	int window_data(double *v, long n,double *w_power);
	int calc_fft(double *data, long n, complex *out);
	DOUB_ARR calc_periodogram(double *values, long n, double samplefreq,/* double **spec,*/
		long *n_spec);

	void
		getQRSlist(LONG_ARR *Rlist, LONG_ARR *QRS_startlist, LONG_ARR *QRS_endlist,
	struct ecg_info *ci, struct data_buffer *buf);
};


#endif
