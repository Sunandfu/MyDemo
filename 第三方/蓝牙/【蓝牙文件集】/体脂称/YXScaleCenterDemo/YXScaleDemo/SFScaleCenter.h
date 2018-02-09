//
//  SFScaleCenter.h
//  YXScaleDemo
//
//  Created by 小富 on 2017/8/2.
//  Copyright © 2017年 xiaofu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "YXScaleInfo.h"
#import "BLEDeviceInfo.h"

#pragma mark - 体脂秤

extern NSString * _Nonnull const YXBLEScaleName;

extern NSString * _Nonnull const YXScaleService;

extern NSString * _Nonnull const YXScaleFFF1;

extern NSString * _Nonnull const YXScaleFFF4;

@protocol BLEManagerDelegate <NSObject>

#pragma mark - Central

@optional


/**
 蓝牙开
 */
- (void)BLEPoweredOn;

/**
 蓝牙关
 */
- (void)BLEPoweredOff;

/**
 搜索到设备
 */
- (void)BLEDiscoverDevices;

/**
 连接秤成功
 */
- (void)BLEDidConnectScale:(nonnull CBPeripheral *)peripheral;

/**
 连接外设失败
 
 @param peripheral 外设
 */
- (void)BLEDidFailToConnectPeripheral:(nonnull CBPeripheral *)peripheral;

/**
 断开外设成功
 
 @param peripheral 外设
 */
- (void)BLEDidDisconnectPeripheral:(nonnull CBPeripheral *)peripheral;

#pragma mark - Peripheral

/**
 外设的特征值的值更新
 
 @param peripheral     外设
 @param value          特征值的值
 @param characteristic 特征值
 */
- (void)peripheral:(nonnull CBPeripheral *)peripheral didUpdateValue:(nullable NSString *)value forCharacteristic:(nonnull CBCharacteristic *)characteristic;

#pragma mark - Scale

/**
 秤的数据更新
 
 @param scale 秤
 @param info  数据
 */
- (void)scale:(nonnull CBPeripheral *)scale didUpdateScaleInfo:(nullable YXScaleInfo *)info;

@end

@interface SFScaleCenter : NSObject

/**
 代理人属性
 */
@property (nonatomic,weak,nullable) id<BLEManagerDelegate> delegate;

/**
 设备数组 每次搜索都会重置
 */
@property (nonatomic,strong,nullable) NSMutableArray * deviceArray;

/**
 蓝牙开关
 */
@property (nonatomic,assign,readonly) BOOL bleOpen;
/**
 是否连接
 */
@property (nonatomic,assign,readonly) BOOL bleConnect;

/**
 当前连接的秤
 */
@property (nonatomic,strong,nullable) CBPeripheral * scale;

+ (nonnull instancetype)shareManager;

#pragma mark - Method

/**
 搜索设备

 @param height 身高
 @param weight 体重
 @param sex  性别 1 男 0 女
 */
- (void)scanScaleWithHeight:(CGFloat)height Weight:(CGFloat)weight Sex:(NSInteger)sex;

/**
 停止搜索
 */
- (void)stopScan;

/**
 连接外设
 
 @param peripheral 外设
 */
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral;

/**
 断开连接
 
 @param peripheral 外设
 */
- (void)disconnectPeripheral:(nonnull CBPeripheral *)peripheral;

#pragma mark - Scale

- (void)writeScaleStr:(nonnull NSString *)scaleStr toScale:(nonnull CBPeripheral *)scale;

/**
 获取体脂称数据
 */
- (void)getWeightData;

/**
 关闭秤
 */
- (void)turnOffScale;


@end
