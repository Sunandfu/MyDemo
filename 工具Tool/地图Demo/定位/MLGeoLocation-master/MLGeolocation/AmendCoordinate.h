//
//  AmendCoordinate.h
//  MLGeolocation
//
//  Created by user on 16/5/9.
//  Copyright © 2016年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AmendCoordinate : NSObject

/**
 WGS-84 地球坐标系，即iOS系统坐标系
 GCJ-02 火星坐标系，即google地图坐标系
 BD-09 百度地图坐标系
 */

/**
 WGS-84转GCJ-02
 */
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

/**
 GCJ-02转BD-09
 */
+ (CLLocationCoordinate2D)transformFromGCJToBD:(CLLocationCoordinate2D)gcLoc;

/**
 BD-09转GCJ-02
 */
+(CLLocationCoordinate2D)transformFromBDToGCJ:(CLLocationCoordinate2D)bdLoc;

/**
 判断是否已超过中国范围
 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;


@end
