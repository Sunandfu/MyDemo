//
//  SFEncryptString.m
//  SFCodeObfuscation
//
//  Created by SF on 2018/8/18.
//  Copyright © 2018年 Lurich All rights reserved.
//

#import "SFEncryptString.h"

const char *sf_CString(const SFEncryptStringData *data)
{
    if (data->decoded == 1) return data->value;
    for (int i = 0; i < data->length; i++) {
        data->value[i] ^= data->factor;
    }
    ((SFEncryptStringData *)data)->decoded = 1;
    return data->value;
}

NSString *sf_OCString(const SFEncryptStringData *data)
{
    return [NSString stringWithUTF8String:sf_CString(data)];
}
