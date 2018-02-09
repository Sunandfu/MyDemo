//
//  ViewController.m
//  baidumapTest
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 tqh. All rights reserved.
//

//使用百度地图定位,poi搜索，地理编码功能
#import "ViewController.h"
#import "WJBaiduMapTools.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<BMKPoiSearchDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate>{
    BMKMapView *_mapView;                //地图
    BMKPoiSearch *_poisearch;            //poi搜索
    BMKGeoCodeSearch  *_geocodesearch;   //geo搜索服务
}
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百度地图";
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [_mapView setZoomLevel:13];
    _mapView.isSelectedAnnotationViewFront = YES;
    
    //使用真机定位
//    WJBaiduMapTools *tool = [WJBaiduMapTools instance];
//    [tool startlocation:YES locationSuccess:^(double longitude, double latitude) {
//        NSLog(@"%f,%f",longitude,latitude);
//    } addressSuccess:^(double longitude, double latitude, BMKAddressComponent *address) {
//        NSLog(@"%f,%f",longitude,latitude);
//        NSLog(@"城市名：%@ %@",address.city,address.streetName);
//    }];
    
    //延迟搜索
    [self performSelector:@selector(delay) withObject:self afterDelay:2];
 
}
- (void)delay {
    [self nameSearch];
}
#pragma mark - poi搜索
- (void)citySearch {
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city= @"上海";
    citySearchOption.keyword = @"餐厅";
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}
#pragma mark - 根据名称搜索
- (void)nameSearch {
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"上海";
    geocodeSearchOption.address = @"东方明珠";
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}
#pragma mark - 根据经纬度搜索
- (void)reverseGeoPointSearch {
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    
    NSString *longitude = @"116.403981";
    NSString *latitude = @"39.915101";
    if (latitude != nil && longitude != nil) {
        pt = (CLLocationCoordinate2D){[latitude floatValue], [longitude floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - BMKMapViewDelegate
//长按获取经纬度，并添加标注
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"经纬度:%f,%f",coordinate.longitude,coordinate.latitude);
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = coordinate;
    item.title = @"哇哈哈";
    [_mapView addAnnotation:item];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        NSLog(@"正常返回");
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            NSLog(@"%@",poi.name);
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        // 各种情况的判断。。。
        NSLog(@"其他情况");
    } else if (errorCode == BMK_SEARCH_NOT_SUPPORT_BUS){
        // 各种情况的判断。。。
        NSLog(@"其他情况");
    } else if (errorCode == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY){
        // 各种情况的判断。。。
        NSLog(@"其他情况");
    } else if (errorCode == BMK_SEARCH_RESULT_NOT_FOUND){
        // 各种情况的判断。。。
        NSLog(@"其他情况");
    } else if (errorCode == BMK_SEARCH_ST_EN_TOO_NEAR){
        // 各种情况的判断。。。
        NSLog(@"其他情况");
    } else if (errorCode == BMK_SEARCH_KEY_ERROR){
        // 各种情况的判断。。。
        NSLog(@"其他情况");
    } else if (errorCode == BMK_SEARCH_NETWOKR_ERROR){
        // 各种情况的判断。。。
        NSLog(@"其他情况");
    } else if (errorCode == BMK_SEARCH_NETWOKR_TIMEOUT){
        // 各种情况的判断。。。
        NSLog(@"其他情况");
    } else if (errorCode == BMK_SEARCH_PERMISSION_UNFINISHED){
        // 各种情况的判断。。。
        NSLog(@"还未完成鉴权，请在鉴权通过后重试");
      
    }else {
        NSLog(@"不知道了");
    }
}


#pragma mark - BMKGeoCodeSearchDelegate
// *返回地址信息搜索结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        
        //应该在这里得到经纬度然后
    }
}
// *返回反地理编码搜索结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
