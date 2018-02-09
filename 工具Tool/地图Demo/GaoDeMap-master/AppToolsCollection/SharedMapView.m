//
//  SharedMapView.m
//  officialDemoNavi
//
//  Created by  on 15/5/26.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "SharedMapView.h"

@interface SharedMapView ()
{
    NSMutableArray *_internalStatusArray;
}

@property (nonatomic, readwrite) MAMapView *mapView;

@end

@implementation SharedMapView

+ (instancetype)sharedInstance
{
    static SharedMapView *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SharedMapView alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Initialized

- (instancetype)init
{
    if (self = [super init])
    {
        //初始化数组
        [self initProperties];
        
        //设置地图坐标
        [self createMapView];
    }
    return self;
}

- (void)initProperties
{
    _internalStatusArray = [[NSMutableArray alloc] init];
}

- (void)createMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
}

#pragma mark - Interface

- (void)stashMapViewStatus
{
    @synchronized (_internalStatusArray)
    {
        if (_internalStatusArray == nil)
        {
            return;
        }
        //取地图状态加到数组里
        [_internalStatusArray addObject:[self.mapView getMapStatus]];
    }
}

- (void)popMapViewStatus
{
    @synchronized (_internalStatusArray)
    {
        if (_internalStatusArray == nil || ![_internalStatusArray count])
        {
            return;
        }
        //设置地图状态
        [self.mapView setMapStatus:[_internalStatusArray lastObject] animated:NO];
        //移除最后一个元素
        [_internalStatusArray removeLastObject];
    }
}

@end

