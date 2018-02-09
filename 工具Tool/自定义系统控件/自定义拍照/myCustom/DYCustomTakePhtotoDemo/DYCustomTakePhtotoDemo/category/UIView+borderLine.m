//
//  UIView+borderLine.m
//  LetMeSpend
//
//  Created by 袁斌 on 16/2/16.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "UIView+borderLine.h"

@implementation UIView (borderLine)

- (void)cornerRadius:(CGFloat)cornerRadius borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor;
    self.layer.borderWidth = borderWidth;

}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com