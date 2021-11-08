//
//  QQHelperSettingWindowCtr.m
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/14.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import "QQHelperSettingWindowCtr.h"

@interface QQHelperSettingWindowCtr ()

@end

@implementation QQHelperSettingWindowCtr

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        QQHelperSettingWindow *settingWindow = [[QQHelperSettingWindow alloc] initWithContentRect:NSMakeRect(0, 0,400 , 500) styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable backing:NSBackingStoreBuffered defer:NO];
        [settingWindow center];
        [settingWindow setTitle:@"助手配置"];
        settingWindow.delegate = self;
        self.window = settingWindow;
    }
    return self;
}

- (void)showDefaultWindow {
    if (self.window != nil) {
        [self.window makeKeyAndOrderFront:nil];
    }
}

- (void)windowDidLoad {
    [super windowDidLoad];
    NSLog(@"窗口加载完成 +++++++++++++++++++++++++");
}

@end
