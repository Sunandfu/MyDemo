//
//  NSString+SFAES.h
//  TestAdA
//
//  Created by lurich on 2019/3/21.
//  Copyright © 2019 YX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SFAES)

//加密
- (NSString     *)sf_AESEncryptString;
//解密
- (NSDictionary *)sf_AESDecryptString;
//将字典 数组 h转化为json字符串
+ (NSString *)sf_jsonStringWithJson:(id)data;

@end

NS_ASSUME_NONNULL_END
