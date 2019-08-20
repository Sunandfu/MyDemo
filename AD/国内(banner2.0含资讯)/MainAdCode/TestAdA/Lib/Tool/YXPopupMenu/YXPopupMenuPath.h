//
//  YXPopupMenuPath.h
//  YXPopupMenu
//
//  Created by lyb on 2017/5/9.
//  Copyright © 2017年 lyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXPopupMenuArrowDirection) {
    YXPopupMenuArrowDirectionTop = 0,  //箭头朝上
    YXPopupMenuArrowDirectionBottom,   //箭头朝下
    YXPopupMenuArrowDirectionLeft,     //箭头朝左
    YXPopupMenuArrowDirectionRight,    //箭头朝右
    YXPopupMenuArrowDirectionNone      //没有箭头
};

@interface YXPopupMenuPath : NSObject

+ (CAShapeLayer *)yb_maskLayerWithRect:(CGRect)rect
                            rectCorner:(UIRectCorner)rectCorner
                          cornerRadius:(CGFloat)cornerRadius
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition
                        arrowDirection:(YXPopupMenuArrowDirection)arrowDirection;

+ (UIBezierPath *)yb_bezierPathWithRect:(CGRect)rect
                             rectCorner:(UIRectCorner)rectCorner
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                        backgroundColor:(UIColor *)backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition
                         arrowDirection:(YXPopupMenuArrowDirection)arrowDirection;
@end
