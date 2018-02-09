//
//  PYGrid.h
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/9/23.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PYColor;

@interface PYGrid : NSObject

@property (retain, nonatomic) NSNumber *zlevel;
@property (retain, nonatomic) NSNumber *z;
@property (retain, nonatomic) id x;
@property (retain, nonatomic) id y;
@property (retain, nonatomic) id x2;
@property (retain, nonatomic) id y2;
@property (retain, nonatomic) NSNumber *width;
@property (retain, nonatomic) NSNumber *height;
@property (retain, nonatomic) PYColor *backgroundColor;
@property (retain, nonatomic) NSNumber *borderWidth;
@property (retain, nonatomic) PYColor *borderColor;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com