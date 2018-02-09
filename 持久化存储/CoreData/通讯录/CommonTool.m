//
//  CommonTool.m
//  05-通讯录
//
//  Created by Alvechen on 15/11/22.
//  Copyright © 2015年 Alvechen. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool


/**
*  汉语转拼音
*/
+ (NSString *)getPinYinFromString:(NSString *)string{
CFMutableStringRef aCstring = CFStringCreateMutableCopy(NULL, 0, (__bridge_retained CFStringRef)string);
    
    /**
     *  创建可变CFString
     *
     *  @param NULL 使用默认创建器
     *  @param 0    长度不限制
     *  @param "张三" cf字串
     *
     *  @return 可变字符串
     */

/**
 1. string: 要转换的字符串(可变的)
 2. range: 要转换的范围 NULL全转换
 3. transform: 指定要怎样的转换
 4. reverse: 是否可逆的转换
 */
CFStringTransform(aCstring, NULL, kCFStringTransformMandarinLatin, NO);

CFStringTransform(aCstring, NULL, kCFStringTransformStripDiacritics, NO);


NSLog(@"%@",aCstring);

return [NSString stringWithFormat:@"%@",aCstring];
}

@end
