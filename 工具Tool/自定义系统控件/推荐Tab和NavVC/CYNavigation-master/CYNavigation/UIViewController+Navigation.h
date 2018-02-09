//
//  UIViewController+Navigation.h
//  智能大棚
//
//  Created by 张春雨 on 16/8/16.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CustomNavigationBar.h"

@interface UIViewController (CYNavigation)
/** navigationBar */
@property CustomNavigationBar *navigationbar;
/** 返回拖动手势 */
@property(readonly) UIPanGestureRecognizer *backGesture;

/**
 * 初始化navigationBar
 * @return 实例化后的navigationBar
 */
- (CustomNavigationBar *)standardNavigationbar;

@end
