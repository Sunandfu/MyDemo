//
//  NSString+SFAES.h
//  TestAdA
//
//  Created by lurich on 2019/3/21.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SFAES)

/** 加密 */
- (NSString     *)sf_AESEncryptString;
/** 解密 */
- (NSDictionary *)sf_AESDecryptString;

/** 新版加密 */
- (NSString     *)sf_request_Encrypt;
/** 新版解密 */
- (NSDictionary *)sf_request_Decrypt;

/** H5交互解密 */
- (NSString *)sf_task_Encrypt;
/** H5交互解密 */
- (NSDictionary *)sf_task_Decrypt;

/** 将字典 数组 转化为json字符串 */
+ (NSString *)sf_jsonStringWithJson:(id)data;

/** MD5加密 */
- (NSString *)sf_MD5EncryptString;

@end

NS_ASSUME_NONNULL_END
