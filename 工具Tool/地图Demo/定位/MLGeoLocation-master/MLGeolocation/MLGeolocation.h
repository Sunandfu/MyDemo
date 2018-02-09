//
//  MLGeolocation.h
//  BaseProject
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 jdrx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MLGeolocation : NSObject

typedef NS_ENUM(NSInteger, MLLocationDistance) {
    MLLocationAccuracyBest = 0,
    MLLocationAccuracyNearestTenMeters,
    MLLocationAccuracyHundredMeters,
    MLLocationAccuracyKilometer,
    MLLocationAccuracyThreeKilometers
};

///默认精度最好
@property (nonatomic, assign)MLLocationDistance distance;
///默认最大距离更新坐标
@property (nonatomic, assign)CGFloat distanceFilter;

/**
 获取地理位置类
 */
+ (MLGeolocation *)geolocation;

/**
 开启IP定位前必须传入百度AK,IP若为空则自动获取当前网络IP地址
 */
- (void)setIPAddress:(NSString *)ip withAK:(NSString *)ak;

/**
 GPS定位获取当前位置，若失败可调用IP定位获取位置，位置字典key为lat(纬度)和long(经度);
 */
- (void)getCurrentLocations:(void(^)(NSDictionary *curLoc))success isIPOrientation:(BOOL)orientation  error:(void(^)(NSError  *error))errors;

/**
 根据IP地址获取位置，ip地址为空则自动获取当前网络IP地址
 */
- (void)getLocations:(void(^)(NSDictionary *locDic))successLoc withIPAdress:(NSString *)ipAdr error:(void(^)(NSError *error))errorLoc;

/**
 获取当前坐标点的位置信息，字典包含lat(纬度)，long(经度)， country(国家)，State(省)，city(城市)，subLocality(城区)，thoroughfare(大道)，street(街道)
 */
- (void)getCurrentAddress:(void(^)(NSMutableDictionary *citys))address error:(void(^)(NSError *error))locError;


/**
 获取坐标点的位置信息，字典包含lat(纬度)，long(经度)， country(国家)，State(省)，city(城市)，subLocality(城区)，thoroughfare(大道)，street(街道)
 */
- (void)getLocAddress:(NSString *)lat withLon:(NSString *)lon address:(void(^)(NSMutableDictionary *citys))address error:(void(^)(NSError *error))getFail;

/**
 获取当前地点的具体坐标
 */
- (void)getCurrentCor:(NSString *)locName  block:(void(^)(CGFloat corLat,CGFloat corLon))coorDic error:(void(^)(NSError *error))fail;

/**
 停止定位
 */
- (void)stopUpdatingLocation;

@end
