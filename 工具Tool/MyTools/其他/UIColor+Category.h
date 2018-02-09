//
//  UIColor+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)
/**
 *  随机颜色
 */
+ (UIColor *)randomColor;
/**
 *  根据GRB生成指定颜色
 */
+ (UIColor *)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B;
/*
 *  传入字符串，如@“FFFFFF”   返回颜色
 */
+(UIColor *)colorWithHexString:(NSString *)color;

@end
