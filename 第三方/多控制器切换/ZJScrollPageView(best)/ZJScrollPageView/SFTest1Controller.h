//
//  SFTest1Controller.h
//  SFScrollPageView
//
//  Created by ZeroJ on 16/6/30.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFScrollPageViewDelegate.h"
@interface SFTest1Controller : UIViewController <SFScrollPageViewChildVcDelegate>
@property (copy, nonatomic) void(^click)();
@end
