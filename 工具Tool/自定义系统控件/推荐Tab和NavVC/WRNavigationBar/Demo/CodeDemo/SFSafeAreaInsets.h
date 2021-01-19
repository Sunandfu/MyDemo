//
//  SFSafeAreaInsets.h
//  Novel
//
//  Created by xx on 2018/9/5.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UtilsMacro.h"

@interface SFSafeAreaInsets : NSObject

+ (instancetype)shareInstance;

@property (nonatomic) UIEdgeInsets safeAreaInsets;

@end
