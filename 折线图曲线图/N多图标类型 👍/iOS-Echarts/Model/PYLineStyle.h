//
//  PYLineStyle.h
//  iOS-Echarts
//
//  Created by Pluto Y on 15/9/7.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PYColor;

@interface PYLineStyle : NSObject

@property (retain, nonatomic) id color;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSNumber *width;
@property (retain, nonatomic) PYColor *shadowColor;
@property (retain, nonatomic) NSNumber *shadowBlur;
@property (retain, nonatomic) NSNumber *shadowOffsetX;
@property (retain, nonatomic) NSNumber *shadowOffsetY;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com