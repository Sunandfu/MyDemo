//
//  UIViewController+UIViewController_SFScrollPageController.m
//  SFScrollPageView
//
//  Created by jasnig on 16/6/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "UIViewController+SFScrollPageController.h"
#import "SFScrollPageViewDelegate.h"
#import <objc/runtime.h>
char SFIndexKey;
@implementation UIViewController (SFScrollPageController)

//@dynamic sf_scrollViewController;

- (UIViewController *)sf_scrollViewController {
    UIViewController *controller = self;
    while (controller) {
        if ([controller conformsToProtocol:@protocol(SFScrollPageViewDelegate)]) {
            break;
        }
        controller = controller.parentViewController;
    }
    return controller;
}

- (void)setSf_currentIndex:(NSInteger)sf_currentIndex {
    objc_setAssociatedObject(self, &SFIndexKey, [NSNumber numberWithInteger:sf_currentIndex], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)sf_currentIndex {
    return [objc_getAssociatedObject(self, &SFIndexKey) integerValue];
}


@end
