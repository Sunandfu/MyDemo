//
//  MLGeolocation.m
//  BaseProject
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 jdrx. All rights reserved.
//

#import "MLGeolocation.h"
#import "AFNetworking.h"
#import "AmendCoordinate.h"
#import <CoreLocation/CoreLocation.h>

@interface MLGeolocation() <CLLocationManagerDelegate>
{
    
    CLLocationManager * locationManager;
    
    void (^sucBlock)(NSDictionary *loc);
    void (^errorBlock)(NSError *error);
    //判断是否需要IP定位
    BOOL isIP;
    
    NSString *IP;
    NSString *AK;
}

@end

@implementation MLGeolocation

static MLGeolocation *geo;
+ (MLGeolocation *)geolocation{
    static MLGeolocation *geo = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        geo = [[MLGeolocation alloc]init];
    });
    return geo;
}

- (void)setIPAddress:(NSString *)ip withAK:(NSString *)ak{
    if (ip != nil && ak != nil) {
        IP = ip;
        AK = ak;
    }
}

//定位
- (void)getCurrentLocations:(void(^)(NSDictionary *curLoc))success isIPOrientation:(BOOL)orientation error:(void(^)(NSError  *error))errors
{

    isIP = orientation;
    locationManager = [[CLLocationManager alloc]init];
    //定位精度(默认最好)
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if (self.distance ) {
        locationManager.desiredAccuracy = [self getDesiredAccuracy];
    }
    //定位更新频率(默认距离最大)
    [locationManager setDistanceFilter:CLLocationDistanceMax];
    if (self.distanceFilter) {
        [locationManager setDistanceFilter:self.distanceFilter];
    }
    
    //必须添加此判断，否则在iOS7上会crash
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
#ifdef __IPHONE_8_0
        [locationManager requestWhenInUseAuthorization];
#endif
    }
    locationManager.delegate = self;
    
    //成功
    sucBlock = ^(NSDictionary *locDic){
        success(locDic);
    };
    //失败
    errorBlock = ^(NSError *error){
        errors(error);
    };
    
    [locationManager startUpdatingLocation];//开启定位
}

- (CLLocationAccuracy)getDesiredAccuracy{
    CLLocationAccuracy distanceAccuracy;
    switch (self.distance) {
        case MLLocationAccuracyBest:
            distanceAccuracy = kCLLocationAccuracyBest;
            break;
        case MLLocationAccuracyHundredMeters:
            distanceAccuracy = kCLLocationAccuracyHundredMeters;
            break;
        case MLLocationAccuracyKilometer:
            distanceAccuracy = kCLLocationAccuracyKilometer;
            break;
        case MLLocationAccuracyThreeKilometers:
            distanceAccuracy = kCLLocationAccuracyThreeKilometers;
            break;
        case MLLocationAccuracyNearestTenMeters:
            distanceAccuracy = kCLLocationAccuracyNearestTenMeters;
            break;
        default:
            break;
    }
    return distanceAccuracy;
}


//定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currLocation = [[CLLocation alloc]initWithLatitude:((CLLocation *)[locations firstObject]).coordinate.latitude longitude:((CLLocation *)[locations firstObject]).coordinate.longitude];
    
    if (![AmendCoordinate isLocationOutOfChina:[currLocation coordinate]]) {
        //坐标校准(根据自己所用地图而定)
        CLLocationCoordinate2D coord_gcj = [AmendCoordinate transformFromWGSToGCJ:[currLocation coordinate]];
        CLLocationCoordinate2D coord_bd9 = [AmendCoordinate transformFromGCJToBD:coord_gcj];
        
        NSDictionary *locDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",coord_bd9.latitude], @"lat", [NSString stringWithFormat:@"%f",coord_bd9.longitude], @"long", nil];
        sucBlock(locDic);
    }else {
        NSDictionary *locDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",currLocation.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%f",currLocation.coordinate.longitude], @"long", nil];
        sucBlock(locDic);
    }
}

//关闭定位
- (void)stopUpdatingLocation{
    [locationManager stopUpdatingLocation];
}

