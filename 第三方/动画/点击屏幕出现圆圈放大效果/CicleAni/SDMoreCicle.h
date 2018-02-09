//
//  SDMoreCicle.h
//
//  Created by LSD on 15/10/23.
//  Copyright (c) 2015年 Joky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDMoreCicle : UIView

//给定一个触摸的位置 在整个屏幕散圆
+(instancetype)viewWithCicle:(CGRect)rect;
-(instancetype)initWithFrame:(CGRect)frame;

@end
