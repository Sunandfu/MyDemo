//
//  SynchronizeDervice.h
//  fitness
//
//  Created by 小富 on 2016/11/28.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral,CBCharacteristic;

@protocol SynchronizeDelegate <NSObject>

@optional
-(void)synchronizeHeartRateDoneWithArray:(NSArray *)HeartRateArray;
-(void)synchronizeSportDataDoneWithArray:(NSArray *)SportDataArray;
-(void)synchronizeSleepDataDoneWithArray:(NSArray *)SleepDataArray;

@end

@interface SynchronizeDervice : NSObject

@property (nonatomic, copy) NSString *heartLongStr;
@property (nonatomic, strong) NSMutableArray *HeartRateArray;

@property (nonatomic, copy) NSString *orignalData;
@property (nonatomic, strong) NSMutableArray *SportDataArray;
@property (nonatomic, strong) NSMutableArray *SleepDataArray;

@property (nonatomic, strong) NSMutableArray *synCmdArray;
@property (nonatomic, strong) NSMutableArray *sleepOrigArray;
@property (nonatomic, strong) NSMutableArray *updateSleepData;
@property (nonatomic, copy) NSString *latestTime;
@property (nonatomic, copy) NSString *signTime;

@property (nonatomic, assign) id <SynchronizeDelegate> delegate;


- (instancetype)initWith:(CBPeripheral*)pheripheral;

-(void) syncSleepAndSportWithDateStr:(NSString *)datestr;

-(void) handleSleepAndSportData:(NSString *) value;//同步睡眠与运动数据
- (void)upDateHeartRateForCharacteristic:(NSString *)value;//同步24小时心率数据

@end
