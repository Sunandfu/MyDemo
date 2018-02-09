//
//  BLEDeviceInfo.h
//  electronicScale
//
//  Created by 云镶网络科技公司 on 2016/10/11.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;

@interface BLEDeviceInfo : NSObject
//外设
@property (nonatomic,strong) CBPeripheral * peripheral;
//外设的UUID
@property (nonatomic,copy) NSString * UUIDString;
//外设的name
@property (nonatomic,copy) NSString * name;
//外设的信号值
@property (nonatomic,assign) NSInteger RSSI;
//外设的广播包
@property (nonatomic,copy) NSDictionary * advertisementData;

- (BOOL)isEqualToInfo:(BLEDeviceInfo *)info;

@end
