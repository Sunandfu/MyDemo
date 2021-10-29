//
//  AppDelegate.m
//  ESJsonFormatForMac
//
//  Created by ZX on 2017/5/12. 
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "AppDelegate.h"
#import "ESInputJsonController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.inputJsonController = [[ESInputJsonController alloc] initWithNibName:@"ESInputJsonController" bundle:[NSBundle bundleForClass:[self class]]];
    [self.window.contentView addSubview:self.inputJsonController.view];
    self.inputJsonController.view.frame = self.window.contentView.bounds;
    
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    if (!flag) {
        [self.window makeKeyAndOrderFront:self];
    }
    return YES;
}


@end
