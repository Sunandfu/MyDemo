//
//  YXPopupMenuPath.m
//  YXPopupMenu
//
//  Created by lyb on 2017/5/9.
//  Copyright © 2017年 lyb. All rights reserved.
//

#import "YXPopupMenuPath.h"
#import "YXRectConst.h"

@implementation YXPopupMenuPath

+ (CAShapeLayer *)yb_maskLayerWithRect:(CGRect)rect
                            rectCorner:(UIRectCorner)rectCorner
                          cornerRadius:(CGFloat)cornerRadius
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition
                        arrowDirection:(YXPopupMenuArrowDirection)arrowDirection
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self yb_bezierPathWithRect:rect rectCorner:rectCorner cornerRadius:cornerRadius borderWidth:0 borderColor:nil backgroundColor:nil arrowWidth:arrowWidth arrowHeight:arrowHeight arrowPosition:arrowPosition arrowDirection:arrowDirection].CGPath;
    return shapeLayer;
}


+ (UIBezierPath *)yb_bezierPathWithRect:(CGRect)rect
                             rectCorner:(UIRectCorner)rectCorner
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                        backgroundColor:(UIColor *)backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition
                         arrowDirection:(YXPopupMenuArrowDirection)arrowDirection
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (borderColor) {
        [borderColor setStroke];
    }
    if (backgroundColor) {
        [backgroundColor setFill];
    }
    bezierPath.lineWidth = borderWidth;
    rect = CGRectMake(borderWidth / 2, borderWidth / 2, YXRectWidth(rect) - borderWidth, YXRectHeight(rect) - borderWidth);
    CGFloat topRightRadius = 0,topLeftRadius = 0,bottomRightRadius = 0,bottomLeftRadius = 0;
    CGPoint topRightArcCenter,topLeftArcCenter,bottomRightArcCenter,bottomLeftArcCenter;
    
    if (rectCorner & UIRectCornerTopLeft) {
        topLeftRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerTopRight) {
        topRightRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerBottomLeft) {
        bottomLeftRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerBottomRight) {
        bottomRightRadius = cornerRadius;
    }
    
    if (arrowDirection == YXPopupMenuArrowDirectionTop) {
        topLeftArcCenter = CGPointMake(topLeftRadius + YXRectX(rect), arrowHeight + topLeftRadius + YXRectX(rect));
        topRightArcCenter = CGPointMake(YXRectWidth(rect) - topRightRadius + YXRectX(rect), arrowHeight + topRightRadius + YXRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) - bottomLeftRadius + YXRectX(rect));
        bottomRightArcCenter = CGPointMake(YXRectWidth(rect) - bottomRightRadius + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius + YXRectX(rect));
        if (arrowPosition < topLeftRadius + arrowWidth / 2) {
            arrowPosition = topLeftRadius + arrowWidth / 2;
        }else if (arrowPosition > YXRectWidth(rect) - topRightRadius - arrowWidth / 2) {
            arrowPosition = YXRectWidth(rect) - topRightRadius - arrowWidth / 2;
        }
        [bezierPath moveToPoint:CGPointMake(arrowPosition - arrowWidth / 2, arrowHeight + YXRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition, YXRectTop(rect) + YXRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition + arrowWidth / 2, arrowHeight + YXRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) - topRightRadius, arrowHeight + YXRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius - YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) + YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectX(rect), arrowHeight + topLeftRadius + YXRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        
    }else if (arrowDirection == YXPopupMenuArrowDirectionBottom) {
        topLeftArcCenter = CGPointMake(topLeftRadius + YXRectX(rect),topLeftRadius + YXRectX(rect));
        topRightArcCenter = CGPointMake(YXRectWidth(rect) - topRightRadius + YXRectX(rect), topRightRadius + YXRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) - bottomLeftRadius + YXRectX(rect) - arrowHeight);
        bottomRightArcCenter = CGPointMake(YXRectWidth(rect) - bottomRightRadius + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius + YXRectX(rect) - arrowHeight);
        if (arrowPosition < bottomLeftRadius + arrowWidth / 2) {
            arrowPosition = bottomLeftRadius + arrowWidth / 2;
        }else if (arrowPosition > YXRectWidth(rect) - bottomRightRadius - arrowWidth / 2) {
            arrowPosition = YXRectWidth(rect) - bottomRightRadius - arrowWidth / 2;
        }
        [bezierPath moveToPoint:CGPointMake(arrowPosition + arrowWidth / 2, YXRectHeight(rect) - arrowHeight + YXRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition, YXRectHeight(rect) + YXRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition - arrowWidth / 2, YXRectHeight(rect) - arrowHeight + YXRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) - arrowHeight + YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectX(rect), topLeftRadius + YXRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) - topRightRadius + YXRectX(rect), YXRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius - YXRectX(rect) - arrowHeight)];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
    }else if (arrowDirection == YXPopupMenuArrowDirectionLeft) {
        topLeftArcCenter = CGPointMake(topLeftRadius + YXRectX(rect) + arrowHeight,topLeftRadius + YXRectX(rect));
        topRightArcCenter = CGPointMake(YXRectWidth(rect) - topRightRadius + YXRectX(rect), topRightRadius + YXRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + YXRectX(rect) + arrowHeight, YXRectHeight(rect) - bottomLeftRadius + YXRectX(rect));
        bottomRightArcCenter = CGPointMake(YXRectWidth(rect) - bottomRightRadius + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius + YXRectX(rect));
        if (arrowPosition < topLeftRadius + arrowWidth / 2) {
            arrowPosition = topLeftRadius + arrowWidth / 2;
        }else if (arrowPosition > YXRectHeight(rect) - bottomLeftRadius - arrowWidth / 2) {
            arrowPosition = YXRectHeight(rect) - bottomLeftRadius - arrowWidth / 2;
        }
        [bezierPath moveToPoint:CGPointMake(arrowHeight + YXRectX(rect), arrowPosition + arrowWidth / 2)];
        [bezierPath addLineToPoint:CGPointMake(YXRectX(rect), arrowPosition)];
        [bezierPath addLineToPoint:CGPointMake(arrowHeight + YXRectX(rect), arrowPosition - arrowWidth / 2)];
        [bezierPath addLineToPoint:CGPointMake(arrowHeight + YXRectX(rect), topLeftRadius + YXRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) - topRightRadius, YXRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius - YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(arrowHeight + bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) + YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        
    }else if (arrowDirection == YXPopupMenuArrowDirectionRight) {
        topLeftArcCenter = CGPointMake(topLeftRadius + YXRectX(rect),topLeftRadius + YXRectX(rect));
        topRightArcCenter = CGPointMake(YXRectWidth(rect) - topRightRadius + YXRectX(rect) - arrowHeight, topRightRadius + YXRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) - bottomLeftRadius + YXRectX(rect));
        bottomRightArcCenter = CGPointMake(YXRectWidth(rect) - bottomRightRadius + YXRectX(rect) - arrowHeight, YXRectHeight(rect) - bottomRightRadius + YXRectX(rect));
        if (arrowPosition < topRightRadius + arrowWidth / 2) {
            arrowPosition = topRightRadius + arrowWidth / 2;
        }else if (arrowPosition > YXRectHeight(rect) - bottomRightRadius - arrowWidth / 2) {
            arrowPosition = YXRectHeight(rect) - bottomRightRadius - arrowWidth / 2;
        }
        [bezierPath moveToPoint:CGPointMake(YXRectWidth(rect) - arrowHeight + YXRectX(rect), arrowPosition - arrowWidth / 2)];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) + YXRectX(rect), arrowPosition)];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) - arrowHeight + YXRectX(rect), arrowPosition + arrowWidth / 2)];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) - arrowHeight + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius - YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) + YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectX(rect), arrowHeight + topLeftRadius + YXRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) - topRightRadius + YXRectX(rect) - arrowHeight, YXRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        
    }else if (arrowDirection == YXPopupMenuArrowDirectionNone) {
        topLeftArcCenter = CGPointMake(topLeftRadius + YXRectX(rect),  topLeftRadius + YXRectX(rect));
        topRightArcCenter = CGPointMake(YXRectWidth(rect) - topRightRadius + YXRectX(rect),  topRightRadius + YXRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) - bottomLeftRadius + YXRectX(rect));
        bottomRightArcCenter = CGPointMake(YXRectWidth(rect) - bottomRightRadius + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius + YXRectX(rect));
        [bezierPath moveToPoint:CGPointMake(topLeftRadius + YXRectX(rect), YXRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) - topRightRadius, YXRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectWidth(rect) + YXRectX(rect), YXRectHeight(rect) - bottomRightRadius - YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + YXRectX(rect), YXRectHeight(rect) + YXRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(YXRectX(rect), arrowHeight + topLeftRadius + YXRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
    }
    
    [bezierPath closePath];
    return bezierPath;
}

@end
