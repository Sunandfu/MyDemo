//
//  PYTitle.m
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/9/14.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import "PYTitle.h"
#import "PYColor.h"
#import "PYTextStyle.h"

@implementation PYTitle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _show = YES;
        _zlevel = @(0);
        _z = @(0);
        _text = @"";
        _link = @"";
        _subtext = @"";
        _sublink = @"";
        _x = @"left";
        _y = @"top";
        _backgroundColor = PYRGBA(0, 0, 0, 0);
        _borderColor = PYRGBA(12, 12, 12, 1);
        _borderWidth = @(0);
        _padding = @(5);
        _itemGap = @(5);
        _textStyle = [[PYTextStyle alloc] init];
        _textStyle.fontSize = @(18);
        _textStyle.fontWeight = @"bolder";
        _textStyle.color = PYRGBA(3, 3, 3, 1);
        _subtextStyle = [[PYTextStyle alloc] init];
        _subtextStyle.color = PYRGBA(10, 10, 10, 1);
    }
    return self;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com