//
//  BaiduMapTools.m
//  baidumapTest
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 tqh. All rights reserved.
//

#import "WJBaiduMapTools.h"
//注:需要导入百度地图api

@interface WJBaiduMapTools ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate> {
    BMKLocationService *_locService; //定位
    BMKGeoCodeSearch *_searcher;     //geo搜索服务
    BOOL _needaddress;               //是否定位
    //得到经纬度
    void (^ _locationSuccess)(double longitude,double latitude);
    //得到经纬度和地理位置信息
    void (^ _addressSuccess)(double longitude,double latitude,BMKAddressComponent *address);
}

@end

@implementation WJBaiduMapTools

+(WJBaiduMapTools *)instance {
    static WJBaiduMapTools *location;
    @synchronized(self) {
        if(!location) {
            location = [[WJBaiduMapTools alloc] init];
            
        }
    }
    return location;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _needaddress=NO;
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [BMKLocationService setLocationDistanceFilter:100.f];
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return self;
}

//开始定位
-(void)startlocation:(BOOL)needaddress locationSuccess:(void (^)(double, double))locationSuccess addressSuccess:(void (^)(double, double, BMKAddressComponent *))addressSuccess{
    _needaddress=needaddress;
    _locationSuccess=locationSuccess;
    _addressSuccess=addressSuccess;
    if (_locService!=nil) {
        [_locService startUserLocationService];
    }
}

//停止定位
- (void)stoplocation {
    if (_locService!=nil) {
        [_locService stopUserLocationService];
    }
}

// 定位成功
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [_locService stopUserLocationService];
    double longitude=userLocation.location.coordinate.longitude;
    double latitude=userLocation.location.coordinate.latitude;
    if (_locationSuccess) {
        _locationSuccess(longitude,latitude);
    }
    if (_needaddress) {
        //发起反向地理编码检索
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = (CLLocationCoordinate2D){latitude,longitude};
        BOOL flag = [_searcher reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");   
        }
    }else{
        
    }
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (_addressSuccess) {
            _addressSuccess(result.location.longitude,result.location.latitude,result.addressDetail);
        }
    }
}
@end
