//
//  PYAxisPointer.m
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/9/15.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import "PYAxisPointer.h"


#define AXIS_POINT_SCOPE [NSArray arrayWithObjects:@"line", @"cross", @"shadow", @"none", nil]
@interface PYAxisPointer()

@end


@implementation PYAxisPointer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = @"line";
    }
    return self;
}

-(void)setType:(NSString *)type {
    if (![AXIS_POINT_SCOPE containsObject:type]) {
        NSLog(@"ERROR: AxisPoint does not support the type --- %@", type);
        type = @"line";
    }
    _type = type;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com