//
//  TYCircleView.m
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import "TYCircleView.h"
#import "TYCircleMacros.h"

@implementation TYCircleView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGFloat radius = self.bounds.size.width/2;
    CGContextAddArc(con, radius, radius, radius, 0, 2*M_PI, NO);
    CGContextAddArc(con, radius, radius, radius-TYCircleCellSize.height-2*TYDefaultItemPadding, 2*M_PI, 0, YES);
    CGContextSetFillColorWithColor(con, [UIColor colorWithRed:0 green:52/255.0 blue:118/255.0 alpha:1.0].CGColor);
    CGContextFillPath(con);
}

    
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com