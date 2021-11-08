//
//  NSString+SFAES.m
//  TestAdA
//
//  Created by lurich on 2019/3/21.
//  Copyright © 2019 . All rights reserved.
//

#import "NSString+SFAES.h"
#import "NSData+SFAES.h"
#import "SFEncryptStringData.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (SFAES)

//加密
- (NSString *)sf_AESEncryptString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:sf_OCString(_3987986293)
                                         iv:sf_OCString(_496376346)];
    NSString *baseStr_GTM = [AESData sf_base64EncodedString];
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
    NSData *baseData_GTM = [NSData sf_dataWithBase64EncodedString:tmpStr];
    NSData *AESData_GTM = [self AES128operation:kCCDecrypt
                                           data:baseData_GTM
                                            key:sf_OCString(_3987986293)
                                             iv:sf_OCString(_496376346)];
    NSString *decStr_GTM = [[NSString alloc] initWithData:AESData_GTM encoding:NSUTF8StringEncoding];
    NSDictionary *dataDict = [self dictionaryWithJsonString:decStr_GTM];
    return dataDict?dataDict:@{@"key":decStr_GTM};
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
     *************************************************************************************************************************************************************
     CBC模式：kCCOptionPKCS7Padding   需要偏移量：iv
     CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                             keyPtr, kCCKeySizeAES128,
                                             ivPtr,
                                             [data bytes], [data length],
                                             buffer, bufferSize,
                                             &numBytesEncrypted);
     *************************************************************************************************************************************************************
     ECB模式：kCCOptionPKCS7Padding | kCCOptionECBMode   不需要偏移量
     CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                             keyPtr, kCCKeySizeAES128,
                                             nil,
                                             [data bytes], [data length],
                                             buffer, bufferSize,
                                             &numBytesEncrypted);
     *************************************************************************************************************************************************************
     */
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
    }
    free(buffer);
    return nil;
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
    } else if ([data isKindOfClass:[NSString class]]) {
        NSMutableString *mutStr = [NSMutableString stringWithString:data];
        NSRange range = {0,mutStr.length};
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
void VOS_FREE(void *pData)
{
    if (NULL != pData)
    {
        free(pData);
        pData = NULL;
    }
    return;
}
- (NSString *)sf_request_EncryptWithKey:(NSString *)key{
    NSData *tmpData = [sf_OCString(_1728085117) dataUsingEncoding:NSUTF8StringEncoding];
    Byte *tmpByte = (Byte *)[tmpData bytes];
    
    NSData *testData = [self dataUsingEncoding:NSUTF8StringEncoding];
    //字符串转化成 data
    Byte *testByte = (Byte *)[testData bytes];
    uint8_t *bytes = malloc(sizeof(*bytes)*testData.length);
    for(int i = 0;i < [testData length];i++){
        bytes[i] = testByte[i];
        for (int j=0; j<[tmpData length]; j++) {
            bytes[i] = bytes[i] ^ tmpByte[j];
        }
    }
    NSData *base_data = [NSData dataWithBytes:bytes length:testData.length];
    VOS_FREE(bytes);
    NSString *baseStr_GTM = [base_data sf_base64EncodedString];
    baseStr_GTM = [baseStr_GTM stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    baseStr_GTM = [baseStr_GTM stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    baseStr_GTM = [baseStr_GTM stringByReplacingOccurrencesOfString:@"=" withString:@""];
    return baseStr_GTM;
}

- (NSDictionary *)sf_request_DecryptWithKey:(NSString *)key{
    NSString *tmpStr = self;
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    int a = tmpStr.length%4;
    if (a>0) {
        for (int i=0; i<(4-a); i++) {
            tmpStr = [tmpStr stringByAppendingString:@"="];
        }
    }
    NSData *tmpData = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte *tmpByte = (Byte *)[tmpData bytes];
    NSData *testData = [NSData sf_dataWithBase64EncodedString:tmpStr];
    //字符串转化成 data
    Byte *testByte = (Byte *)[testData bytes];
    uint8_t *bytes = malloc(sizeof(*bytes)*testData.length);
    for(int i = 0;i < [testData length];i++){
        bytes[i] = testByte[i];
        for (int j=0; j<[tmpData length]; j++) {
            bytes[i] = bytes[i] ^ tmpByte[j];
        }
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:testData.length];
    VOS_FREE(bytes);
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingAllowFragments error:nil];
    return dict;
}
- (NSString *)sf_MD5EncryptString{
    NSString *tmpStr = self;
    const char *original_str = [tmpStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    size_t len = strlen(original_str);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD5(original_str, (uint32_t)len, result);
#pragma clang diagnostic pop
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)sf_request_Encrypt{
    return [self sf_request_EncryptWithKey:sf_OCString(_1728085117)];
}

- (NSDictionary *)sf_request_Decrypt{
    return [self sf_request_DecryptWithKey:sf_OCString(_1728085117)];
}
- (NSString *)sf_task_Encrypt{
    return [self sf_request_EncryptWithKey:sf_OCString(_3233089245)];
}

- (NSDictionary *)sf_task_Decrypt{
    return [self sf_request_DecryptWithKey:sf_OCString(_3233089245)];
}

@end
