//
//  MapViewController.m
//  khqyKhqyIphone
//
//  Created by 林英伟 on 15/11/7.
//
//

#import "MapViewController.h"
#import "CommentDefine.h"
typedef NS_ENUM(NSInteger, TravelTypes)
{
    TravelTypeCar = 0,      // 驾车方式
    TravelTypeWalk,         // 步行方式
};
@interface MapViewController ()<AMapNaviViewControllerDelegate>
{
    AMapNaviPoint *_endPoint;
    
    AMapNaviPoint *_startPoint;
    
    MAUserLocation *_userLocation;
    
    NSMutableArray *_poiAnnotations;
}

@property (nonatomic, strong) AMapNaviViewController *naviViewController;//导航视图控制器，通过该对象可自定义起点、终点、途经点的图标，设置摄像头图标
@property (nonatomic,strong) UISegmentedControl *segCtrl;
@property (nonatomic,assign) BOOL isNavi;
@property (nonatomic) TravelTypes travelType;
@property (nonatomic,strong) MAAnnotationView *userLocationAnnotationView;
@end

@implementation MapViewController
@synthesize userLocationAnnotationView = _userLocationAnnotationView;
#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"网点导航";
    self.isNavi = YES;
    self.travelType = 0;
    
    [self configSubViews];
    
    [self initProperties];
    
    [self showPOIAnnotations];
    
    [self initBackItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupMapView];
}
//设置蓝色圈圈
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
        
        accuracyCircleView.lineWidth    = 2.f;
        //  accuracyCircleView.strokeColor  = [UIColor lightGrayColor];
        //  accuracyCircleView.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleView;
    }
    
    return nil;
}

#pragma mark - Initalization

- (void)initProperties
{
    _poiAnnotations = [[NSMutableArray alloc] init];
    
}

//导航视图初始化
- (void)initNaviViewController
{
    if (self.naviViewController == nil)
    {
        self.naviViewController = [[AMapNaviViewController alloc] initWithMapView:self.mapView delegate:self];
    }
    
    [self.naviViewController setDelegate:self];
}

- (void)setMView
{
 
    if (self.mapView == nil)
    {
        self.mapView = [[SharedMapView sharedInstance] mapView];
    }
    
    self.mapView.frame = CGRectMake(0,50, ScreenWidth, ScreenHeight-50);
    [self.mapView setDelegate:self];
    
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
}

#pragma mark - Handle Views

- (void)setupMapView
{
    [self setMView];
    
    [self.view insertSubview:self.mapView atIndex:0];
    self.mapView.userTrackingMode = 1;//0是显示默认图 1是定位不跟随角度改变 2跟随角度改变
    [self.mapView setShowsUserLocation:YES];//开启定位
    
    if ([_poiAnnotations count])
    {
        [self showPOIAnnotations];
    }
    
}
- (void)configSubViews
{
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"驾车" , @"步行"]];
    [segCtrl addTarget:self action:@selector(segCtrlClick:) forControlEvents:UIControlEventValueChanged];
    [segCtrl setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}
                           forState:UIControlStateNormal];
    segCtrl.selectedSegmentIndex = 0;
    segCtrl.frame = CGRectMake((ScreenWidth-150)/2, 10, 150, 30);
    self.segCtrl = segCtrl;
    [self.view addSubview:segCtrl];
}
- (void)initBackItem
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItem"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)cleanMapView
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView setShowsUserLocation:NO];
    
    [self.mapView setDelegate:nil];
}


#pragma mark - Actions
- (void)calculateRoute
{
    NSArray *endPoints = @[_endPoint];
    // NSArray *startPoints = @[_startPoint];
    if (self.travelType == 0) {
        //不带起点驾车
      [self.naviManager calculateDriveRouteWithEndPoints:endPoints wayPoints:nil drivingStrategy:0];
    }else if(self.travelType == 1){
        //不带起点步行
        [self.naviManager calculateWalkRouteWithEndPoints:endPoints];
    }
    
    
}

