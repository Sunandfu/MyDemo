//
//  PYLabel.h
//  iOS-Echarts
//
//  Created by Pluto Y on 15/9/8.
//  Copyright (c) 2015年 pluto-y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYTextStyle.h"

@interface PYLabel : NSObject

@property (assign, nonatomic) BOOL show;
@property (retain, nonatomic) NSString *position;
@property (assign, nonatomic) BOOL rotate;
@property (retain, nonatomic) NSNumber *distance;
@property (retain, nonatomic) id formatter;
@property (retain, nonatomic) PYTextStyle *textStyle;
@property (retain, nonatomic) NSNumber *x;
@property (retain, nonatomic) NSNumber *y;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com