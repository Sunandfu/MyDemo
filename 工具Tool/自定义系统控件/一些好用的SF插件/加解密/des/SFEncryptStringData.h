//
//  SFEncryptStringData.h
//  SFCodeObfuscation
//
//  Created by SF Lee on 2018/8/19.
//  Copyright © 2018年 SF Lee. All rights reserved.
//

#ifndef SFEncryptStringData_h
#define SFEncryptStringData_h

#include "SFEncryptString.h"
//使用AES/CBC/PKCS5Padding加密，秘钥"!@#_123_sda_12!_",偏移量：“ABCDEF1234567890”
/* !@#_123_sda_12!_ */
// key跟后台协商一个即可，保持一致
extern const SFEncryptStringData * const _3987986293;

/* ABCDEF1234567890 */
// 这里的偏移量也需要跟后台一致，一般跟key一样就行
extern const SFEncryptStringData * const _496376346;

/* FI()*&< */
// 新版 加密 解密 key参数
extern const SFEncryptStringData * const _1728085117;

/* Y */
// H5交互 加密 解密 key参数
extern const SFEncryptStringData * const _3233089245;

/* !@#_123_sda_12!_qwe_%!2_ */
//token 签名key
extern const SFEncryptStringData * const _2959396212;

/* 支付宝 */
extern const SFEncryptStringData * const _908669004;

/* alipay_param */
extern const SFEncryptStringData * const _3037465331;

/* https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb */
extern const SFEncryptStringData * const _1913611237;

/* html.yunqingugm.com */
extern const SFEncryptStringData * const _2401392850;

/* weixin */
extern const SFEncryptStringData * const _4107172151;

/* redirect_url */
extern const SFEncryptStringData * const _2541436311;


#endif
