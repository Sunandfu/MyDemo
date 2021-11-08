//
//  QQHelperSettingWindowCtr.h
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/14.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QQHelperSettingWindow.h"

@interface QQHelperSettingWindowCtr : NSWindowController <NSWindowDelegate>
- (instancetype)init;
- (void)showDefaultWindow;
@end
