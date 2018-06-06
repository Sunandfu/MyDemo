//
//  NSObject+MJParse.h
//  BaseProject
//
//  Created by hzxsdz008 on 15/12/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface NSObject (MJParse)
/*
 MJExtension 解析数组和字典需要使用不同的方法.
 我们自己合并,用代码判断
 */

+(id)parse:(id)responseObj;
@end
