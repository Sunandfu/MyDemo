
#include "header.h"

unsigned FreqDomainIndex(float *freq, float *psdx, unsigned int psdLen, FreqDomainResult *FreqResult)
{
	unsigned int result = 0;

	float TPtmp = 0;
	float VLFPtmp = 0;
	float LFPtmp = 0;
	float HFPtmp = 0;
	float NLFPtmp = 0;
	float NHFPtmp = 0;
	float LFHFtmp = 0;

	float freqresolution = 0;

	if (*(freq + psdLen - 1) < 0.4)
    {
        errors("no enough frequency points");
        return 0;
    }
	freqresolution = *(freq + 1) - *(freq + 0);

	unsigned TPFindex[2];
	unsigned VLFindex[2];
	unsigned LFindex[2];
	unsigned HFindex[2];

	TPFindex[0] = 0;
	VLFindex[0] = 0;
	unsigned i = 0;

	for (; i < psdLen; i ++ ){
		if (*(freq + i) <= 0.04) {VLFindex[1] = i; LFindex[0] = i + 1;}
		else if (*(freq + i) > 0.04 && *(freq + i) <= 0.15) {LFindex[1] = i; HFindex[0] = i + 1;}
		else if (*(freq + i) > 0.15 && *(freq + i) <= 0.4) {HFindex[1] = i; TPFindex[1] = i;}
	}

	for (i = 0; i < TPFindex[1]; i ++){
		TPtmp += *(psdx + i);
		if (i <= VLFindex[1]) VLFPtmp += *(psdx + i);
		if (i > LFindex[0] && i <= LFindex[1]) LFPtmp += *(psdx + i);
		if (i > HFindex[0] && i <= HFindex[1]) HFPtmp += *(psdx + i);
	}

	NLFPtmp = LFPtmp / (LFPtmp + HFPtmp);
	NHFPtmp = HFPtmp / (LFPtmp + HFPtmp);
	LFHFtmp = LFPtmp / HFPtmp;

	//以下参数和.m代码比较，结果有微小差别
	FreqResult -> TP = TPtmp * freqresolution;
	FreqResult -> VLFP = VLFPtmp * freqresolution;
	FreqResult -> LFP = LFPtmp * freqresolution;
	FreqResult -> HFP = HFPtmp * freqresolution;
	FreqResult -> NLFP = NLFPtmp;
	FreqResult -> NHFP = NHFPtmp;
	FreqResult -> LFHF = LFHFtmp;


	result = 1;
	return result;
}
