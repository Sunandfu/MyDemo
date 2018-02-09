//
//  PYTitle.h
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/9/14.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PYColor, PYTextStyle;

@interface PYTitle : NSObject

@property (assign, nonatomic) BOOL show;
@property (retain, nonatomic) NSNumber *zlevel;
@property (retain, nonatomic) NSNumber *z;
@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) NSString *link;
@property (retain, nonatomic) NSString *target;
@property (retain, nonatomic) NSString *subtext;
@property (retain, nonatomic) NSString *sublink;
@property (retain, nonatomic) NSString *subtarget;
@property (retain, nonatomic) id x;
@property (retain, nonatomic) id y;
@property (retain, nonatomic) NSString *textAlign;
@property (retain, nonatomic) PYColor *backgroundColor;
@property (retain, nonatomic) PYColor *borderColor;
@property (retain, nonatomic) NSNumber *borderWidth;
@property (retain, nonatomic) id padding;
@property (retain, nonatomic) NSNumber *itemGap;
@property (retain, nonatomic) PYTextStyle *textStyle;
@property (retain, nonatomic) PYTextStyle *subtextStyle;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com