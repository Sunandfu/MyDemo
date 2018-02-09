//
//  CLLocation+XYLocationExtensions.m
//  WeChatExtensions
//
//  Created by Swae on 2017/10/28.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "CLLocation+XYLocationExtensions.h"
#import <objc/runtime.h>
#import "WBRedEnvelopConfig.h"

#pragma mark *** 用于修改微信内部经纬度的分类 ***

@implementation CLLocation (XYLocationExtensions)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalSelector = @selector(coordinate);
        SEL swizzledSelector = @selector(xy_coordinate);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
            
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (CLLocationCoordinate2D)xy_coordinate {
    
    CLLocationCoordinate2D oldCoordinate = [self xy_coordinate];
    BOOL shouldChangeCoordinate = [[WBRedEnvelopConfig sharedConfig] shouldChangeCoordinate];
    BOOL useOriginalCordinate = [WBRedEnvelopConfig sharedConfig].useOriginalCordinate;
    if (!shouldChangeCoordinate || useOriginalCordinate) {
        if (useOriginalCordinate) {
            [WBRedEnvelopConfig sharedConfig].useOriginalCordinate = NO;
        }
        return oldCoordinate;
    }
    
    double longitude = [[WBRedEnvelopConfig sharedConfig] longitude];
    double latitude = [[WBRedEnvelopConfig sharedConfig] latitude];
    if (latitude <= 0.0 || latitude <= 0.0) {
        return oldCoordinate;
    }
    
    oldCoordinate.latitude = latitude;
    oldCoordinate.longitude = longitude;
    
    return oldCoordinate;
    
}

- (CLLocationCoordinate2D)xy_originalCoordinate {
    [WBRedEnvelopConfig sharedConfig].useOriginalCordinate = YES;
    return [self xy_coordinate];
}

@end

