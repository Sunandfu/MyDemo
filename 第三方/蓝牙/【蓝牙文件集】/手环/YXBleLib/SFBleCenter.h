//
//  BLEManager.h
//  electronicScale
//
//  Created by 云镶网络科技公司 on 2016/10/11.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SFRunItem.h"
#import "SFBLEDeviceInfo.h"

#pragma mark - 手环
extern NSString * _Nonnull const YXBLEBraceletName;
extern NSString * _Nonnull const YXBraceletBatteryService;
extern NSString * _Nonnull const YXBraceletBattery;

extern NSString * _Nonnull const YXBraceletService;
extern NSString * _Nonnull const YXBraceletFFF1;
extern NSString * _Nonnull const YXBraceletFFF2;
extern NSString * _Nonnull const YXBraceletFFF3;
extern NSString * _Nonnull const YXBraceletFFF4;

@protocol SFBleCenterDelegate <NSObject>

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
 连接手环成功
 */
- (void)BLEDidConnectBraceletToConnectPeripheral:(nonnull CBPeripheral *)peripheral;

/**
 返回的设备数组
 */
- (void)BLEDiscoverDevices:(NSArray <SFBLEDeviceInfo *>*_Nullable)devices;

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
 未转化的外设的特征值
 
 @param peripheral     外设
 @param value          特征值的值
 @param characteristic 特征值
 */
- (void)peripheral:(nonnull CBPeripheral *)peripheral didUpdateValue:(nullable NSString *)value forCharacteristic:(nonnull CBCharacteristic *)characteristic;

/**
 已转化的外设的特征值
 
 @param peripheral     外设
 @param dicValue 特征值
 */
- (void)peripheral:(nonnull CBPeripheral *)peripheral didUpdateValue:(nullable NSDictionary *)dicValue;
/**
 跑步心率数据
 
 @param bracelet 手环
 @param runItem  跑步心率
 */
- (void)bracelet:(nonnull CBPeripheral *)bracelet didUpdateRunItem:(nonnull SFRunItem *)runItem;

/**
 睡眠数据
 
 @param peripheral     外设
 @param sleepArray 特征值
 */
- (void)peripheral:(nonnull CBPeripheral *)peripheral didUpdateSleepValue:(nullable NSArray *)sleepArray;

@end

@interface SFBleCenter : NSObject

/**
 代理人属性
 */
@property (nonatomic,weak,nullable) id<SFBleCenterDelegate> delegate;

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
 当前连接的手环
 */
@property (nonatomic,strong,nullable) CBPeripheral * currentBracelet;

+ (nonnull instancetype)shareManager;


#pragma mark - Method

/**
 搜索设备
 */
- (void)startScan;

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

/**
 写入数据到手环
 
 @param value                 16进制数的字符串
 @param characteristicUUIDStr 特征值的UUID
 @param bracelet              手环
 */
- (void)writeValue:(nonnull NSString *)value forCharacteristicUUIDStr:(nonnull NSString *)characteristicUUIDStr toBracelet:(nonnull CBPeripheral *)bracelet;

/**
 
 hexStr --> data
 
 @param hexString 16进制字符串
 
 @return data
 */
- (nullable NSData *)dataFromHexString:(nonnull NSString *)hexString;

/**
 data --> hexStr
 
 @param data data
 
 @return 16进制字符串
 */
- (nonnull NSString *)hexStringFromData:(nonnull NSData *)data;


#pragma mark - BraceletCode

/**
 获取当前步数  key=01
 */
- (void)getCurrentStep;
/**
 设置手环的时间  key=02
 */
- (void)setBraceletTime;
/**
 读取手环的电量  key=03
 */
- (void)readBraceletBattery;
/**
  同步运动（跑步心率）数据  key=04
 */
- (void)syncSportData;

/**
 同步个人信息和闹钟 数据  key=05

 @param heightStr 身高
 @param weightStr 体重
 @param sendAlarmCodeArr 闹钟指令数组
 */
- (void)syncPersonInfoWithHight:(NSString *_Nullable)heightStr AndWeight:(NSString *_Nullable)weightStr AndSendCodeArr:(NSArray <NSString *> *_Nullable)sendAlarmCodeArr;
//开启ANCS  key=06
- (void)openANCS;
//关闭ANCS  key=07
- (void)closeANCS;
//开启心率监测  key=08
- (void)openHeartRateExamine;
//关闭心率监测  key=09
- (void)closeHeartRateExamine;

/**
 开启闹钟提醒  key=05
 @param time 闹钟时间  如: 08:00
 @param weekNumStr 星期时间  如: '周一' 则传入 ”1“
 */
- (void)openAlarmClockWithTime:(NSString *_Nullable)time AndWeek:(NSString *_Nullable)weekNumStr;

/**
 关闭闹钟提醒  key=05
 @param time 闹钟时间  如: 08:00
 @param weekNumStr 星期时间  如: '周一' 则传入 ”1“
 */
- (void)closeAlarmClockWithTime:(NSString *_Nullable)time AndWeek:(NSString *_Nullable)weekNumStr;

/**
 开启久坐提醒  key=12
 @param number 久坐时间  如: 45
 */
- (void)openLongSitWithTime:(NSString *_Nullable)number;

/**
 关闭久坐提醒  key=12
 @param number 久坐时间  如: 45
 */
- (void)closeLongSitWithTime:(NSString *_Nullable)number;
/**
 开启抬腕亮屏  key=14
 @param startTime 开始时间  如: 08
 @param endTime   结束时间  如: 22
 */
- (void)openLiftWristScreenWithTime:(NSString *_Nullable)startTime AndEndTime:(NSString *_Nullable)endTime;

/**
 关闭抬腕亮屏  key=15
 */
- (void)closeLiftWristScreen;
//打开相机拍照  key=16
- (void)OpenCameraPhotograph;
//获取手环版本  key=17
- (void)GetBraceletVersion;

/**
 获取当天心率  key=18

 @param dateStr 某天的日期  日期格式必须为"yyyy-MM-dd" 如：2017-01-01  若传nil  则默认当天
 */
- (void)GetHeartRateWithDate:(NSString *_Nullable)dateStr;

/**
 同步运动与睡眠数据  睡眠：key=19   运动：key=20

 @param dateStr 某天的日期  日期格式必须为"yyyy-MM-dd" 如：2017-01-01 若传nil  则默认昨晚睡眠
 */
- (void)SynchronizeSportAndSleepDataWithDate:(NSString *_Nullable)dateStr;
//  key = 21   通过手环找手机功能

@end
