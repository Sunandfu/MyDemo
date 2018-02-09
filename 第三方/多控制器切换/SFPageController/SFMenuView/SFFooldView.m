//
//  SFFooldView.m
//  SFPageController
//
//  Created by Mark on 15/7/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "SFFooldView.h"

@implementation SFFooldView {
    CGFloat SFFooldMargin;
    CGFloat SFFooldRadius;
    CGFloat SFFooldLength;
    CGFloat SFFooldHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        SFFooldHeight = frame.size.height;
        SFFooldMargin = SFFooldHeight * 0.15;
        SFFooldRadius = (SFFooldHeight - SFFooldMargin * 2) / 2;
        SFFooldLength = frame.size.width  - SFFooldRadius * 2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    int currentIndex = (int)self.progress;
    CGFloat rate = self.progress - currentIndex;
    int nextIndex = currentIndex + 1 >= self.itemFrames.count ?: currentIndex + 1;

    // 当前item的各数值
    CGRect  currentFrame = [self.itemFrames[currentIndex] CGRectValue];
    CGFloat currentWidth = currentFrame.size.width;
    CGFloat currentX = currentFrame.origin.x;
    // 下一个item的各数值
    CGFloat nextWidth = [self.itemFrames[nextIndex] CGRectValue].size.width;
    CGFloat nextX = [self.itemFrames[nextIndex] CGRectValue].origin.x;
    // 计算点
    CGFloat startX = currentX + (nextX - currentX) * rate;
    CGFloat endX = startX + currentWidth + (nextWidth - currentWidth)*rate;
    // 绘制
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0f, SFFooldHeight);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    CGContextAddArc(ctx, startX+SFFooldRadius, SFFooldHeight / 2.0, SFFooldRadius, M_PI_2, M_PI_2 * 3, 0);
    CGContextAddLineToPoint(ctx, endX-SFFooldRadius, SFFooldMargin);
    CGContextAddArc(ctx, endX-SFFooldRadius, SFFooldHeight / 2.0, SFFooldRadius, -M_PI_2, M_PI_2, 0);
    CGContextClosePath(ctx);
    
    if (self.hollow) {
        CGContextSetStrokeColorWithColor(ctx, self.color);
        CGContextStrokePath(ctx);
        return;
    }
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.color);
    CGContextFillPath(ctx);
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com