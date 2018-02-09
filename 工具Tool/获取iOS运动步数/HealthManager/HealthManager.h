//
//  HealthManager.h
//  wodecehsi
//
//  Created by 小富 on 16/7/29.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface HealthManager : NSObject

@property (nonatomic,strong) HKHealthStore *healthStore;


+(id)shareInstance;

/*!
 *  @author Lcong, 16-07-29 18:04:38
 *
 *  @brief  获取当天实时步数
 *
 *  @param handler 回调
 */
- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 16-07-29 18:04:34
 *
 *  @brief  获取一定时间段步数
 *
 *  @param predicate 时间段
 *  @param handler   回调
 */
- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 16-07-29 18:04:32
 *
 *  @brief  获取卡路里
 *
 *  @param predicate    时间段
 *  @param quantityType 样本类型
 *  @param handler      回调
 */
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 16-07-29 18:04:17
 *
 *  @brief  当天时间段
 *
 *  @return ,,,
 */
+ (NSPredicate *)predicateForSamplesToday;

@end
@import HealthKit;

@interface HKHealthStore (AAPLExtensions)

// Fetches the single most recent quantity of the specified type.
- (void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *results, NSError *error))completion;

@end
/*
 ************************使用举例************************
 //倒入头文件 #import "HealthManager.h"
 
 [[HealthManager shareInstance] getKilocalorieUnit:[HealthManager predicateForSamplesToday] quantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] completionHandler:^(double value, NSError *error) {
 if(error)
 {
 NSLog(@"error = %@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
 }
 else
 {
 NSLog(@"获取到的卡路里 ＝ %.2lf",value);
 }
 }];
 
 [[HealthManager shareInstance] getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
 
 NSLog(@"当天行走步数 = %.0lf",value);
 }];
 */
