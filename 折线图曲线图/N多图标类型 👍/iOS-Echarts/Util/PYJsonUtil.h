//
//  JsonUtil.h
//  iOS-Echarts
//
//  Created by Pluto Y on 15/9/8.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYJsonUtil : NSObject


/**
 *  NSObject转json
 *
 *  @param obj 带信息的NSObject对象
 *
 *  @return 转换后的Json
 */
+(NSString *)getJSONString:(id)obj;

/**
 *  NSObject转json
 *
 *  @param obj 带信息的NSObject对象
 *
 *  @return 转换后的包含Json的NSData
 */
+ (NSData*)getJSONData:(id)obj;


/**
 *  将指定对象转换成NSDirectory
 *
 *  @param obj 需要转换的对象
 *
 *  @return 转换后的NSDictionary对象
 */
+ (NSDictionary*)getObjectData:(id)obj;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com