//
//  UIViewController+Category.m
//  ChangeIcon
//
//  Created by 侯克楠 on 2018/9/10.
//  Copyright © 2018年 侯克楠. All rights reserved.
//

#import "UIViewController+Category.h"

#import <objc/runtime.h>

@implementation UIViewController (Category)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method dismissAlertViewController = class_getInstanceMethod(self.class, @selector(dismissAlertViewControllerPresentViewController:animated:completion:));
        //runtime方法交换
        //通过拦截弹框事件,实现方法转换,从而去掉弹框
        method_exchangeImplementations(presentM, dismissAlertViewController);
    });
}

- (void)dismissAlertViewControllerPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {
            return;
        }
    }
    [self dismissAlertViewControllerPresentViewController:viewControllerToPresent animated:animated completion:completion];
}
@end
