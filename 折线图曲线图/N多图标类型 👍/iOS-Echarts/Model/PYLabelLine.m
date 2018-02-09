//
//  PYLabelLine.m
//  iOS-Echarts
//
//  Created by Pluto Y on 15/9/8.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import "PYLabelLine.h"

@implementation PYLabelLine

- (instancetype)init
{
    self = [super init];
    if (self) {
        _show = YES;
        _length = @(40);
        _lineStyle = [[PYLineStyle alloc] init];
    }
    return self;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com