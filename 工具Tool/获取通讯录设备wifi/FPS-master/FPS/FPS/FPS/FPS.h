//
//  FPS.h
//  FPS
//
//  Created by iMac on 17/1/22.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FPSIndicatorPosition) {
    FPSIndicatorPositionNormal = 0,      // 默认, 位置在屏幕左下角
    FPSIndicatorPositionStatusBar = 1    // 位置在状态栏时间显示右侧
};

@interface FPS : NSObject

+ (FPS *)sharedInstance;

/** 开始监控并显示当前 fps 值 */
- (void)start;

/** 停止监控并隐藏 fps 值 */
- (void)stop;

/** FPS 指示器位置 默认为:AYYFPSIndicatorPositionNormal */
@property (nonatomic, assign) FPSIndicatorPosition indicatorPosition;

@end