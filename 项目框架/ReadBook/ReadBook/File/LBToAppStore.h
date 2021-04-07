//
//  LBToAppStore.h
//  LBToAppStore
//
//  Created by gold on 16/5/3.
//  Copyright © 2016年 Bison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LBToAppStore : NSObject<UIAlertViewDelegate>

- (void)showGotoAppStore:(UIViewController *)VC;
- (void)showAlwaysGotoAppStore:(UIViewController *)VC;

@end
