//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by yz on 15/10/29.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "UIView+SFFrame.h"

@implementation UIView (SFFrame)

- (CGFloat)sf_height
{
    return self.frame.size.height;
}

- (CGFloat)sf_width
{
    return self.frame.size.width;
}

- (void)setSf_height:(CGFloat)sf_height {
    CGRect frame = self.frame;
    frame.size.height = sf_height;
    self.frame = frame;
}
- (void)setSf_width:(CGFloat)sf_width {
    CGRect frame = self.frame;
    frame.size.width = sf_width;
    self.frame = frame;
}

- (CGFloat)sf_x
{
    return self.frame.origin.x;
}

- (void)setSf_x:(CGFloat)sf_x {
    CGRect frame = self.frame;
    frame.origin.x = sf_x;
    self.frame = frame;
}


- (CGFloat)sf_y
{
    return self.frame.origin.y;
}


- (void)setSf_y:(CGFloat)sf_y {
    CGRect frame = self.frame;
    frame.origin.y = sf_y;
    self.frame = frame;
}


- (void)setSf_centerX:(CGFloat)sf_centerX {
    CGPoint center = self.center;
    center.x = sf_centerX;
    self.center = center;
}

- (CGFloat)sf_centerX
{
    return self.center.x;
}


- (void)setSf_centerY:(CGFloat)sf_centerY {
    CGPoint center = self.center;
    center.y = sf_centerY;
    self.center = center;
}

- (CGFloat)sf_centerY
{
    return self.center.y;
}

@end
