#ifndef __IDCARD_API_H__
#define __IDCARD_API_H__
#ifdef __cplusplus
extern "C"
#endif
 int   IDCardInit(const char *path);
#ifdef __cplusplus
extern "C"
#endif
 void  IDCardEnd();
//////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C"
#endif
 int   IDCardRecApi(char *szResBuf, const int iBufSize, unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount);

#endif //__IDCARD_API_H__