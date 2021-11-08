//
//  RedPackSettingMenuItem.m
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/15.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import "RedPackSettingMenuItem.h"

@implementation RedPackSettingMenuItem

static RedPackSettingMenuItem *instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSMenuItem *)redPacSettingItem {
    NSMenuItem *redPacItem = [[NSMenuItem alloc] initWithTitle:@"群禁止抢红包" action:@selector(openRedPackSettingAction) keyEquivalent:@""];
    [redPacItem setTarget:self];
    return redPacItem;
}

- (void)openRedPackSettingAction {
    QQHelperSetting *helper = [QQHelperSetting sharedInstance];
    NSArray *tempSessionIds = [helper sessionIds];
    if (tempSessionIds != nil) {
        NSMutableArray *tArray = [NSMutableArray arrayWithArray:tempSessionIds];
        if ([helper groupSessionIdContainer:self.groupSessionId]) {
            // 移除
            [tArray removeObject:[NSNumber numberWithInteger:self.groupSessionId]];
        } else {
            // 添加
            [tArray addObject:[NSNumber numberWithInteger:self.groupSessionId]];
        }
        
        
        [helper setSessionIds:tArray];
    } else {
        [helper setSessionIds:@[[NSNumber numberWithInteger:self.groupSessionId]]];
    }
}

@end
