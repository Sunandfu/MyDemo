//
//  NSString+SFAES.m
//  TestAdA
//
//  Created by lurich on 2019/3/21.
//  Copyright © 2019 YX. All rights reserved.
//

#import "NSString+SFAES.h"
#import "YXGTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
// key跟后台协商一个即可，保持一致
static NSString *const PSW_AES_KEY = @"!@#_123_sda_12!_";
// 这里的偏移量也需要跟后台一致，一般跟key一样就行
static NSString *const AES_IV_PARAMETER = @"";

@implementation NSString (SFAES)

//加密
- (NSString *)sf_AESEncryptString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:PSW_AES_KEY
                                         iv:nil];
    NSString *baseStr_GTM = [self encodeBase64Data:AESData];
    baseStr_GTM = [baseStr_GTM stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    baseStr_GTM = [baseStr_GTM stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//    baseStr_GTM = [baseStr_GTM stringByReplacingOccurrencesOfString:@"=" withString:@" "];
    return baseStr_GTM;
}
//解密
- (NSDictionary *)sf_AESDecryptString{
    NSString *tmpStr = self;
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    int a = tmpStr.length%4;
    if (a>0) {
        for (int i=0; i<(4-a); i++) {
            tmpStr = [tmpStr stringByAppendingString:@"="];
        }
    }
    NSData *data = [tmpStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *baseData_GTM = [self decodeBase64Data:data];
    NSData *AESData_GTM = [self AES128operation:kCCDecrypt
                                           data:baseData_GTM
                                            key:PSW_AES_KEY
                                             iv:nil];
    NSString *decStr_GTM = [[NSString alloc] initWithData:AESData_GTM encoding:NSUTF8StringEncoding];
    NSDictionary *dataDict = [self dictionaryWithJsonString:decStr_GTM];
    return dataDict;
}
/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    
    char keyPtr[kCCKeySizeAES128 + 1];  //kCCKeySizeAES128是加密位数 可以替换成256位的
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // 设置加密参数
    /**
     这里设置的参数ios默认为CBC加密方式，如果需要其他加密方式如ECB，在kCCOptionPKCS7Padding这个参数后边加上kCCOptionECBMode，即kCCOptionPKCS7Padding | kCCOptionECBMode，但是记得修改上边的偏移量，因为只有CBC模式有偏移量之说
     
     */
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
//        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
//        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}
// 这里附上YXGTMBase64编码的代码，可以手动写一个分类，也可以直接cocopods下载，pod 'YXGTMBase64'。
/**< YXGTMBase64编码 */
- (NSString*)encodeBase64Data:(NSData *)data {
    data = [YXGTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

/**< YXGTMBase64解码 */
- (NSData*)decodeBase64Data:(NSData *)data {
    data = [YXGTMBase64 decodeData:data];
    return data;
}

//将字典 数组 h转化为json字符串
+ (NSString *)sf_jsonStringWithJson:(id)data{
    if (([data isKindOfClass:[NSDictionary class]]) || ([data isKindOfClass:[NSArray class]])) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (!jsonData) {
            NSLog(@"%@",error);
        }else{
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        NSRange range = {0,jsonString.length};
        //去掉字符串中的空格
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        NSRange range2 = {0,mutStr.length};
        //去掉字符串中的换行符
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        return mutStr;
    } else {
        return nil;
    }
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        //        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
