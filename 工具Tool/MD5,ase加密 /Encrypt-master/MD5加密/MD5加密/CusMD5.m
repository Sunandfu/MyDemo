//
//  CusMD5.m
//  EncryptAndDecrypt
//
//  Created by stkcctv on 16/9/10.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "CusMD5.h"
#import <CommonCrypto/CommonDigest.h>

/*
 MD5只能称为一种不可逆的加密算法，只能用作一些检验过程，不能恢复其原文。
 */

@implementation CusMD5

+ (NSString *)md5String:(NSString *)str {
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


@end