#pragma mark - MapView Delegate
//当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (self.isNavi) {
        [self.mapView setZoomLevel:13 animated:YES];
        self.isNavi = NO;
    }
    
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
}

/*!
 @brief 标注view的accessory view(必须继承自UIControl)被点击时，触发该回调
 @param mapView 地图View
 @param annotationView callout所属的标注view
 @param control 对应的control
 */
//点击导航触发
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]])
    {   //大头针
        MAPointAnnotation *annotation = (MAPointAnnotation *)view.annotation;
        
        //取大头针的经纬度
        _endPoint = [AMapNaviPoint locationWithLatitude:annotation.coordinate.latitude
                                              longitude:annotation.coordinate.longitude];
        
       [self calculateRoute];
    }
}
//实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"poiIdentifier";
        //复用
        MANaviAnnotationView *annotationView = (MANaviAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            //创建气泡左侧按钮
            annotationView = [[MANaviAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout = YES;//设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;//设置标注动画显示，默认为NO
        annotationView.draggable = NO;//设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;//紫色
        //annotationView.image = [UIImage imageNamed:@"restaurant"];//自定义图片
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            //初始化并返回一个annotation view
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    }
    return nil;
}

/*!
 @brief 设置地图使其可以显示数组中所有的annotation。
 */
- (void)showPOIAnnotations
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
   
    [annotation setCoordinate:CLLocationCoordinate2DMake(23.063934,113.155768)];
    //气泡右边视图
    [annotation setTitle:@"佛山南海万达广场"];
    [annotation setSubtitle:@"佛山南海"];
    
    [_poiAnnotations addObject:annotation];
    
    [self.mapView addAnnotations:_poiAnnotations];
    
    if (_poiAnnotations.count == 1)
    {
        //把大头针设置地图中心点
        self.mapView.centerCoordinate = [(MAPointAnnotation *)_poiAnnotations[0] coordinate];
    }
    else
    {
        [self.mapView showAnnotations:_poiAnnotations animated:NO];
    }
}

#pragma mark - AMapNaviManager Delegate
//导航视图被展示出来的回调函数
/*!
 @brief naviViewController被展示出来后的回调
 @param naviViewController 被展示出来的ViewController
 */
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    NSLog(@"didPresentNaviViewController导航视图被展示出来的回调函数");
    //调用startGPSNavi方法进行实时导航，调用startEmulatorNavi方法进行模拟导航
    //[self.naviManager startEmulatorNavi];
    [self.naviManager startGPSNavi];
}
/*!
 @brief naviViewController被取消展示后的回调
 @param naviViewController 被取消展示ViewController
 */
- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{
    NSLog(@"didDismissNaviViewController");
    
    [self setupMapView];
}
/*!
 @brief 驾车路径规划成功后的回调函数
 */
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    NSLog(@"OnCalculateRouteSuccess,路径规划成功的回调函数");
    
    if (self.naviViewController == nil)
    {
        [self initNaviViewController];
    }
    
    [self cleanMapView];
    //导航视图展示
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
}

//导航界面上的关闭按钮
- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.iFlySpeechSynthesizer stopSpeaking];
    });
    
    [self.naviManager stopNavi];
    self.isNavi = YES;
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}
/*!
 @brief 导航界面更多按钮点击时的回调函数
 */
- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}
/*!
 @brief 导航界面转向指示View点击时的回调函数
 */
- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    //触发一次导航播报信息
    [self.naviManager readNaviInfoManual];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self returnAction];
}
//选择导航方式
- (void)segCtrlClick:(id)sender
{
    UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
    
    TravelTypes travelType = segCtrl.selectedSegmentIndex == 0 ? TravelTypeCar : TravelTypeWalk;
    if (travelType != self.travelType)
    {
        self.travelType = travelType;
        NSLog(@"%d",travelType);
    }
}

@end
