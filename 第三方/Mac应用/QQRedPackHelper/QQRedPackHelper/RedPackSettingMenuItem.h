//
//  RedPackSettingMenuItem.h
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/15.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QQHelperSetting.h"

@interface RedPackSettingMenuItem : NSObject

@property (nonatomic, assign) NSInteger groupSessionId;

+ (instancetype)sharedInstance;

- (NSMenuItem *)redPacSettingItem;

@end
