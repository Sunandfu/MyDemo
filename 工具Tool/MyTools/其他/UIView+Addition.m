//
//  UIView+Addition.m
//  UIViewDemo4
//
//  Created by Hailong.wang on 15/7/29.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)
//宽
- (CGFloat)width {
    return self.frame.size.width;
}

//高
- (CGFloat)height {
    return self.frame.size.height;
}

//上
- (CGFloat)top {
    return self.frame.origin.y;
}

//下
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

//左
- (CGFloat)left {
    return self.frame.origin.x;
}

//右
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

//设置宽
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

//设置高
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

//设置x
- (void)setXOffset:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

//设置y
- (void)setYOffset:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

//设置Origin
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

//设置size
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