//定位失败，回调此方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (isIP) {
        [self getLocations:^(NSDictionary *locDic) {
            sucBlock(locDic);
        } withIPAdress:@"" error:^(NSError *error) {
            errorBlock(error);
        }];
    }else {
        errorBlock(error);
        if ([error code]==kCLErrorDenied) {
            NSLog(@"访问被拒绝");
        }
        if ([error code]==kCLErrorLocationUnknown) {
            NSLog(@"无法获取位置信息");
        }
    }
}

//根据ip地址获取坐标
- (void)getLocations:(void(^)(NSDictionary *locDic))successLoc withIPAdress:(NSString *)ipAdr error:(void(^)(NSError *error))errorLoc
{
    if (![ipAdr isEqualToString:IP]) {
        IP = ipAdr;
    }
    if (AK.length > 0) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *paremdic = [@{@"ip":IP,
                                       @"ak":AK,
                                       @"coor":@"bd09ll"
                                       }mutableCopy];
    [manager GET:@"http://api.map.baidu.com/location/ip" parameters:paremdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:kNilOptions error:nil];
        NSDictionary *locDic = [NSDictionary dictionaryWithObjectsAndKeys:[[[appData  objectForKey:@"content"]objectForKey:@"point"] objectForKey:@"y"],@"lat",[[[appData objectForKey:@"content"]objectForKey:@"point"] objectForKey:@"x"],@"long", nil];
        successLoc(locDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorLoc(error);
    }];
    }else {
        NSLog(@"获取位置信息失败");
    }
}

#pragma mark <获取坐标位置>

//逆编码获取当前坐标信息
- (void)getCurrentAddress:(void(^)(NSMutableDictionary *citys))address error:(void(^)(NSError *error))locError{
    //通过数据源拿到当前位置
    __weak typeof(self)weak_self = self;
    [self getCurrentLocations:^(NSDictionary *curLoc) {
        [weak_self getLocAddress:[curLoc objectForKey:@"lat"] withLon:[curLoc objectForKey:@"long"] address:^(NSMutableDictionary *citys) {
            address(citys);
            [self stopUpdatingLocation];
        } error:^(NSError *error) {
            locError(error);
            [self stopUpdatingLocation];
        }];
    } isIPOrientation:NO error:^(NSError *error) {
        locError(error);
    }];
}

//逆编码获取坐标信息
- (void)getLocAddress:(NSString *)lat withLon:(NSString *)lon address:(void(^)(NSMutableDictionary *citys))address error:(void(^)(NSError *error))getFail{
    //使用地理位置 逆向编码拿到位置信息
    if (lat != nil && lon != nil) {
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        CLLocation * currentLoc = [[CLLocation alloc]initWithLatitude:[lat floatValue] longitude:[lon floatValue]];
        [geocoder reverseGeocodeLocation:currentLoc completionHandler:^(NSArray *placemarks, NSError *error) {
            //逆编码完毕以后调用此block
            if (!error) {
                CLPlacemark * placeMark = placemarks[0];
                NSMutableDictionary *locDicationary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:lat,@"lat", lon, @"long",placeMark.country,@"country", [placeMark.addressDictionary objectForKey:@"State"],@"State",placeMark.locality,@"city",placeMark.subLocality,@"subLocality",placeMark.thoroughfare,@"thoroughfare",placeMark.name,@"street",nil];
                address(locDicationary);
                //获取当前地址城市名
            }else{
                NSLog(@"逆编码失败");
            }}];
    }
}

#pragma mark <获取位置坐标>

//获取位置坐标
- (void)getCurrentCor:(NSString *)locName  block:(void(^)(CGFloat corLat,CGFloat corLon))coorDic error:(void(^)(NSError *error))fail{
    [self getLoc:locName success:^(CGFloat lat, CGFloat lon) {
        coorDic(lat, lon);
    }fail:^(NSError *error) {
        fail(error);
    }];
}

//逆编码获取位置坐标
- (void)getLoc:(NSString *)address  success:(void (^)(CGFloat lat, CGFloat lon))coordinate fail:(void(^)(NSError *error))fail {
    //使用地理位置 逆向编码拿到位置信息
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    //逆编码当前位置
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark * placeMark = placemarks[0];
            coordinate(placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);
        }else {
            fail(error);
        }}];
}

@end
