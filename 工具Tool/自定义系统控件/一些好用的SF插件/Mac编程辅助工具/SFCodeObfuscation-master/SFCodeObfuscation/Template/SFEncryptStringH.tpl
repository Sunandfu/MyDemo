//
//  SFEncryptString.h
//  SFCodeObfuscation
//
//  Created by SF on 2018/8/18.
//  Copyright © 2018年 Lurich All rights reserved.
//

#ifndef SFEncryptString_h
#define SFEncryptString_h

typedef struct {
    char factor;
    char *value;
    int length;
    char decoded;
} SFEncryptStringData;

const char *sf_CString(const SFEncryptStringData *data);

#ifdef __OBJC__
#import <Foundation/Foundation.h>
NSString *sf_OCString(const SFEncryptStringData *data);
#endif

#endif
