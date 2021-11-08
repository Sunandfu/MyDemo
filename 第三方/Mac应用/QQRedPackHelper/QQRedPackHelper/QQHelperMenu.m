//
//  QQHelperMenu.m
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/2.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import "QQHelperMenu.h"

static char tkAutoReplyWindowControllerKey;         //  自动回复窗口的关联 key

@implementation QQHelperMenu {
    QQHelperSettingWindowCtr *settingWc;
    TKAutoReplyWindowController *autoReplyWc;
}

static QQHelperMenu *instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)addMenu {
    //获取主目录
    NSMenu *mainMenu = [NSApp mainMenu];
    NSLog(@"%@ - %@",mainMenu,[mainMenu itemArray]);
    
    //添加一级目录
    NSMenuItem *oneItem = [[NSMenuItem alloc] init];
    [oneItem setTitle:@"QQ助手"];
    [mainMenu addItem:oneItem];
    
    //添加二级目录项
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@"QQ助手"];
    {
        NSMenuItem *redPackItem = [[NSMenuItem alloc] initWithTitle:@"自动抢红包" action:@selector(grabbingRedPacketsAction:) keyEquivalent:@"A"];
        if ([[QQHelperSetting sharedInstance] isEnableRedPacket]) {
            [redPackItem setState:NSControlStateValueOn];
        } else {
            [redPackItem setState:NSControlStateValueOff];
        }
        [redPackItem setTarget:self];
        [subMenu addItem:redPackItem];
    }
    
    {
        NSMenuItem *separatorItem1 = [NSMenuItem separatorItem];
        [subMenu addItem:separatorItem1];
    }
    
    {
        NSMenuItem *revokeMessageItem = [[NSMenuItem alloc] initWithTitle:@"消息防撤回" action:@selector(revokeMessageAction:) keyEquivalent:@"R"];
        if ([[QQHelperSetting sharedInstance] isMessageRevoke]) {
            [revokeMessageItem setState:NSControlStateValueOn];
        } else {
            [revokeMessageItem setState:NSControlStateValueOff];
        }
        [revokeMessageItem setTarget:self];
        [subMenu addItem:revokeMessageItem];
    }
    
    {
        NSMenuItem *separatorItem2 = [NSMenuItem separatorItem];
        [subMenu addItem:separatorItem2];
    }
    
    {
        NSMenuItem *hideRedPacWindowItem = [[NSMenuItem alloc] initWithTitle:@"隐藏红包弹框" action:@selector(hideRedPacWindowNoUIAction:) keyEquivalent:@"L"];
        
        if ([[QQHelperSetting sharedInstance] isMessageRevoke]) {
            [hideRedPacWindowItem setState:NSControlStateValueOn];
        } else {
            [hideRedPacWindowItem setState:NSControlStateValueOff];
        }
        [hideRedPacWindowItem setTarget:self];
        [subMenu addItem:hideRedPacWindowItem];
    }
    
    {
        NSMenuItem *separatorItem3 = [NSMenuItem separatorItem];
        [subMenu addItem:separatorItem3];
    }
    
    
    {
        NSMenuItem *autoReplyWindowItem = [[NSMenuItem alloc] initWithTitle:@"自动回复选项" action:@selector(messageAutoReplyWindowNoUIAction:) keyEquivalent:@"K"];
        [autoReplyWindowItem setTarget:self];
        [subMenu addItem:autoReplyWindowItem];
    }
    
    {
        NSMenuItem *separatorItem3 = [NSMenuItem separatorItem];
        [subMenu addItem:separatorItem3];
    }
    
    
    {
        NSMenuItem *settingWindowItem = [[NSMenuItem alloc] initWithTitle:@"红包设置选项" action:@selector(settingWindowNoUIAction:) keyEquivalent:@"P"];
        [settingWindowItem setTarget:self];
        [subMenu addItem:settingWindowItem];
    }
    
    [oneItem setSubmenu:subMenu];
    //更新
    [NSApp setMainMenu:mainMenu];
}

// 自动抢红包方式
- (void)grabbingRedPacketsAction:(NSMenuItem *)menuItem {
    NSLog(@"grabbingRedPacketsAction1 %@",menuItem);
    if ([[QQHelperSetting sharedInstance] isEnableRedPacket]) {
        [menuItem setState:NSControlStateValueOff];
        [[QQHelperSetting sharedInstance] setIsEnableRedPacket:NO];
    } else {
        [menuItem setState:NSControlStateValueOn];
        [[QQHelperSetting sharedInstance] setIsEnableRedPacket:YES];
    }
}

// 自动隐藏红包弹框
- (void)hideRedPacWindowNoUIAction:(NSMenuItem *)menuItem {
    NSLog(@"hideRedPacWindowNoUIAction");
    if ([[QQHelperSetting sharedInstance] isHideRedDetailWindow]) {
        [menuItem setState:NSControlStateValueOff];
        [[QQHelperSetting sharedInstance] setIsHideRedDetailWindow:NO];
    } else {
        [menuItem setState:NSControlStateValueOn];
        [[QQHelperSetting sharedInstance] setIsHideRedDetailWindow:YES];
    }
}

// 消息防撤回
- (void)revokeMessageAction:(NSMenuItem *)menuItem {
    NSLog(@"revokeMessageAction");
    if ([[QQHelperSetting sharedInstance] isMessageRevoke]) {
        [menuItem setState:NSControlStateValueOff];
        [[QQHelperSetting sharedInstance] setIsMessageRevoke:NO];
    } else {
        [menuItem setState:NSControlStateValueOn];
        [[QQHelperSetting sharedInstance] setIsMessageRevoke:YES];
    }
}

// 消息自动回复
- (void)messageAutoReplyWindowNoUIAction:(NSMenuItem *)menuItem {
    NSLog(@"messageAutoReplyWindowNoUIAction");
    if (!autoReplyWc) {
        autoReplyWc = [[TKAutoReplyWindowController alloc] init];
    }
    [autoReplyWc showWindow:autoReplyWc];
    [autoReplyWc.window center];
    [autoReplyWc.window makeKeyWindow];
}

// 助手设置选项
- (void)settingWindowNoUIAction:(NSMenuItem *)menuItem {
    NSLog(@"settingWindowNoUIAction");
    settingWc = [[QQHelperSettingWindowCtr alloc] init];
    [settingWc showDefaultWindow];
}

@end
