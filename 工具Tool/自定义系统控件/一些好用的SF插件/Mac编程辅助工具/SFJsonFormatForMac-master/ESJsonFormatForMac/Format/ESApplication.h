//
//  ESApplication.h
//  ESJsonFormatForMac
//
//  Created by lurich on 2021/12/23.
//  Copyright © 2021 ZX. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ESSettingController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESApplication : NSApplication

@property (nonatomic, strong) ESSettingController *settingCtrl;

@end

NS_ASSUME_NONNULL_END
