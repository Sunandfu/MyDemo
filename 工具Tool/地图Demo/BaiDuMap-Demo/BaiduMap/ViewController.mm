//
//  ViewController.m
//  BaiduMap
//
//  Created by 林英伟 on 16/3/28.
//  Copyright © 2016年 林英伟. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Rotate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>
//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//引入检索功能所有的头文件

//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>
//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>
//只引入所需的单个头文件


#define NAVI_TEST_APP_KEY @ "4kj3x48uyNdXDpp8qzWPRVSyQYV0bIvd" //跟AppDelegate.m定义的key是一样的,需要申请

//图片资源文件 路径
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree; //角度 方向值
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface ViewController ()<BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>
@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKGeoCodeSearch *searcher;
@property (nonatomic,strong) BMKRouteSearch* routesearch;
@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@end

BMKMapManager* _mapManager;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.navigationController.navigationBar.hidden = YES;
    //配置导航管理者
    [self configManager];
    //初始化按钮
    [self initToolBar];
    //创建并显示地图
    [self initMapView];
    //两点距离算路 有需要再调用
    [self countDistance];
    
    ///route搜索服务 路线检索对象
    self.routesearch = [[BMKRouteSearch alloc]init];
}

#pragma mark - configManager(配置导航管理者)
- (void)configManager{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"NPI8ipQAy9TMIaFZapWeCF3UfdeVaOwx" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark - initMethod(初始化方法)
- (void)initToolBar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 80)];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"驾车" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor cyanColor]];
    [btn1 setFrame:CGRectMake(0, 0, 100, 50)];
    //驾车的路线检索
    [btn1 addTarget:self action:@selector(onClickDriveSearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"步行" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor cyanColor]];
    [btn2 setFrame:CGRectMake(105, 0, 100, 50)];
    //步行的路线检索
    [btn2 addTarget:self action:@selector(onClickWalkSearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setTitle:@"导航" forState:UIControlStateNormal];
    [btn3 setBackgroundColor:[UIColor cyanColor]];
    [btn3 setFrame:CGRectMake(205, 0, 100, 50)];
    //导航
    [btn3 addTarget:self action:@selector(openMapDrivingRoute) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    [view addSubview:btn2];
    [view addSubview:btn3];
    
    [self.view addSubview:view];
}

- (void)initMapView{
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50)];
    [self.view addSubview: self.mapView];
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    //启动LocationService
    [self.locService startUserLocationService];
    //以下_mapView为BMKMapView对象
    
    //开启跟随
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;//显示定位图层
}

#pragma mark - countDistance(算两点距离)
- (void)countDistance{
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,116.404));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(38.915,115.404));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    NSLog(@"距离 %f",distance);
}

#pragma mark - locationInfomation(用户位置信息)
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(userLocation){
            NSLog(@"heading is %@",userLocation.heading);
        }
    });
}

//处理位置坐标更新  定位当前位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(userLocation){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //当前经纬度
            NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
            
            self.latitude = userLocation.location.coordinate.latitude;
            self.longitude = userLocation.location.coordinate.longitude;
            //更新我的位置数据
            [self.mapView updateLocationData:userLocation];
            
            ///geo搜索服务 (将经纬度转化为地址,城市等信息,被称为反向地理编码)
            self.searcher = [[BMKGeoCodeSearch alloc]init];
            self.searcher.delegate = self;
            CLLocationCoordinate2D point = (CLLocationCoordinate2D){self.latitude,self.longitude};
            BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                                    BMKReverseGeoCodeOption alloc]init];
            reverseGeoCodeSearchOption.reverseGeoPoint = point;
            BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
            if(flag)
            {
                NSLog(@"反geo检索发送成功");
            }
            else
            {
                NSLog(@"反geo检索发送失败");
            }
        });
    }
}

#pragma mark - onGetReverseGeoCodeResult(反向地理编码结果)
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //这里打印出反向地理编码的结果,包括城市,地址等信息
        NSLog(@"测试结果 %@  %@",result.addressDetail.city,result.address);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - configDelegate(设置代理及取消代理)
//设置代理
-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.routesearch.delegate = self;
}

// 此处记得不用的时候需要置nil，否则影响内存的释放
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.searcher.delegate = nil;
    self.routesearch.delegate = nil;
}

#pragma mark - checkNetwork(检查网络及授权)
//检查网络状态
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark - BMKMapViewDelegate(地图标注及路线颜色)

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}


#pragma mark - BMKRouteSearchDelegate(各类型的路线检索)
/**
 *返回公交搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    
}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch*)searcher result:(BMKRidingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
}

/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}


/**
 *返回步行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKWalkingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

#pragma mark - buttonAction(按钮点击事件)
//驾乘
-(void)onClickDriveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = (CLLocationCoordinate2D){self.latitude,self.longitude};
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = (CLLocationCoordinate2D){39.915,115.404};
    //此项为驾车查询基础信息类 想改为公交的把(BMKDrivingRoutePlanOption)改为(BMKTransitRoutePlanOption)即可
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");//成功后调用onGetDrivingRouteResult
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

//步行
-(void)onClickWalkSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = (CLLocationCoordinate2D){self.latitude,self.longitude};
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = (CLLocationCoordinate2D){23.075,113.199};
       //此项为步行查询基础信息类 想改为骑车的把(BMKWalkingRoutePlanOption)改为(BMKRidingRoutePlanOption)即可
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");//成功后调用onGetWalkingRouteResult
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
}

#pragma mark - navi(导航开始)
//导航
- (void)openMapDrivingRoute {
    //外部导航
        //初始化调启导航时的参数管理类
        BMKNaviPara* para = [[BMKNaviPara alloc]init];
        //初始化起点节点
        BMKPlanNode* start = [[BMKPlanNode alloc]init];
        //指定起点经纬度
        CLLocationCoordinate2D coor1;
        coor1.latitude = self.latitude;
        coor1.longitude = self.longitude;
        start.pt = coor1;
        //指定起点名称
        start.name = @"我的位置";
        //指定起点
        para.startPoint = start;
        
        //初始化终点节点
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        //指定终点经纬度
        CLLocationCoordinate2D coor2;
        coor2.latitude = 24.111;
        coor2.longitude = 113.111;
        end.pt = coor2;
        //指定终点名称
        //    end.name = @"天安门";
        //指定终点
        para.endPoint = end;
        
        //指定返回自定义scheme
        para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
        
        //调启百度地图客户端导航
        //调起驾车导航 (步行导航为openBaiduMapWalkNavigation(不支持调起web地图))(骑行导航为(openBaiduMapRideNavigation))
        [BMKNavigation openBaiduMapNavigation:para];

}

#pragma mark - configImages(配置资图片)
//下面2个为私有方法
//配置图片文件路径
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}
//使用图片文件
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
        break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
        break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
        break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
        break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
        break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
        break;
        default:
        break;
    }
    
    return view;
}

//根据polyline设置地图范围 绘制路线
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
