//
//  YXPGIndexBannerSubiew.h
//  YXNewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/YXNewPagedFlowView

/******************************
 
 可以根据自己的需要继承YXPGIndexBannerSubiew
 
 ******************************/

#import <UIKit/UIKit.h>

@interface YXPGIndexBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, copy) void (^didSelectCellBlock)(NSInteger tag, YXPGIndexBannerSubiew *cell);

/**
 设置子控件frame,继承后要重写
 */
- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds;

@end
