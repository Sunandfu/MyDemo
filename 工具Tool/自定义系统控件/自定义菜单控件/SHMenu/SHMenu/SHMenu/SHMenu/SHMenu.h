//
//  SHMenu.h
//  SHMenu
//
//  Created by 宋浩文的pro on 16/4/15.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHMenu;

typedef enum {
    
    MenuDismiss,      // 消失
    MenuShow,        // 显示
    
} MenuState;


@interface SHMenu : UIView


/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;

/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentVC;


/** 内容偏移位置 */
@property (nonatomic, assign) CGPoint contentOrigin;


/** 锚点 */
@property (nonatomic, assign) CGPoint anchorPoint;

/** 菜单的背景气泡 */
@property (nonatomic, copy) NSString *backgroundImage;


/**
 *  菜单的显示状态
 */
@property (nonatomic, assign) MenuState state;


/** 隐藏menu */
- (void)hideMenu;
/** 从view下面显示菜单 */
- (void)showFromView:(UIView *)view;
/** 从某个点显示菜单 */
- (void)showFromPoint:(CGPoint)point;

@end
