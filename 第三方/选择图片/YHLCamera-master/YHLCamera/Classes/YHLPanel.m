//
//  YHLPanel.m
//  YHLCamera_Example
//
//  Created by che on 2018/7/5.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import "YHLPanel.h"

@implementation YHLPanel


- (void)drawRect:(CGRect)rect {
     if(self.type==personType ){
        CGFloat x = ([UIScreen mainScreen].bounds.size.width-240)*0.5;
        CGFloat y = ([UIScreen mainScreen].bounds.size.height-360-80)*0.5;//80 底部空白
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, 240, 240) byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(12, 12)];
        [path fillWithBlendMode:kCGBlendModeClear alpha:1.0];
        
        UIBezierPath *path2= [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, 240, 240) byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(12, 12)];
        path2.lineWidth=1;
        [[UIColor whiteColor] set];
        [path2 stroke];
    }else if ( self.type==defaultType){
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
        [path fillWithBlendMode:kCGBlendModeClear alpha:1.0];
        
//        UIBezierPath *path2= [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, 240, 240) byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(12, 12)];
//        path2.lineWidth=1;
//        [[UIColor whiteColor] set];
//        [path2 stroke];
    }else{
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 150, rect.size.width-30, (rect.size.width-30)*11.0/16) byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(12, 12)];
        [path fillWithBlendMode:kCGBlendModeClear alpha:1.0];
        
        UIBezierPath *path2= [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 150, rect.size.width-30, (rect.size.width-30)*11.0/16) byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(12, 12)];
        path2.lineWidth=1;
        [[UIColor whiteColor] set];
        [path2 stroke];
    }
    
}


@end
