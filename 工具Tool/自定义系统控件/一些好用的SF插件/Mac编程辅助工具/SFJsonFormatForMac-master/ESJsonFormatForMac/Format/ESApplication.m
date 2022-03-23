//
//  ESApplication.m
//  ESJsonFormatForMac
//
//  Created by lurich on 2021/12/23.
//  Copyright © 2021 ZX. All rights reserved.
//

#import "ESApplication.h"

@implementation ESApplication
- (IBAction)preferencesClick:(id)sender {
    self.settingCtrl = [[ESSettingController alloc] initWithWindowNibName:@"ESSettingController"];
    [self.settingCtrl showWindow:self.settingCtrl];
}

@end
