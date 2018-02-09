//
//  QNDns.h
//  QiniuSDK
//
//  Created by bailong on 15/1/2.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNDns : NSObject

+ (NSArray *)getAddresses:(NSString *)hostName;

+ (NSString *)getAddressesString:(NSString *)hostName;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com