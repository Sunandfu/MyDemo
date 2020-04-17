//
//  UIView+YXExtension.m
//  YXRefreshView
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//


#import "UIView+YXExtension.h"

@implementation UIView (YXExtension)

- (CGFloat)YX_height {
    return self.frame.size.height;
}

- (void)setYX_height:(CGFloat)YX_height {
    CGRect temp = self.frame;
    temp.size.height = YX_height;
    self.frame = temp;
}

- (CGFloat)YX_width {
    return self.frame.size.width;
}

- (void)setYX_width:(CGFloat)YX_width {
    CGRect temp = self.frame;
    temp.size.width = YX_width;
    self.frame = temp;
}

- (CGFloat)YX_y {
    return self.frame.origin.y;
}

- (void)setYX_y:(CGFloat)YX_y {
    CGRect temp = self.frame;
    temp.origin.y = YX_y;
    self.frame = temp;
}

- (CGFloat)YX_x {
    return self.frame.origin.x;
}

- (void)setYX_x:(CGFloat)YX_x {
    CGRect temp = self.frame;
    temp.origin.x = YX_x;
    self.frame = temp;
}

@end
