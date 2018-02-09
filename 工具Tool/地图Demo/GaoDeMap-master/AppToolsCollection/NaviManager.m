//
//  NaviManager.m
//  khqyKhqyIphone
//
//  Created by 林英伟 on 15/11/1.
//
//

#import "NaviManager.h"

@implementation NaviManager
+ (instancetype)sharedManager
{
    static NaviManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NaviManager alloc] init];
    });
    
    return sharedManager;
}

@end
