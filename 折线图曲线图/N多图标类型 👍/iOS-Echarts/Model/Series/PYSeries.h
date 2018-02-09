//
//  PYSeries.h
//  iOS-Echarts
//
//  Created by Pluto Y on 15/9/8.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYItemStyle.h"
#import "PYTooltip.h"
#import "PYMarkLine.h"
#import "PYMarkPoint.h"

@interface PYSeries : NSObject

@property (retain, nonatomic) NSNumber *zlevel;
@property (retain, nonatomic) NSNumber *z;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) PYTooltip *tooltip;
@property (assign, nonatomic) BOOL clickable;
@property (retain, nonatomic) PYItemStyle *itemStyle;
@property (retain, nonatomic) id data;
@property (retain, nonatomic) PYMarkPoint *markPoint;
@property (retain, nonatomic) PYMarkLine *markLine;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com