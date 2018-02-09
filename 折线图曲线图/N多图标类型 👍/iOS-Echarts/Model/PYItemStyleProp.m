//
//  PYItemStyleProp.m
//  iOS-Echarts
//
//  Created by Pluto Y on 15/9/8.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import "PYItemStyleProp.h"
#import "PYColor.h"

@implementation PYItemStyleProp

- (instancetype)init
{
    self = [super init];
    if (self) {
        _barBorderColor = PYRGBA(0xf, 0xf, 0xf, 1);
        _label = [[PYLabel alloc] init];
        _label.show = YES;
        _label.position = @"outer";
        _labelLine = [[PYLabelLine alloc] init];
        _labelLine.show = YES;
    }
    return self;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com