
#include "header.h"

unsigned CalStressScore(TimeDomainResult *TimeResult, FreqDomainResult *FreqResult, StressAssess *stressAssess, unsigned int gender)
{
	float sdnn = TimeResult -> SDNN;
	float lfhf = FreqResult -> LFHF;

	/***********模型系数****************/
	double PsyCoeff[6] = {0.00013634, -0.012155, 0.342251, -4.101544, 25.459098, -4.229728};
	double PhiCoeff[6] = {-212851479.906282, 79954556.522764, -11694985.595653, 837199.087116,
							-29738.893476, 453.030602};
	double AntiStressCoeff[7];
	double StressIndexCoeff[3];

	double PsyStresstmp = 0;      
	double PhiStresstmp = 0;	  
	double StressIndextmp = 0;    
	double AntiStresstmp = 0;	  
	double HeartFunAgetmp = 0;	  
	double Fatiguetmp = 0;	     
	double Motiontmp = 0;  

	/***********心理压力****************/
	if (lfhf < 15.6)
		PsyStresstmp = PsyCoeff[0]*pow(lfhf, 5) + PsyCoeff[1]*pow(lfhf, 4) + PsyCoeff[2]*pow(lfhf, 3)
			+PsyCoeff[3]*pow(lfhf, 2) + PsyCoeff[4]*lfhf + PsyCoeff[5]; 
	else 
		PsyStresstmp = 100.0;
	if (PsyStresstmp > 100.0) PsyStresstmp = 100.0;
	if (PsyStresstmp < 5.0) PsyStresstmp = 5.0;

	/***********身体压力****************/
	if (sdnn < 0.125 && sdnn > 0.021)
		PhiStresstmp = PhiCoeff[0]*pow(sdnn, 5) + PhiCoeff[1]*pow(sdnn, 4) + PhiCoeff[2]*pow(sdnn, 3)
			+ PhiCoeff[3]*pow(sdnn, 2) + PhiCoeff[4]*pow(sdnn, 1) + PhiCoeff[5];
	else if (sdnn <= 0.021) PhiStresstmp = 100.0;
	else PhiStresstmp = 0.0;
	if (PhiStresstmp > 100.0) PhiStresstmp = 100.0;
	if (PhiStresstmp < 5.0) PhiStresstmp = 5.0;

	double x1;
	x1 = 1 / PhiStresstmp;
	/***********抗压能力****************/
	if (lfhf >= 1.5){
		AntiStressCoeff[0] = 1564.721182;
		AntiStressCoeff[1] = -9330.319512;
		AntiStressCoeff[2] = 0.132444;
		AntiStressCoeff[3] = -0.618092;

		if (x1 > 0.09091) x1 = 0.09091;

		AntiStresstmp = AntiStressCoeff[0]*x1 + AntiStressCoeff[1]*pow(x1, 2) 
			+ AntiStressCoeff[2]*PsyStresstmp + AntiStressCoeff[3];

		StressIndexCoeff[0] = 0.7042;
		StressIndexCoeff[1] = -0.1417;
		StressIndexCoeff[2] = 29.8287;

	}

	else{
		AntiStressCoeff[0] = 12096.6743;
		AntiStressCoeff[1] = -356291.682641;
		AntiStressCoeff[2] = -5.875523;
		AntiStressCoeff[3] = 0.579685;
		AntiStressCoeff[4] = 3704751.281339;
		AntiStressCoeff[5] = -0.014866;
		AntiStressCoeff[6] = -83.764646;

		AntiStresstmp = AntiStressCoeff[0]*x1 + AntiStressCoeff[1]*pow(x1, 2) + AntiStressCoeff[2]*PsyStresstmp + 
			AntiStressCoeff[3]*pow(PsyStresstmp, 2) + AntiStressCoeff[4]*pow(x1, 3) + AntiStressCoeff[5]*pow(PsyStresstmp, 3) + AntiStressCoeff[6];

		StressIndexCoeff[0] = 0.3181;
		StressIndexCoeff[1] = -0.5797;
		StressIndexCoeff[2] = 58.6970;

	}

	if (AntiStresstmp > 100.0) AntiStresstmp = 100.0;
	if (AntiStresstmp < 5.0) AntiStresstmp = 5.0;

	/***********综合压力指数****************/
	StressIndextmp = StressIndexCoeff[0]*PhiStresstmp + StressIndexCoeff[1]*AntiStresstmp + StressIndexCoeff[2];
	if (StressIndextmp > 100.0) StressIndextmp = 100.0;
	if (StressIndextmp < 5.0) StressIndextmp = 5.0;


	/***********心脏功能年龄****************/   //和.m代码比较，年龄一项有大到10的精度差别，可能是浮点数精度的原因。
	//.m代码 sdnn=0.044844298741277,HeartFunAgetmp=30.999092852135533;
	//VC代码 sdnn=0.044844318,HeartFunAgetmp=39.725497371318312;
	double Agecoef[5];
	x1 = sdnn;
	if (gender == 1){           //男
		Agecoef[0] = 2.049e+05;
		Agecoef[1] = -1.257e+05;
		Agecoef[2] = 2.729e+04;
		Agecoef[3] = -2648;
		Agecoef[4] = 114.1;

		HeartFunAgetmp = Agecoef[0]*pow(x1, 4) + Agecoef[1]*pow(x1, 3) 
			+ Agecoef[2]*pow(x1, 2) + Agecoef[3]*x1 + Agecoef[4];

	}
	else{
		Agecoef[0] = 6.112e+05;
		Agecoef[1] = -3.004e+05;
		Agecoef[2] = 5.217e+04;
		Agecoef[3] = -3909;
		Agecoef[4] = 126;

		HeartFunAgetmp = Agecoef[0]*pow(x1, 4) + Agecoef[1]*pow(x1, 3) 
			+ Agecoef[2]*pow(x1, 2) + Agecoef[3]*x1 + Agecoef[4];

	}

	if (HeartFunAgetmp <= 20) HeartFunAgetmp = 1; //青少年
	else if (HeartFunAgetmp <= 40) HeartFunAgetmp = 2;  //青壮年
	else if (HeartFunAgetmp <= 60) HeartFunAgetmp = 3;  //中年
	else if (HeartFunAgetmp <= 70) HeartFunAgetmp = 4; //年轻老人
	else if (HeartFunAgetmp > 70) HeartFunAgetmp = 5;  //老年

	stressAssess -> ANSBalance = lfhf;
	stressAssess -> PsyStress = (unsigned int) (PsyStresstmp + 0.5);
	stressAssess -> PhiStress = (unsigned int) (PhiStresstmp+ 0.5);
	stressAssess -> StressIndex = (unsigned int) (StressIndextmp+ 0.5);
	stressAssess -> AntiStress = (unsigned int) (AntiStresstmp+ 0.5);
	stressAssess -> HeartFunAge = (unsigned int) HeartFunAgetmp;
	stressAssess -> Fatigue = Fatiguetmp;
	stressAssess -> Motion = Motiontmp;



	return 1;

	}