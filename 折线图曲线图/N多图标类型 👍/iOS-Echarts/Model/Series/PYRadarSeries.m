//
//  PYRadarSeries.m
//  iOS-Echarts
//
//  Created by Pluto Y on 15/12/21.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import "PYRadarSeries.h"

@implementation PYRadarSeries

- (instancetype)init
{
    self = [super init];
    if (self) {
        _polarIndex = (0);
        _symbolSize = @(2);
        _legendHoverLink = YES;
    }
    return self;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com