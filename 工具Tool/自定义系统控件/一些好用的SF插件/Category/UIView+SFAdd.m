//
//  UIView+SFAdd.m
//  TestAdA
//
//  Created by lurich on 2021/4/12.
//  Copyright © 2021 . All rights reserved.
//

#import "UIView+SFAdd.h"

@implementation UIView (SFAdd)

- (void)setSf_x:(CGFloat)sf_x
{
    CGRect frame = self.frame;
    frame.origin.x = sf_x;
    self.frame = frame;
}

- (CGFloat)sf_x
{
    return self.frame.origin.x;
}

- (void)setSf_y:(CGFloat)sf_y
{
    CGRect frame = self.frame;
    frame.origin.y = sf_y;
    self.frame = frame;
}

- (CGFloat)sf_y
{
    return self.frame.origin.y;
}

- (void)setSf_width:(CGFloat)sf_w
{
    CGRect frame = self.frame;
    frame.size.width = sf_w;
    self.frame = frame;
}

- (CGFloat)sf_width
{
    return self.frame.size.width;
}

- (void)setSf_height:(CGFloat)sf_h
{
    CGRect frame = self.frame;
    frame.size.height = sf_h;
    self.frame = frame;
}

- (CGFloat)sf_height
{
    return self.frame.size.height;
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

- (CGFloat)sf_centerY{
    return self.center.y;
}

- (void)setSf_size:(CGSize)sf_size
{
    CGRect frame = self.frame;
    frame.size = sf_size;
    self.frame = frame;
}

- (CGSize)sf_size
{
    return self.frame.size;
}

- (void)setSf_origin:(CGPoint)sf_origin
{
    CGRect frame = self.frame;
    frame.origin = sf_origin;
    self.frame = frame;
}

- (CGPoint)sf_origin
{
    return self.frame.origin;
}

- (void)sf_fillSuperView{
    [self sf_anchorWithTop:self.superview.topAnchor Left:self.superview.leftAnchor Bottom:self.superview.bottomAnchor Right:self.superview.rightAnchor];
}
- (void)sf_anchorWithView:(UIView *)supview Padding:(UIEdgeInsets)padding{
    [self sf_anchorWithTop:supview.topAnchor Left:supview.leftAnchor Bottom:supview.bottomAnchor Right:supview.rightAnchor Padding:padding Size:CGSizeZero];
}
- (void)sf_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right{
    [self sf_anchorWithTop:top Left:left Bottom:bottom Right:right Padding:UIEdgeInsetsZero Size:CGSizeZero];
}
- (void)sf_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding{
    [self sf_anchorWithTop:top Left:left Bottom:bottom Right:right Padding:padding Size:CGSizeZero];
}
- (void)sf_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding Size:(CGSize)size{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (top) {
        [self.topAnchor constraintEqualToAnchor:top constant:padding.top].active = YES;
    }
    if (left) {
        [self.leftAnchor constraintEqualToAnchor:left constant:padding.left].active = YES;
    }
    if (bottom) {
        [self.bottomAnchor constraintEqualToAnchor:bottom constant:-padding.bottom].active = YES;
    }
    if (right) {
        [self.rightAnchor constraintEqualToAnchor:right constant:-padding.right].active = YES;
    }
    if (size.width != 0) {
        [self.widthAnchor constraintEqualToConstant:size.width].active = YES;
    }
    if (size.height != 0) {
        [self.heightAnchor constraintEqualToConstant:size.height].active = YES;
    }
}
- (void)sf_anchorWithCenterX:(NSLayoutXAxisAnchor *)centerX CenterY:(NSLayoutYAxisAnchor *)centerY Padding:(UIOffset)padding Size:(CGSize)size{
    if (centerX) {
        [self.centerXAnchor constraintEqualToAnchor:centerX constant:padding.horizontal].active = YES;
    }
    if (centerY) {
        [self.centerYAnchor constraintEqualToAnchor:centerY constant:padding.vertical].active = YES;
    }
    if (size.width != 0) {
        [self.widthAnchor constraintEqualToConstant:size.width].active = YES;
    }
    if (size.height != 0) {
        [self.heightAnchor constraintEqualToConstant:size.height].active = YES;
    }
}
- (void)sf_anchorAnimateChangeXWith:(NSLayoutXAxisAnchor *)centerX{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (centerX) {
            [self.centerXAnchor constraintEqualToAnchor:centerX].active = YES;
        }
    } completion:^(BOOL finished) {
        NSLog(@"finished = %d",finished);
    }];
}
/**
     NSLayoutRelationLessThanOrEqual = -1,  // 小于等于 <=
     NSLayoutRelationEqual = 0,      // 等于 =
     NSLayoutRelationGreaterThanOrEqual = 1,    // 大于等于 >=
 */
- (void)sf_anchorWithLessThanSize:(CGSize)size{
    if (size.width != 0) {
        [self.widthAnchor constraintLessThanOrEqualToConstant:size.width].active = YES;
    }
    if (size.height != 0) {
        [self.heightAnchor constraintLessThanOrEqualToConstant:size.height].active = YES;
    }
}
- (void)sf_anchorWithGreaterThanSize:(CGSize)size{
    if (size.width != 0) {
        [self.widthAnchor constraintGreaterThanOrEqualToConstant:size.width].active = YES;
    }
    if (size.height != 0) {
        [self.heightAnchor constraintGreaterThanOrEqualToConstant:size.height].active = YES;
    }
}
- (void)addConstraintsWithFormat:(NSString *)format Views:(NSArray<UIView *> *)views{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //按照数组的顺序
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [mutableDict setObject:obj forKey:[NSString stringWithFormat:@"v%lu",(unsigned long)idx]];
    }];
    /**
     //数组的反向
     [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSLog(@"\\\\nv:%@:\t%ld",obj, idx);
     }];
     //随机的打印
     [array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSLog(@"\\\\nv:%@:\t%ld",obj, idx);
     }];
     */
    
    NSLog(@"%@",mutableDict);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:mutableDict]];
}
// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen{
    // view不存在 或未添加到superview
    if (self == nil || self.superview == nil || self.window == nil) {
        return FALSE;
    }
    
    // view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame toView:nil];
    
    //如果可以滚动，清除偏移量
    if ([[self class] isSubclassOfClass:[UIScrollView class]]) {
        UIScrollView * scorll = (UIScrollView *)self;
        rect.origin.x += scorll.contentOffset.x;
        rect.origin.y += scorll.contentOffset.y;
    }
    
    // 若size为CGrectZero
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect) || CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    UIView *tmpView = self;
    while (tmpView.superview) {
        if (tmpView.superview && [tmpView.superview isEqual:[UIApplication sharedApplication].keyWindow]) {
            return TRUE;
        } else if (tmpView.superview) {
            tmpView = tmpView.superview;
        } else {
            return FALSE;
        }
    }
    return FALSE;
}

@end
