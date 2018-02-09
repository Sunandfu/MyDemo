//
//  HBUserDefaults.m
//  HuiBeauty
//
//  Created by darren on 14-9-10.
//  Copyright (c) 2014年 BrooksWon. All rights reserved.
//

#import "HBUserDefaults.h"

@implementation HBUserDefaults


@dynamic userPhoneNum;
@dynamic passWord;
@dynamic isLogin;
@dynamic cityName;

- (id)init
{
    if (self = [super init]) {
        NSDictionary *registrationDictionary = @{
                                                 @"userPhoneNum":@"",
                                                 @"passWord":@"",
                                                 @"isLogin":@0,
                                                 @"cityName":@"",
                                                 };
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:registrationDictionary];
    }
    
    return self;
}

@end
