//
//  BLEDeviceInfo.m
//  electronicScale
//
//  Created by 云镶网络科技公司 on 2016/10/11.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import "SFBLEDeviceInfo.h"

@implementation SFBLEDeviceInfo

- (BOOL)isEqualToInfo:(SFBLEDeviceInfo *)info
{
    return [self.UUIDString isEqualToString:info.UUIDString];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@----UUID:%@",self.name,self.UUIDString];
}

@end
