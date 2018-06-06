//
//  UIColor+hexcolor.h
//  finbook
//
//  Created by 杨航 on 2018/1/5.
//  Copyright © 2018年 杨航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexcolor)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexColor:(NSString *)color andOpacity:(CGFloat)opacity;

@end
