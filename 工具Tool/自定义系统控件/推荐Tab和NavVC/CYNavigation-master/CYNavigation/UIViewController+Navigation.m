//
//  UIViewController+Navigation.m
//  智能大棚
//
//  Created by 张春雨 on 16/8/16.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "UIViewController+Navigation.h"
#import <objc/runtime.h>

static const char navigationbar_Key ;
static const char backGesture_Key ;

@implementation UIViewController (CYNavigation)
@dynamic navigationbar , backGesture;

/**
 *  Build contact
 */
- (void)setNavigationbar:(CustomNavigationBar *)navigationbar{
    [self willChangeValueForKey:@"navigationbar"];
    objc_setAssociatedObject(self, &navigationbar_Key, navigationbar, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"navigationbar"];
}

- (CustomNavigationBar *)navigationbar{
    return objc_getAssociatedObject(self, &navigationbar_Key);
}

- (UIPanGestureRecognizer *)backGesture{
    [self.view layoutIfNeeded];
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, &backGesture_Key);
    if (!gesture) {
        gesture = [CYNavigationConfig shared].backGesture();
        [self.view addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &backGesture_Key, gesture, OBJC_ASSOCIATION_ASSIGN);
    }
    return gesture;
}

/**
 *  Initialize the navigationbar
 */
- (CustomNavigationBar *)standardNavigationbar{
    CustomNavigationBar * navigationbar = [[CustomNavigationBar alloc]initWithFrame:
                                           CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,
                                                      [CYNavigationConfig shared].height)];
    [self.view addSubview:navigationbar];
    return navigationbar;
}

@end
