//
//  AmendCoordinate.m
//  MLGeolocation
//
//  Created by user on 16/5/9.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "AmendCoordinate.h"

const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;

@implementation AmendCoordinate


#pragma mark -- WGS-84 到 GCJ-02 的转换

+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc
{
    CLLocationCoordinate2D adjustLoc;
    if([self isLocationOutOfChina:wgsLoc]){
        adjustLoc = wgsLoc;
    }else{
        double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 Y:wgsLoc.latitude - 35.0];
        double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 Y:wgsLoc.latitude - 35.0];
        double radLat = wgsLoc.latitude / 180.0 * pi;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
        adjustLoc.latitude = wgsLoc.latitude + adjustLat;
        adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    }
    return adjustLoc;
}

//判断是不是在中国
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location
{
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}

+(double)transformLatWithX:(double)x Y:(double)y
{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

+(double)transformLonWithX:(double)x Y:(double)y
{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

#pragma mark -- GCJ-02 到 BD-09 的转换

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
+ (CLLocationCoordinate2D)transformFromGCJToBD:(CLLocationCoordinate2D)gcLoc
{
    CLLocationCoordinate2D adjustLoc;
    double x = gcLoc.longitude, y = gcLoc.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    adjustLoc.longitude = z * cos(theta) + 0.0065;
    adjustLoc.latitude = z * sin(theta) + 0.006;
    return adjustLoc;
}

#pragma mark -- BD-09 到 GCJ-02 的转换

+(CLLocationCoordinate2D)transformFromBDToGCJ:(CLLocationCoordinate2D)bdLoc
{
    CLLocationCoordinate2D adjustLoc;
    double x = bdLoc.longitude - 0.0065, y = bdLoc.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    adjustLoc.longitude = z* cos(theta);
    adjustLoc.latitude = z* sin (theta);
    return adjustLoc;
}

@end
