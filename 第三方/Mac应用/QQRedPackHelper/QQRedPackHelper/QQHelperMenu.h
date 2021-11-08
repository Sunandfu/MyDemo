//
//  QQHelperMenu.h
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/2.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "QQHelperSetting.h"
#import "TKQQPluginConfig.h"
#import "TKAutoReplyWindowController.h"
#import "QQHelperSettingWindowCtr.h"

@interface QQHelperMenu : NSObject
+ (instancetype)sharedInstance;
- (void)addMenu;
@end
