//
//  WSGetWifi.h
//  GetIP
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSGetWifi : NSObject

+(NSString *)getWiFiIPAddress;
//获取当前wifi名称
+(id)getSSIDInfo;

@end
