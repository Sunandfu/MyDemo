//
//  PYAxisTick.h
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/10/28.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PYLineStyle;

@interface PYAxisTick : NSObject

@property (assign, nonatomic) BOOL show;
@property (retain, nonatomic) id interval;
@property (assign, nonatomic) BOOL onGap;
@property (assign, nonatomic) BOOL inside;
@property (retain, nonatomic) NSNumber *length;
@property (retain, nonatomic) PYLineStyle *lineStyle;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com