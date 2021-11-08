//
//  UIView+SFAdd.h
//  TestAdA
//
//  Created by lurich on 2021/4/12.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAdConst.h"

typedef struct SFLayoutAnchor {
    NSLayoutYAxisAnchor *top;
    NSLayoutXAxisAnchor *left;
    NSLayoutYAxisAnchor *bottom;
    NSLayoutXAxisAnchor *right;
} SFLayoutAnchor;

@interface UIView (SFAdd)

@property (assign, nonatomic) CGFloat sf_x;
@property (assign, nonatomic) CGFloat sf_y;
@property (assign, nonatomic) CGFloat sf_width;
@property (assign, nonatomic) CGFloat sf_height;
@property (assign, nonatomic) CGFloat  sf_centerX;
@property (assign, nonatomic) CGFloat  sf_centerY;
@property (assign, nonatomic) CGSize  sf_size;
@property (assign, nonatomic) CGPoint sf_origin;

- (void)sf_fillSuperView;
- (void)sf_anchorWithView:(UIView *)supview Padding:(UIEdgeInsets)padding;
- (void)sf_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right;
- (void)sf_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding;
- (void)sf_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding Size:(CGSize)size;
- (void)sf_anchorWithLessThanSize:(CGSize)size;
- (void)sf_anchorWithGreaterThanSize:(CGSize)size;
- (void)sf_anchorWithCenterX:(NSLayoutXAxisAnchor *)centerX CenterY:(NSLayoutYAxisAnchor *)centerY Padding:(UIOffset)padding Size:(CGSize)size;
- (void)sf_anchorAnimateChangeXWith:(NSLayoutXAxisAnchor *)centerX;

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen;

@end
