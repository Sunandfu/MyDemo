//
//  AppDelegate.m
//  SFCodeObfuscation
//
//  Created by SF on 2018/8/16.
//  Copyright © 2018年 Lurich All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    if (!flag) {
        [[sender.windows firstObject] makeKeyAndOrderFront:self];
    }
    return YES;
}

@end
