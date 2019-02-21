# 头条联盟 iOS SDK 接入说明

| 文档版本| 修订日期| 修订说明|
| --- | --- | --- |
| v1.0.0 | 2017-6-23 | 创建文档，支持Banner，信息流广告|
| v1.1.0 | 2017-7-21 | 优化接口字段，数据加密|
| v1.1.1 | 2017-7-30 | 优化事件回调接口|
| v1.2.0 | 2017-9-17 | 新增开屏、插屏广告|
| v1.3.2 | 2017-12-28 | bug fix 插屏转屏，webview 无返回按钮   |
| v1.4.0 | 2017-12-2 | 新增banner轮播，视频广告|
| v1.5.0 | 2018-01-29 | 新增激励视频 |
| v1.5.1 | 2018-02-06 | 解决符号冲突问题 |
| v1.5.2 | 2018-03-01 | 解决Feed曝光量为0
| v1.8.0 | 2018-03-28 | 激励视频纵向支持与横向展示修复|
| v1.8.1 | 2018-04-11 | 修复UIView分类可能与媒体重名问题|
| v1.8.2 | 2018-04-12 | 修复WebView页面NavigationBar显示问题|
| v1.8.3 | 2018-04-25 | 【1】新增AdMob通过CustomEvent Adapter方式聚合Demo 【2】修复激励视频iPhone X、ipad适配问题【3】App Store页面支持横向展示|
| v1.8.4 | 2018-05-02 | 声音播放同步设备静音模式，使静音模式下不播放激励视频声音
| v1.9.0 | 2018-05-04 |【1】优化开屏广告SDK的请求缓存逻辑 【2】修复原生视频详情页转屏问题|
| v1.9.1 | 2018-05-10 |【1】解决开屏跳转问题【2】修改跳转deepLink情况下跳转逻辑|
|v1.9.2  | 2018-05-16 |【1】解决激励视频奖励问题【2】解决屏幕旋转问题【3】解决iOS8 crash问题【4】解决webView导航条在iPhone X上适配问题
| v1.9.3 | 2018-06-12 |【1】广告支持第三方检测链接和逻辑优化|
| v1.9.4 | 2018-06-12 |【1】激励视频encard页面预缓存【2】原生视频优化【3】SDK对外接口优化|
| v1.9.4.1 | 2018-08-23 |【1】增加反作弊策略|
| v1.9.5 | 2018-08-31 |【1】新增全屏视频广告类型【2】原生广告新增banner和插屏模板，支持原生banner样式，原生插屏样式【3】兼容iOS6、iOS7，但不支持iOS6与iOS7中展现广告【4】原生广告（视频、图文）通用性扩充，不依赖于WMTableViewCell，支持在UIView中展示，同时也支持UITableView、UICollectionView、UIScrollView等列表视图中展示|
| v1.9.5.1 | 2018-08-31 |【1】修改webview高度在translucent==NO的适配 |
| v1.9.6.0 | 2018-09-13 |【1】修改开屏代理回调的命名,spalsh改为splash【2】插屏样式微调【3】新增开屏超时策略的埋点|

<!-- TOC -->

- [头条联盟 iOS SDK 接入说明](#头条联盟-ios-sdk-接入说明)
    - [1. 网盟iOS SDK接入](#1-网盟ios-sdk接入)
        - [1.1 iOS SDK导入framework](#11-ios-sdk导入framework)
            - [1.1.1 申请应用的AppID和SlotID](#111-申请应用的appid和slotid)
            - [1.1.2 工程设置导入framework](#112-工程设置导入framework)
        - [1.2 Xcode编译选项设置](#12-xcode编译选项设置)
            - [1.2.1 添加权限](#121-添加权限)
            - [1.2.2 运行环境配置](#122-运行环境配置)
            - [1.2.3 添加依赖库](#123-添加依赖库)
    - [2. SDK接口类介绍与广告接入](#2-sdk接口类介绍与广告接入)
        - [2.1 全局设置(WMAdSDKManager)](#21-全局设置wmadsdkmanager)
            - [2.1.1 接口说明](#211-接口说明)
            - [2.1.2 使用](#212-使用)
        - [2.2 原生广告](#22-原生广告)
            - [2.2.1广告类(WMNativeAd)](#221广告类wmnativead)
                - [2.2.1.1 WMNativeAd接口说明](#2211-wmnativead接口说明)
                - [2.2.1.2 接口实例](#2212-接口实例)
                - [2.2.1.3 WMNativeAdDelegate回调说明](#2213-wmnativeaddelegate回调说明)
                - [2.2.1.4 回调实例](#2214-回调实例)
            - [2.2.2 广告位类(WMAdSlot)](#222-广告位类wmadslot)
                - [2.2.2.1 WMAdSlot接口说明](#2221-wmadslot接口说明)
                - [2.2.2.2 接口实例](#2222-接口实例)
            - [2.2.3 广告数据类(WMMaterialMeta)](#223-广告数据类wmmaterialmeta)
                - [2.2.3.1 WMMaterialMeta接口说明](#2231-wmmaterialmeta接口说明)
            - [2.2.4 相关视图类(WMNativeAdRelatedView)](#224-相关视图类wmnativeadrelatedview)
                - [2.2.4.1 WMNativeAdRelatedView接口说明](#2241-wmnativeadrelatedview接口说明)
            - [2.2.5 原生广告使用](#225-原生广告使用)
                - [2.2.5.1 原生广告接口与加载](#2251-原生广告接口与加载)
                - [2.2.5.2 初始化需要绑定广告数据的View](#2252-初始化需要绑定广告数据的view)
                - [2.2.5.3 添加相关视图](#2253-添加相关视图)
                - [2.2.5.4 广告数据获取后，更新View并注册可点击的View](#2254-广告数据获取后更新view并注册可点击的view)
                - [2.2.5.5 在 WMNativeAd 的 delegate 中处理各种回调协议方法](#2255-在-wmnativead-的-delegate-中处理各种回调协议方法)
        - [2.3 信息流广告(WMNativeAdsManager)](#23-信息流广告wmnativeadsmanager)
            - [2.3.1 WMNativeAdsManager接口说明](#231-wmnativeadsmanager接口说明)
            - [2.3.1.1 实例说明](#2311-实例说明)
        - [2.4 原生banner广告](#24-原生banner广告)
        - [2.5 原生插屏广告](#25-原生插屏广告)
        - [2.6 视频广告(WMVideoAdView)](#26-视频广告wmvideoadview)
            - [2.6.1 WMVideoAdView接口说明](#261-wmvideoadview接口说明)
            - [2.6.2 WMVideoAdView回调说明](#262-wmvideoadview回调说明)
            - [2.6.3 实例](#263-实例)
        - [2.7 Banner广告(WMBannerAdViewDelegate)](#27-banner广告wmbanneradviewdelegate)
            - [2.7.1  WMBannerAdViewDelegate接口说明](#271--wmbanneradviewdelegate接口说明)
            - [2.7.2 接口实例](#272-接口实例)
        - [2.8 开屏广告(WMSplashAdView)](#28-开屏广告wmsplashadview)
            - [2.8.1 WMSplashAdView接口说明](#281-wmsplashadview接口说明)
            - [2.8.2 WMSplashAdView回调说明](#282-wmsplashadview回调说明)
            - [2.8.3 实例](#283-实例)
        - [2.9 插屏广告(WMInterstitialAd)](#29-插屏广告wminterstitialad)
            - [2.9.1 WMInterstitialAd接口说明](#291-wminterstitialad接口说明)
            - [2.9.2 WMInterstitialAd回调说明](#292-wminterstitialad回调说明)
            - [2.9.3 实例](#293-实例)
        - [2.10 激励视频(WMRewardedVideoAd)](#210-激励视频wmrewardedvideoad)
            - [2.10.1 WMRewardedVideoAd接口说明](#2101-wmrewardedvideoad接口说明)
            - [2.10.2 WMRewardedVideoAd回调说明](#2102-wmrewardedvideoad回调说明)
            - [2.10.3 实例](#2103-实例)
            - [2.10.4 WMRewardedVideoModel](#2104-wmrewardedvideomodel)
            - [2.10.5 服务器到服务器回调](#2105-服务器到服务器回调)
                - [回调方式说明](#回调方式说明)
                - [签名生成方式](#签名生成方式)
                - [返回约定](#返回约定)
            - [2.10.6 AdMob通过CustomEvent Adapter方式聚合激励视频](#2106-admob通过customevent-adapter方式聚合激励视频)
        - [2.11 全屏视频(WMFullscreenVideoAd)](#211-全屏视频wmfullscreenvideoad)
            - [2.11.1 WMFullscreenVideoAd接口说明](#2111-wmfullscreenvideoad接口说明)
            - [2.11.2 WMFullscreenVideoAd回调说明](#2112-wmfullscreenvideoad回调说明)
            - [2.11.3 实例](#2113-实例)
    - [附录](#附录)
        - [SDK错误码](#sdk错误码)
        - [FAQ](#faq)

<!-- /TOC -->

## 1. 网盟iOS SDK接入

### 1.1 iOS SDK导入framework

#### 1.1.1 申请应用的AppID和SlotID

请向头条联盟穿山甲平台申请AppID 和广告 SlotID。

#### 1.1.2 工程设置导入framework

获取 framework 文件后直接将 {WMAdSDK.framework, WMAdSDK.bundle}文件拖入工程即可。

### 1.2 Xcode编译选项设置

#### 1.2.1 添加权限

 **注意要添加的系统库**

+ 工程plist文件设置，点击右边的information Property List后边的 "+" 展开

添加 App Transport Security Settings，先点击左侧展开箭头，再点右侧加号，Allow Arbitrary Loads 选项自动加入，修改值为 YES。 SDK API 已经全部支持HTTPS，但是广告主素材存在非HTTPS情况。

```json
<key>NSAppTransportSecurity</key>
    <dict>
         <key>NSAllowsArbitraryLoads</key>
         <true/>
    </dict>
```

+ Build Settings中Other Linker Flags **增加参数-ObjC**，SDK同时支持-all_load

#### 1.2.2 运行环境配置

+ 支持系统 iOS 8.X 及以上;
+ SDK编译环境 Xcode 9.4, Base SDK 11.1;
+ 支持架构：i386, x86-64, armv7, armv7s, arm64

#### 1.2.3 添加依赖库
在TARGETS -> Build Phases中找到Link Binary With Libraries，点击“+”，依次添加下列 framework

+ StoreKit.framework
+ MobileCoreServices.framework
+ WebKit.framework
+ MediaPlayer.framework
+ CoreMedia.framework
+ AVFoundation.framework
+ CoreLocation.framework
+ CoreTelephony.framework
+ SystemConfiguration.framework
+ AdSupport.framework

## 2. SDK接口类介绍与广告接入

### 2.1 全局设置(WMAdSDKManager)

WMAdSDKManager 类是整个 SDK 设置的入口和接口，可以设置 SDK 的一些全局信息，提供类方法获取设置结果。
#### 2.1.1 接口说明

目前接口提供以下几个类方法

```Objective-C
+ (void)setAppID:(NSString *)appID; // 设置应用的 appID，这里的 appID 是在头条联盟穿山甲平台的申请注册的 appID

/*
 *	以下为可选配置项，用于构建用户画像与广告定向
 */
+ (void)setUserGender:(WMUserGender)userGender;   // 设置用户的性别
+ (void)setUserAge:(NSUInteger)userAge;           // 设置用户的年龄
+ (void)setUserKeywords:(NSString *)keywords;     // 设置用户的关键字，比如兴趣和爱好等等
+ (void)setUserExtData:(NSString *)data;          // 设置用户的额外信息
+ (void)setIsPaidApp:(BOOL)isPaidApp;             // 设置本app是否是付费app，默认为非付费app
```

#### 2.1.2 使用

SDK 需要在 AppDelegate 的方法 ```- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions``` 里进行初始化

其中以下设置是 **必须** 的，应用相关 appID 设置：

``` Objective-C
[WMAdSDKManager setAppID:@"xxxxxx"];
```

更多使用方式可以参见 SDK Demo 工程

### 2.2 原生广告
+ **类型说明：** 广告原生广告即一般广告样式，形式分为图文和视频，按场景又可区分为原生banner、原生插屏广告等。

+ **使用说明：** 在SDK里只需要使用 WMNativeAd 就可以获取原生广告，WMNativeAd 类提供了原生广告的数据类型等各种信息，在数据获取后可以在属性 data（WMMaterialMeta）里面获取广告数据信息。WMNativeAd还提供原生广告的数据绑定、点击事件的上报，用户可自行定义信息流广告展示形态与布局。


#### 2.2.1广告类(WMNativeAd)

WMNativeAd 类为加载广告的接口类，可以通过数据接口每次请求一个广告数据，并能协助 UIView 注册处理各种广告点击事件，设置delegate后可获取数据。rootViewController是必传参数，是弹出落地页广告ViewController的。

备注:一次请求多条广告数据请使用WMNativeAdsManager，参考2.3

##### 2.2.1.1 WMNativeAd接口说明

```Objctive-C
/**
 抽象的广告位，包含广告数据加载、响应回调
 目前Native支持原生广告，原生广告包括信息流（多条广告，图文+视频形式）、一般原生广告（单条广告，图文+视频形式），原生banner、原生插屏
 同时支持插屏、Banner、开屏、激励视频、全屏视频
 */
@interface WMNativeAd : NSObject

/**
 广告位的描述说明
 */
@property (nonatomic, strong, readwrite, nullable) WMAdSlot *adslot;

/**
 广告位的素材资源
 */
@property (nonatomic, strong, readonly, nullable) WMMaterialMeta *data;

/**
 广告位加载展示响应的代理回调，可以设置为遵循<WMNativeAdDelegate>的任何类型，不限于Viewcontroller
 */
@property (nonatomic, weak, readwrite, nullable) id<WMNativeAdDelegate> delegate;

/**
 广告位展示落地页通过rootviewController进行跳转，必传参数，跳转方式分为pushViewController和presentViewController两种方式
 */
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

/**
 创建一个Native广告的推荐构造函数
 @param slot 广告位描述信息
 @return Native广告位
 */
- (instancetype)initWithSlot:(WMAdSlot *)slot;

/**
 定义原生广告视图中，注册可点击视图
 @param containerView 注册原生广告的容器视图，必传参数，交互类型在平台配置，包括查看视频详情、打电话、落地页、下载、外部浏览器打开等
 @param clickableViews 注册创意按钮，可选参数，交互类型在平台配置，包括电话、落地页、下载、外部浏览器打开、短信、email、视频详情页等
 */
- (void)registerContainer:(__kindof UIView *)containerView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;

/// 广告类解除和view的绑定
- (void)unregisterView;

/**
 主动 请求广告数据
 */
- (void)loadAdData;
@end
```
##### 2.2.1.2 接口实例
比如在一个VC里面，通过方法 loadNativeAd 加载广告

```Objective-C
- (void)loadNativeAd {
    WMNativeAd *nad = [WMNativeAd new];
    WMAdSlot *slot1 = [[WMAdSlot alloc] init];
    WMSize *imgSize1 = [[WMSize alloc] init];
    imgSize1.width = 1080;
    imgSize1.height = 1920;
    slot1.ID = @"900480107";
    slot1.AdType = WMAdSlotAdTypeFeed;
    slot1.position = WMAdSlotPositionTop;
    slot1.imgSize = imgSize1;
    slot1.isSupportDeepLink = YES;
    nad.adslot = slot1;
    
    nad.rootViewController = self;
    nad.delegate = self;

    self.ad = nad;

    [nad loadAdData];
}
```

在创建 WMNativeAd 对象后，需要给这个对象设置回调代理，这样就可以在数据返回后更新展示视图。回调代理见 WMNativeAdDelegate 介绍。

##### 2.2.1.3 WMNativeAdDelegate回调说明

```Objective-C
@protocol WMNativeAdDelegate <NSObject>

@optional

/**
 nativeAd 网络加载成功
 @param nativeAd 加载成功
 */
- (void)nativeAdDidLoad:(WMNativeAd *)nativeAd;

/**
 nativeAd 出现错误
 @param nativeAd 错误的广告
 @param error 错误原因
 */
- (void)nativeAd:(WMNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error;

/**
 nativeAd 即将进入可视区域
 @param nativeAd 广告位即将出现在可视区域
 */
- (void)nativeAdDidBecomeVisible:(WMNativeAd *)nativeAd;

/**
 nativeAd 被点击

 @param nativeAd 被点击的 广告位
 @param view 被点击的视图
 */
- (void)nativeAdDidClick:(WMNativeAd *)nativeAd withView:(UIView *_Nullable)view;

/**
 用户点击 dislike功能
 @param nativeAd 被点击的 广告位
 @param filterWords 不喜欢的原因， 可能为空
 */
- (void)nativeAd:(WMNativeAd *)nativeAd dislikeWithReason:(NSArray<WMDislikeWords *> *)filterWords;

@end

```

##### 2.2.1.4 回调实例

WMNativeAd 设置 delegate 后，我们可以在 delegate 里添加如下回调方法，负责处理广告数据返回以及各种自定义的点击事件。

如上面例子中nativeAdDidLoad方法获取数据后，负责更新视图，并注册绑定了相应的点击事件

```Objctive-C
- (void)nativeAdDidLoad:(WMNativeAd *)nativeAd {
    self.infoLabel.text = nativeAd.data.AdTitle;
    WMMaterialMeta *adMeta = nativeAd.data;
    CGFloat contentWidth = CGRectGetWidth(_customview.frame) - 20;
    WMImage *image = adMeta.imageAry.firstObject;
    const CGFloat imageHeight = contentWidth * (image.height / image.width);
    CGRect rect = CGRectMake(10, CGRectGetMaxY(_phoneButton.frame) + 5, contentWidth, imageHeight);
    
    // imageMode来决定是否展示视频
    if (adMeta.imageMode == WMFeedVideoAdModeImage) {
        self.imageView.hidden = YES;
        self.relatedView.videoAdView.hidden = NO;
        self.relatedView.videoAdView.frame = rect;
        [self.relatedView refeshData:nativeAd];
    } else {
        self.imageView.hidden = NO;
        self.relatedView.videoAdView.hidden = YES;
        if (adMeta.imageAry.count > 0) {
            if (image.imageURL.length > 0) {
                self.imageView.frame = rect;
                [self.imageView setImageWithURL:[NSURL URLWithString:image.imageURL] placeholderImage:nil];
            }
        }
    }
 
    
    // Register UIView with the native ad; the whole UIView will be clickable.
    [nativeAd registerContainer:self.customview withClickableViews:@[self.infoLabel, self.phoneButton, self.downloadButton, self.urlButton]];
}

- (void)nativeAd:(WMNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
}

- (void)nativeAdDidClick:(WMNativeAd *)nativeAd withView:(UIView *)view {
    NSString *str = NSStringFromClass([view class]);
    NSString *info = [NSString stringWithFormat:@"点击了 %@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"广告" message:info delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    [alert show];
}

- (void)nativeAdDidBecomeVisible:(WMNativeAd *)nativeAd {
}
```

更多例子可以参照 SDK Demo。

#### 2.2.2 广告位类(WMAdSlot)

WMAdSlot 对象为加载广告时需要设置的广告位描述信息，在WMNativeAd、WMNativeAdsManager、WMBannerAdView、WMInterstitialAd、WMSplashAdView、WMFullscreenVideoAd、WMRewardedVideoAd中均需要初始化阶段传入。**在加载广告前，必须须设置好**。
##### 2.2.2.1 WMAdSlot接口说明
```Objctive-C
// 代码位ID required
@property (nonatomic, copy) NSString *ID;

// 广告类型 required
@property (nonatomic, assign) WMAdSlotAdType AdType;

// 广告展现位置 required
@property (nonatomic, assign) WMAdSlotPosition position;

// 接受一组图片尺寸，数组请传入WMSize对象
@property (nonatomic, strong) NSMutableArray<WMSize *> *imgSizeArray;

// 图片尺寸 required
@property (nonatomic, strong) WMSize *imgSize;

// 图标尺寸
@property (nonatomic, strong) WMSize *iconSize;

// 标题的最大长度
@property (nonatomic, assign) NSInteger titleLengthLimit;

// 描述的最大长度
@property (nonatomic, assign) NSInteger descLengthLimit;

// 是否支持deeplink
@property (nonatomic, assign) BOOL isSupportDeepLink;

// 1.9.5 原生banner、插屏广告
@property (nonatomic, assign) BOOL isOriginAd;


```
##### 2.2.2.2 接口实例
我们以WMNativeAd为例，初始化一个 WMAdSlot 对象，传给 WMNativeAd，这样WMNativeAd会根据 WMAdSlot 对象来获取合适的广告信息，参考代码如下：

```Objective-C
- (void)loadNativeAd {
    WMNativeAd *nad = [WMNativeAd new];
    WMAdSlot *slot1 = [[WMAdSlot alloc] init];
    WMSize *imgSize1 = [[WMSize alloc] init];
    imgSize1.width = 1080;
    imgSize1.height = 1920;
    slot1.ID = @"900480107";
    slot1.AdType = WMAdSlotAdTypeFeed;
    slot1.position = WMAdSlotPositionTop;
    slot1.imgSize = imgSize1;
    slot1.isSupportDeepLink = YES;
    nad.adslot = slot1;

    nad.delegate = self;
    nad.rootViewController = self;

    self.ad = nad;

    [nad loadAdData];
}
```

如上述例子所示，WMNativeAd 对象在初始化完成后，给其设置了一个 WMAdSlot 对象，表明对象是原生广告

可以参见 SDK Demo 以及 WMAdSlot 头文件了解更多信息与使用方法

#### 2.2.3 广告数据类(WMMaterialMeta)

广告数据的载体类 WMMaterialMeta ，访问可以获取所有的广告属性。

##### 2.2.3.1 WMMaterialMeta接口说明

```Objective-C

@interface WMMaterialMeta : NSObject
/// 广告支持的交互类型
@property (nonatomic, assign) WMInteractionType interactionType;

/// 素材图片
@property (nonatomic, strong) NSArray<WMImage *> *imageAry;

/// 图标图片
@property (nonatomic, strong) WMImage *icon;

/// 广告标题
@property (nonatomic, copy) NSString *AdTitle;

/// 广告描述
@property (nonatomic, copy) NSString *AdDescription;

/// 广告来源
@property (nonatomic, copy) NSString *source;

/// 创意按钮显示文字
@property (nonatomic, copy) NSString *buttonText;

/// 客户不喜欢广告，关闭时， 提示不喜欢原因
@property (nonatomic, copy) NSArray<WMDislikeWords *> *filterWords;

/// feed广告的展示类型，banner广告忽略
@property (nonatomic, assign) WMFeedADMode imageMode;

… …

@end

```

另外我们还需要 WMNativeAd 实例，通过 loadData 方法获取信息流广告的数据。
#### 2.2.4 相关视图类(WMNativeAdRelatedView)

相关视图类可以为添加logo、广告标签、视频视图、不喜欢按钮等。

##### 2.2.4.1 WMNativeAdRelatedView接口说明

```Objective-C

@interface WMNativeAdRelatedView : NSObject

/**
 dislike 按钮懒加载，需要主动添加到 View，处理 materialMeta.filterWords反馈
 提高广告信息推荐精度
 */
@property (nonatomic, strong, readonly, nullable) UIButton *dislikeButton;

/**
 adLabel 推广标签懒加载， 需要主动添加到 View
 */
@property (nonatomic, strong, readonly, nullable) UILabel *adLabel;

/**
 logoImageView 网盟广告标识，需要主动添加到 View
 */
@property (nonatomic, strong, readonly, nullable) UIImageView *logoImageView;

/**
 WMPlayer View 需要主动添加到 View
 */
@property (nonatomic, strong, readonly, nullable) WMVideoAdView *videoAdView;

/**
 刷新数据,每次获取数据刷新对应的视图
 */
- (void)refreshData:(WMNativeAd *)nativeAd;

@end
```
**添加logo、广告标签、视频视图、不喜欢按钮请参考WMNativeAdRelatedView类,每次获取物料信息后需要刷新调用-(void)refreshData:(WMNativeAd \*)nativeAd 方法刷新对应的视图绑定的数据.**


#### 2.2.5 原生广告使用
##### 2.2.5.1 原生广告接口与加载

WMNativeAd 对象设置好 WMAdSlot 对象和 delegate（>= V1.8.2 不必一定是 UIViewController）之后，就可以调用 loadAdData 方法异步获取广告数据；获取数据后，delegate 会负责处理回调方法。

##### 2.2.5.2 初始化需要绑定广告数据的View

**在使用原生广告数据时，我们先创建我们需要展示广告数据的 View。**

示例代码：

```Objective-C
 // Custom 视图测试
    CGFloat swidth = [[UIScreen mainScreen] bounds].size.width;
    _customview = [[UIView alloc] initWithFrame:CGRectMake(20, 50, swidth - 40, 200)];
    _customview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_customview];

    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, swidth - 60, 30)];
    _infoLabel.backgroundColor = [UIColor magentaColor];
    _infoLabel.text = @"test ads";
    [_customview addSubview:_infoLabel];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 160, 120)];
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = [UIColor redColor];
    [_customview addSubview:_imageView];

    _phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(swidth - 50, 60, -80, 30)];
    [_phoneButton setTitle:@"打电话" forState:UIControlStateNormal];
    _phoneButton.userInteractionEnabled = YES;
    _phoneButton.backgroundColor = [UIColor orangeColor];
    [_customview addSubview:_phoneButton];

    _downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(swidth - 50, 105, -80, 30)];
    [_downloadButton setTitle:@"下载跳转" forState:UIControlStateNormal];
    _downloadButton.userInteractionEnabled = YES;
    _downloadButton.backgroundColor = [UIColor orangeColor];
    [_customview addSubview:_downloadButton];

    _urlButton = [[UIButton alloc] initWithFrame:CGRectMake(swidth - 50, 150, -80, 30)];
    [_urlButton setTitle:@"URL跳转" forState:UIControlStateNormal];
    _urlButton.userInteractionEnabled = YES;
    _urlButton.backgroundColor = [UIColor orangeColor];
    [_customview addSubview:_urlButton];

    [self loadNativeAd];
```
##### 2.2.5.3 添加相关视图
视情况为广告视图添加logo，广告标签，不喜欢按钮等view。
示例代码：

```Objective-C
    // 添加视频视图
    [_customview addSubview:self.relatedView.videoAdView];
    // 添加logo视图
    self.relatedView.logoImageView.frame = CGRectZero;
    [_customview addSubview:self.relatedView.logoImageView];
    // 添加dislike按钮
    self.relatedView.dislikeButton.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame) - 20, CGRectGetMaxY(_infoLabel.frame)+5, 24, 20);
    [_customview addSubview:self.relatedView.dislikeButton];
    // 添加广告标签
    self.relatedView.adLabel.frame = CGRectZero;
    [_customview addSubview:self.relatedView.adLabel];
```
    
##### 2.2.5.4 广告数据获取后，更新View并注册可点击的View

在用户获取到 WMNativeAd 广告数据后，如有需要可以注册绑定点击的 View，包含图片、按钮等等。

WMNativeAd 类提供了如下方法，供开发者使用处理不同的事件响应；使用该方法时，请设置 WMNativeAd的代理属性id<WMNativeAdDelegate> delegate；同时需要设置rootViewController，广告位展示落地页通过rootviewController进行跳转。具体可以参考 SDK Demo里的例子

说明：WMNativeAd注册view具体点击事件（跳转广告页，下载，打电话；具体事件类型来自 WMNativeAd 请求获得的数据）行为由 SDK 控制



示例代码：

```Objective-C
- (void)nativeAdDidLoad:(WMNativeAd *)nativeAd {
    self.infoLabel.text = nativeAd.data.AdTitle;
    WMMaterialMeta *adMeta = nativeAd.data;
    CGFloat contentWidth = CGRectGetWidth(_customview.frame) - 20;
    WMImage *image = adMeta.imageAry.firstObject;
    const CGFloat imageHeight = contentWidth * (image.height / image.width);
    CGRect rect = CGRectMake(10, CGRectGetMaxY(_actionButton.frame) + 5, contentWidth, imageHeight);
    self.relatedView.logoImageView.frame = CGRectMake(CGRectGetMaxX(rect) - 15 , CGRectGetMaxY(rect) - 15, 15, 15);
    self.relatedView.adLabel.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) - 14, 26, 14);
    
    // imageMode来决定是否展示视频
    if (adMeta.imageMode == WMFeedVideoAdModeImage) {
        self.imageView.hidden = YES;
        self.relatedView.videoAdView.hidden = NO;
        self.relatedView.videoAdView.frame = rect;
        [self.relatedView refeshData:nativeAd];
    } else {
        self.imageView.hidden = NO;
        self.relatedView.videoAdView.hidden = YES;
        if (adMeta.imageAry.count > 0) {
            if (image.imageURL.length > 0) {
                self.imageView.frame = rect;
                [self.imageView setImageWithURL:[NSURL URLWithString:image.imageURL] placeholderImage:nil];
            }
        }
    }
 
    
    // Register UIView with the native ad; the whole UIView will be clickable.
    [nativeAd registerContainer:self.customview withClickableViews:@[self.infoLabel, self.actionButton]];
}

- (void)nativeAd:(WMNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {

}

- (void)nativeAdDidClick:(WMNativeAd *)nativeAd withView:(UIView *)view {
    NSString *str = NSStringFromClass([view class]);
    NSString *info = [NSString stringWithFormat:@"点击了 %@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"广告" message:info delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    [alert show];
}

- (void)nativeAdDidBecomeVisible:(WMNativeAd *)nativeAd {
}
```

##### 2.2.5.5 在 WMNativeAd 的 delegate 中处理各种回调协议方法

WMNativeAd 的 delegate 里可以处理几种代理方法，参见上面的示例代码

在回调代理方法里面我们可以处理注册视图点击、广告可见回调并加载广告错误等信息


### 2.3 信息流广告(WMNativeAdsManager)

+ **类型说明：** 信息流广告即普通 feed 流广告，是在feed流场景下的原生广告。
+ **使用说明：** 在SDK里只需要使用 WMNativeAdsManager 就可以获取信息流广告。SDK 提供信息流广告的数据绑定、点击事件的上报，用户可自行定义信息流广告展示形态与布局

#### 2.3.1 WMNativeAdsManager接口说明

WMNativeAdsManager 类可以一次请求获取多个广告数据，其对象声明如下：

```Objective-C

@interface WMNativeAdsManager : NSObject

@property (nonatomic, strong, nullable) WMAdSlot *adslot;
@property (nonatomic, strong, nullable) NSArray<WMNativeAd *> *data;
/// 广告位加载展示响应的代理回调，可以设置为遵循<WMNativeAdDelegate>的任何类型，不限于Viewcontroller
@property (nonatomic, weak, nullable) id<WMNativeAdsManagerDelegate> delegate;

- (instancetype)initWithSlot:(WMAdSlot * _Nullable) slot;

/**
 请求广告素材数量，建议不超过3个，
 一次最多不超过10个
 @param count 最多广告返回的广告素材的数量
 */
- (void)loadAdDataWithCount:(NSInteger)count;

@end
```

#### 2.3.1.1 实例说明

使用方法类似 WMNativeAd，初始化 WMNativeAdsManager 对象之后，设置好 WMAdSlot，通过loadAdDataWithCount: 方法来获取一组广告数据，其中loadAdDataWithCount: 方法能够根据 count 次数请求数据，数据获取后，同样通过 delegate 来处理回调参见下面代码示例：

```Objective-C
- (void)loadNativeAds {
    WMNativeAdsManager *nad = [WMNativeAdsManager new];
    WMAdSlot *slot1 = [[WMAdSlot alloc] init];
    slot1.ID = @"900480107";
    slot1.AdType = WMAdSlotAdTypeFeed;
    slot1.position = WMAdSlotPositionTop;
    slot1.imgSize = [WMSize sizeBy:WMProposalSize_Feed690_388];
    slot1.isSupportDeepLink = YES;
    nad.adslot = slot1;

    nad.delegate = self;
    self.adManager = nad;

    [nad loadAdData];
}

- (void)nativeAdsManagerSuccessToLoad:(WMNativeAdsManager *)adsManager nativeAds:(NSArray<WMNativeAd *> *_Nullable)nativeAdDataArray {
    NSString *info = [NSString stringWithFormat:@"获取了%lu条广告", nativeAdDataArray.count];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"广告" message:info delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    for (WMNativeAd *model in nativeAdDataArray) {
        NSUInteger index = rand() % dataSources.count;
        [dataSources insertObject:model atIndex:index];
    }
    self.dataSource = [dataSources copy];
    
    [self.tableView reloadData];
}

- (void)nativeAdsManager:(WMNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}
```
WMNativeAdsManager请求结果可获取到一组WMNativeAd，每一个WMNativeAd实则对应一条广告位。WMNativeAd需要按照自身用法，注册视图、设置delegate和rootviewController，请参考原生广告。


```Objective-C
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // For ad cells just as the ad cell provider, for normal cells do whatever you would do.
    BOOL isVideoCell = NO;
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[WMNativeAd class]]) {
        WMNativeAd *nativeAd = (WMNativeAd *)model;
        nativeAd.rootViewController = self;
        nativeAd.delegate = self;
        UITableViewCell<WMDFeedCellProtocol> *cell = nil;
        if (nativeAd.data.imageMode == WMFeedADModeSmallImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMDFeedAdLeftTableViewCell" forIndexPath:indexPath];
        } else if (nativeAd.data.imageMode == WMFeedADModeLargeImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMDFeedAdLargeTableViewCell" forIndexPath:indexPath];
        } else if (nativeAd.data.imageMode == WMFeedADModeGroupImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMDFeedAdGroupTableViewCell" forIndexPath:indexPath];
        } else if (nativeAd.data.imageMode == WMFeedVideoAdModeImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMDFeedVideoAdTableViewCell" forIndexPath:indexPath];
            // 设置代理，用于监听播放状态
            isVideoCell = YES;
        }
        
        WMInteractionType type = nativeAd.data.interactionType;
        if (cell) {
            [cell refreshUIWithModel:nativeAd];
            if (isVideoCell) {
                WMDFeedVideoAdTableViewCell *videoCell = (WMDFeedVideoAdTableViewCell *)cell;
                videoCell.nativeAdRelatedView.videoAdView.delegate = self;
                [nativeAd registerContainer:videoCell withClickableViews:@[videoCell.creativeButton]];
            } else {
                if (type == WMInteractionTypeDownload) {
                    [cell.customBtn setTitle:@"点击下载" forState:UIControlStateNormal];
                    [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
                } else if (type == WMInteractionTypePhone) {
                    [cell.customBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
                    [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
                } else if (type == WMInteractionTypeURL) {
                    [cell.customBtn setTitle:@"外部拉起" forState:UIControlStateNormal];
                    [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
                } else if (type == WMInteractionTypePage) {
                    [cell.customBtn setTitle:@"内部拉起" forState:UIControlStateNormal];
                    [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
                } else {
                    [cell.customBtn setTitle:@"无点击" forState:UIControlStateNormal];
                }
            }
            return cell;
        }
    }
    NSString *text = [NSString stringWithFormat:@"%@", model];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = text;
    return cell;
}
```
**从V1.9.5之前（< 1.9.5）升级到1.9.5后续版本（>=1.9.5）的开发者请仔细阅读本段，新接入请略过。在1.9.5之前（< 1.9.5）版本中，需要使用继承自WMTableViewCell 的 UITableViewCell来实现feed流广告，并且只适用于UITableView中展示信息流。WMTableViewCell提供了广告数据 WMMaterialMeta 并能够帮助在cell里注册用户自定义的事件。在1.9.5后续版本（>=1.9.5）中，可直接使用WMNativeAd替代WMTableViewCell的相关功能，获取视图组件部分可以参考WMNativeAdRelatedView**  

### 2.4 原生banner广告
+ **类型说明：**原生banner广告是为满足媒体多元化需求而开发的一种原生广告。
+ **使用说明：**SDK可提供数据绑定、点击事件的上报、响应回调，开发者进行自渲染，接入方式同原生广告相同。不同点在于，slot的AdType类型需要设置为 WMAdSlotAdTypeBanner，示例如下。具体可参考Demo中WMDnNativeBannerViewController部分示例代码

```Objective-C
- (void)loadNativeAd {
    
    if (!self.nativeAd) {
        WMSize *imgSize1 = [[WMSize alloc] init];
        imgSize1.width = 1080;
        imgSize1.height = 1920;
        
        WMAdSlot *slot1 = [[WMAdSlot alloc] init];
        slot1.ID = self.viewModel.slotID;
        slot1.AdType = WMAdSlotAdTypeBanner;
        slot1.position = WMAdSlotPositionTop;
        slot1.imgSize = imgSize1;
        slot1.isSupportDeepLink = YES;
        slot1.isOriginAd = YES;
        
        WMNativeAd *nad = [WMNativeAd new];
        nad.adslot = slot1;
        nad.rootViewController = self;
        nad.delegate = self;
        self.nativeAd = nad;
        
        self.dislikeButton = self.relatedView.dislikeButton;
        [self.view addSubview:self.dislikeButton];
        
        self.wmLogoIcon = self.relatedView.logoImageView;
    }
    [self.nativeAd loadAdData];
}
```
### 2.5 原生插屏广告
+ **类型说明：**原生插屏广告是为满足媒体多元化需求而开发的一种原生广告。
+  **使用说明：**SDK可提供数据绑定、点击事件的上报、响应回调，开发者进行自渲染，接入方式同原生广告相同。不同点在于，slot的AdType类型需要设置为 WMAdSlotAdTypeInterstitial，示例如下。具体可参考Demo中WMDNativeInterstitialViewController部分示例代码

```Objective-C
- (void)loadNativeAd {
    WMSize *imgSize1 = [[WMSize alloc] init];
    imgSize1.width = 1080;
    imgSize1.height = 1920;
    
    WMAdSlot *slot1 = [[WMAdSlot alloc] init];
    slot1.ID = self.viewModel.slotID;
    slot1.AdType = WMAdSlotAdTypeInterstitial;
    slot1.position = WMAdSlotPositionTop;
    slot1.imgSize = imgSize1;
    slot1.isSupportDeepLink = YES;
    slot1.isOriginAd = YES;
    
    WMNativeAd *nad = [WMNativeAd new];
    nad.adslot = slot1;
    nad.rootViewController = self;
    nad.delegate = self;
    self.nativeAd = nad;
    [nad loadAdData];
}
```

### 2.6 视频广告(WMVideoAdView)

+ **类型说明：**视频广告是原生广告的一种形式，网盟 SDK 提供视频播放视图 WMVideoAdView，开发只要参照信息流广告接入即可。
+ **使用说明：**WMVideoAdView 提供了 play、pause、currentPlayTime 等方法，开发者可用于在信息流中实现划入屏幕自动播放，划出屏幕暂停，点击传入已播放时间用于续播等。

#### 2.6.1 WMVideoAdView接口说明

```Objective-C
/**
 控制网盟视频播放器
 */
@protocol WMVideoEngine <NSObject>

/**
 开始播放
 */
- (void)play;

/**
 暂停播放
 */
- (void)pause;

/**
 获取当前已播放时间
 */
- (CGFloat)currentPlayTime;

/**
 设置是否静音
 */
- (void)setMute:(Boolean)isMute;

@end

@protocol WMVideoAdViewDelegate;

@interface WMVideoAdView : UIView<WMPlayerDelegate, WMVideoEngine>

@property (nonatomic, weak, nullable) id<WMVideoAdViewDelegate> delegate;

/// 广告位展示落地页ViewController的rootviewController，必传参数
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

/**
 materialMeta 物料信息
 */
@property (nonatomic, strong, readwrite, nullable) WMMaterialMeta *materialMeta;

- (instancetype)init;

- (instancetype)initWithMaterial:(WMMaterialMeta *)materialMeta;

@end
```

#### 2.6.2 WMVideoAdView回调说明

```Objective-C
@protocol WMVideoAdViewDelegate <NSObject>

@optional
/**
 videoAdView 加载失败

 @param videoAdView 当前展示的 videoAdView 视图
 @param error 错误原因
 */
- (void)videoAdView:(WMVideoAdView *)videoAdView didLoadFailWithError:(NSError *_Nullable)error;

/**
 videoAdView 播放状态改变

 @param videoAdView 当前展示的 videoAdView 视图
 @param playerState 当前播放完成
 */
- (void)videoAdView:(WMVideoAdView *)videoAdView stateDidChanged:(WMPlayerPlayState)playerState;

/**
 videoAdView 播放结束

 @param videoAdView 当前展示的 videoAdView 视图
 */
- (void)playerDidPlayFinish:(WMVideoAdView *)videoAdView;

@end
```
#### 2.6.3 实例
```Objective-C
self.videoAdView = [[WMVideoAdView alloc] init];
self.videoAdView.materialMeta = (WMMaterialMeta *)self.material;
self.videoAdView.rootViewController = self;
[self addSubview:self.videoAdView];


```

### 2.7 Banner广告(WMBannerAdViewDelegate)

直接调用loadAdData方法

方法声明：

``` Objective-C
-(void)loadAdData;
```

#### 2.7.1  WMBannerAdViewDelegate接口说明

```Objective-C
/**
 bannerAdView 广告位加载成功

 @param bannerAdView 视图
 @param nativeAd 内部使用的NativeAd
 */
- (void)bannerAdViewDidLoad:(WMBannerAdView *)bannerAdView WithAdmodel:(WMNativeAd *)nativeAd;

/**
 bannerAdView 广告位展示新的广告

 @param bannerAdView 当前展示的Banner视图
 @param nativeAd 内部使用的NativeAd
 */
- (void)bannerAdViewDidBecomVisible:(WMBannerAdView *)bannerAdView WithAdmodel:(WMNativeAd *)nativeAd;

/**
 bannerAdView 广告位点击

 @param bannerAdView 当前展示的Banner视图
 @param nativeAd 内部使用的NativeAd
 */
- (void)bannerAdViewDidClick:(WMBannerAdView *)bannerAdView WithAdmodel:(WMNativeAd *)nativeAd;

/**
 bannerAdView 广告位发生错误

 @param bannerAdView 当前展示的Banner视图
 @param error 错误原因
 */
- (void)bannerAdView:(WMBannerAdView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error;

/**
 bannerAdView 广告位点击不喜欢

 @param bannerAdView 当前展示的Banner视图
 @param filterwords 选择不喜欢理由
 */
- (void)bannerAdView:(WMBannerAdView *)bannerAdView dislikeWithReason:(NSArray<WMDislikeWords *> *_Nullable)filterwords;

@end
```

#### 2.7.2 接口实例

+ 1. 在需要展示banner广告的viewcontroller中导入头文件

```Objective-C
#import <WMAdSDK/WMBannerAdView.h>
```

+ 2. 在viewcontroller相应的添加bannerview部分进行bannerview的初始化，加载，以及添加过程

```Objective-C
WMSize *size = [WMSize sizeBy:WMProposalSize_Banner600_150];
        self.bannerView = [[WMBannerAdView alloc] initWithSlotID:[WMDAdManager slotKey:WMDSlotKeyBannerTwoByOne] size:size rootViewController:self];
        [self.bannerView loadAdData];
        const CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);

        CGFloat bannerHeight = screenWidth * size.height / size.width;
        self.bannerView.frame = CGRectMake(0, 50, screenWidth, bannerHeight);
        self.bannerView.delegate = self;
        [self.view addSubview:self.bannerView];
```

其中，adsize 参数为客户端要展示的banner 图片的广告尺寸，需要尽量与头条联盟穿山甲平台申请的广告尺寸比例保持一致，如果不一致，会按照请求尺寸返回，但图片会被拉抻，无法保证展示效果。
3. 此时当网络加载完成之后会在bannerview 上展示相应的广告图片，相应的广告的点击事件以及上报处理事件已经在内部处理完成，若想添加额外的点击处理，可在下述delegate中添加
4. delegate回调处理：

```Objective-C
#pragma mark -  WMBannerAdViewDelegate implementation

- (void)bannerAdViewDidLoad:(WMBannerAdView * _Nonnull)bannerAdView WithAdmodel:(WMNativeAd *) nativeAd {
    NSLog(@"***********banner load**************");
    [self.refreshbutton setTitle:@"已刷新，再刷新" forState:UIControlStateNormal];
}

- (void)bannerAdViewDidBecomVisible:(WMBannerAdView *_Nonnull)bannerAdView WithAdmodel:(WMNativeAd *) nativeAd {

}

- (void)bannerAdViewDidClick:(WMBannerAdView *_Nonnull)bannerAdView WithAdmodel:(WMNativeAd *)nativeAd {

}

- (void)bannerAdView:(WMBannerAdView *_Nonnull)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {

}

- (void)bannerAdView:(WMBannerAdView *)bannerAdView dislikeWithReason:(NSArray<WMDislikeWords *> *)filterwords {
    [UIView animateWithDuration:0.25 animations:^{
        bannerAdView.alpha = 0;
    } completion:^(BOOL finished) {
        [bannerAdView removeFromSuperview];
        self.bannerView = nil;
    }];
}

```

### 2.8 开屏广告(WMSplashAdView)

+ **类型说明：**开屏广告主要是 APP 启动时展示的全屏广告视图，开发只要按照接入标准就能够展示设计好的视图。

#### 2.8.1 WMSplashAdView接口说明

```Objective-C
@interface WMSplashAdView : UIView
/**
 开屏广告位 id
 */
@property (nonatomic, copy, readonly, nonnull) NSString *slotID;

/**
 允许最大的加载超时时间, 默认0.5s, 单位s
 */
@property (nonatomic, assign) NSTimeInterval tolerateTimeout;

/**
 开屏启动的 状态回调
 */
@property (nonatomic, weak, nullable) id<WMSplashAdDelegate> delegate;

/*
 广告位展示落地页ViewController的rootviewController，必传参数
 */
@property (nonatomic, weak) UIViewController *rootViewController;

/**
 开屏数据是否已经加载完成
 */
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;
- (instancetype)initWithSlotID:(NSString *)slotID frame:(CGRect)frame;

/**
 初始化开屏视图后需要主动 加载数据
 */
- (void)loadAdData;
@end
```

#### 2.8.2 WMSplashAdView回调说明

```Objective-C
@protocol WMSplashAdDelegate <NSObject>

@optional
/**
 点击开屏广告 回调该函数， 期间可能调起 AppStore ThirdApp WebView etc.
 - Parameter splashAd: 产生该事件的 SplashView 对象.
 */
- (void)splashAdDidClick:(WMSplashAdView *)splashAd;

/**
    关闭开屏广告， {点击广告， 点击跳过，超时}
 - Parameter splashAd: 产生该事件的 SplashView 对象.
 */
- (void)splashAdDidClose:(WMSplashAdView *)splashAd;

/**
   splashAd 广告将要消失， 用户点击 {跳过 超时}
 - Parameter splashAd: 产生该事件的 SplashView 对象.
 */
- (void)splashAdWillClose:(WMSplashAdView *)splashAd;

/**
 splashAd 广告加载成功
 - Parameter splashAd: 产生该事件的 SplashView 对象.
 */
- (void)splashAdDidLoad:(WMSplashAdView *)splashAd;

/**
 splashAd 加载失败

 - Parameter splashAd: 产生该事件的 SplashView 对象.
 - Parameter error: 包含详细是失败信息.
 */
- (void)splashAd:(WMSplashAdView *)splashAd didFailWithError:(NSError *)error;

/**
 即将展示 开屏广告
 - Parameter splashAd: 产生该事件的 SplashView 对象.
 */
- (void)splashAdWillVisible:(WMSplashAdView *)splashAd;
@end
```

#### 2.8.3 实例

```Objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [WMAdSDKManager setAppID:[WMDAdManager appKey]];
    [WMAdSDKManager setIsPaidApp:NO];
    [WMAdSDKManager setLoglevel:WMAdSDKLogLevelDebug];

    CGRect frame = [UIScreen mainScreen].bounds;
    WMSplashAdView *splashView = [[WMSplashAdView alloc] initWithSlotID:@"900721489" frame:frame];
    splashView.delegate = self;
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    [splashView loadAdData];
    [keyWindow.rootViewController.view addSubview:splashView];
    splashView.rootViewController = keyWindow.rootViewController;

    return YES;
}

- (void)splashAdDidClose:(WMSplashAdView *)splashAd {
    [splashAd removeFromSuperview];
}

```

### 2.9 插屏广告(WMInterstitialAd)

+ **类型说明：**插屏广告主要是用户暂停某个操作时展示的全屏广告视图，开发只要按照接入标准就能够展示设计好的视图。

#### 2.9.1 WMInterstitialAd接口说明

```Objctive-C
@interface WMInterstitialAd : NSObject
@property (nonatomic, weak, nullable) id<WMInterstitialAdDelegate> delegate;
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;

/**
 初始化WMInterstitialAd

 @param slotID 代码位ID
 @param expectSize 自定义size,默认 600px * 400px
 @return WMInterstitialAd
 */
- (instancetype)initWithSlotID:(NSString *)slotID size:(WMSize *)expectSize NS_DESIGNATED_INITIALIZER;
- (void)loadAdData;
- (BOOL)showAdFromRootViewController:(nullable UIViewController *)rootViewController;
@end
```

#### 2.9.2 WMInterstitialAd回调说明

```Objctive-C
@protocol WMInterstitialAdDelegate <NSObject>

@optional
/**
    点击插屏广告 回调该函数， 期间可能调起 AppStore ThirdApp WebView etc.
 - Parameter interstitialAd: 产生该事件的 WMInterstitialAd 对象.
 */
- (void)interstitialAdDidClick:(WMInterstitialAd *)interstitialAd;

/**
    关闭插屏广告 回调改函数，   {点击广告， 点击关闭}
 - Parameter interstitialAd: 产生该事件的 WMInterstitialAd 对象.
 */
- (void)interstitialAdDidClose:(WMInterstitialAd *)interstitialAd;

/**
    WMInterstitialAd 广告将要消失， 用户点击关闭按钮

 - Parameter interstitialAd: 产生该事件的 WMInterstitialAd 对象.
 */
- (void)interstitialAdWillClose:(WMInterstitialAd *)interstitialAd;
* ****
* * /**
 WMInterstitialAd 广告加载成功

 - Parameter interstitialAd: 产生该事件的 WMInterstitialAd 对象.
 */
- (void)interstitialAdDidLoad:(WMInterstitialAd *)interstitialAd;

/**
  WMInterstitialAd 加载失败

 - Parameter interstitialAd: 产生该事件的 WMInterstitialAd 对象.
 - Parameter error: 包含详细是失败信息.
 */
- (void)interstitialAd:(WMInterstitialAd *)interstitialAd didFailWithError:(NSError *)error;


/**
   即将展示 插屏广告
 - Parameter interstitialAd: 产生该事件的 WMInterstitialAd 对象.
 */
- (void)interstitialAdWillVisible:(WMInterstitialAd *)interstitialAd;
@end
```

#### 2.9.3 实例

```Objctive-C
    self.interstitialAd = [[WMInterstitialAd alloc] initWithSlotID:@"900721489" size:[WMSize sizeBy:WMProposalSize_Interstitial600_900]];
    [self.interstitialAd loadAdData];
    [self.interstitialAd showAdFromRootViewController:self.navigationController];
```

### 2.10 激励视频(WMRewardedVideoAd)

+ **类型说明：**激励视频广告是一种全新的广告形式，用户可选择观看视频广告以换取有价物，例如虚拟货币、应用内物品和独家内容等等；这类广告的长度为 15-30 秒，不可跳过，且广告的结束画面会显示结束页面，引导用户进行后续动作。

#### 2.10.1 WMRewardedVideoAd接口说明

**每次需要生成新的WMRewardedVideoAd对象调用loadAdData方法请求最新激励视频，请勿重复使用本地缓存激励视频多次展示**

```Objctive-C
@interface WMRewardedVideoAd : NSObject

@property (nonatomic, weak, nullable) id<WMRewardedVideoAdDelegate> delegate;
/**
 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
 */
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;

- (instancetype)initWithSlotID:(NSString *)slotID rewardedVideoModel:(WMRewardedVideoModel *)model;
- (void)loadAdData;
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;

@end
```

#### 2.10.2 WMRewardedVideoAd回调说明

```Objective-C
@protocol WMRewardedVideoAdDelegate <NSObject>

@optional

/**
 rewardedVideoAd 激励视频广告物料加载成功
 @param rewardedVideoAd 当前激励视频素材
 */
- (void)rewardedVideoAdDidLoad:(WMRewardedVideoAd *)rewardedVideoAd;

/**
 rewardedVideoAd 激励视频广告视频加载成功
 @param rewardedVideoAd 当前激励视频素材
 */
- (void)rewardedVideoAdVideoDidLoad:(WMRewardedVideoAd 
*)rewardedVideoAd;

/**
 rewardedVideoAd 广告位即将展示
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)rewardedVideoAdWillVisible:(WMRewardedVideoAd *)rewardedVideoAd;

/**
 rewardedVideoAd 激励视频广告关闭
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)rewardedVideoAdDidClose:(WMRewardedVideoAd *)rewardedVideoAd;

/**
 rewardedVideoAd 激励视频广告点击下载
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)rewardedVideoAdDidClickDownload:(WMRewardedVideoAd *)rewardedVideoAd;

/**
 rewardedVideoAd 激励视频广告素材加载失败
 @param rewardedVideoAd 当前激励视频对象
 @param error 错误对象
 */
- (void)rewardedVideoAd:(WMRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error;

/**
 rewardedVideoAd 激励视频广告播放完成或发生错误
 @param rewardedVideoAd 当前激励视频对象
 @param error 错误对象
 */
- (void)rewardedVideoAdDidPlayFinish:(WMRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error;

/**
 rewardedVideoAd publisher 终端返回 20000
 @param rewardedVideoAd 当前激励视频对象
 @param verify 有效性验证结果
 */
- (void)rewardedVideoAdServerRewardDidSucceed:(WMRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify;

/**
 rewardedVideoAd publisher 终端返回非 20000
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)rewardedVideoAdServerRewardDidFail:(WMRewardedVideoAd *)rewardedVideoAd;

@end
```

#### 2.10.3 实例

```Objctive-C
    WMRewardedVideoModel *model = [[WMRewardedVideoModel alloc] init];
    model.userId = @"xxx"; // 接入方填入
    model.isShowDownloadBar = YES; // 控制视频播放过程中是否展示下载Bar，默认YES
    self.rewardedVideoAd = [[WMRewardedVideoAd alloc] initWithSlotID:self.viewModel.slotID rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
```

#### 2.10.4 WMRewardedVideoModel

```Objctive-C
@interface WMRewardedVideoModel : NSObject

// 第三方游戏 user_id 标识，必传 (主要是用于奖励判定过程中，服务器到服务器回调透传的参数，是游戏对用户的唯一标识；非服务器回调模式在视频播完回调时也会透传给游戏应用)
@property (nonatomic, copy) NSString *userId;

// 奖励名称，可选
@property (nonatomic, copy) NSString *rewardName;

// 奖励数量，可选
@property (nonatomic, assign) NSInteger rewardAmount;

// 序列化后的字符串，可选
@property (nonatomic, copy) NSString *extra;

// 是否展示下载 Bar，默认 YES
@property (nonatomic, assign) BOOL isShowDownloadBar;

@end
```

#### 2.10.5 服务器到服务器回调

服务器到服务器回调让您判定是否提供奖励给观看广告的用户。当用户成功看完广告时，您可以在头条媒体平台配置从头条服务器到您自己的服务器的回调链接，以通知您用户完成了操作。

##### 回调方式说明

头条服务器会以 GET 方式请求第三方服务的回调链接，并拼接以下参数回传：

`user_id=%s&trans_id=%s&reward_name=%s&reward_amount=%d&extra=%s&sign=%s`

| 字段定义| 字段名称| 字段类型| 备注 |
| --- | --- | --- | --- |
| sign | 签名 | string | 签名 |
| user_id | 用户id | string | 调用SDK透传，应用对用户的唯一标识 |
| trans_id | 交易id | string | 完成观看的唯一交易ID |
| reward_amount | 奖励数量 | int | 媒体平台配置或调用SDK传入 |
| reward_name | 奖励名称 | string | 媒体平台配置或调用SDK传入 |
| extra | Extra | string | 调用SDK传入并透传，如无需要则为空 |

##### 签名生成方式

appSecurityKey: 您在头条媒体平台新建奖励视频代码位获取到的密钥
transId：交易id
sign = sha256(appSecurityKey:transId)

Python 示例：

```Python
import hashlib

if __name__ == "__main__":
    trans_id = "6FEB23ACB0374985A2A52D282EDD5361u6643"
    app_security_key = "7ca31ab0a59d69a42dd8abc7cf2d8fbd"
    check_sign_raw = "%s:%s" % (app_security_key, trans_id)
    sign = hashlib.sha256(check_sign_raw).hexdigest()
```

##### 返回约定

返回 json 数据，字段如下：

| 字段定义 | 字段名称 | 字段类型 | 备注 |
| --- | --- | --- | --- |
| isValid |	校验结果 | bool | 判定结果，是否发放奖励 |

示例：

```
{
    "isValid": true
}
```

#### 2.10.6 AdMob通过CustomEvent Adapter方式聚合激励视频
通过AdMob聚合激励视频有两种方式，第一种是通过AdMob广告联盟方式，第二种是通过CustomEvent Adapter方式聚合。目前今日头条暂支持第二种方式，需要您配置CustomEvent并实现CustomEvent Adapter。请参考[Rewarded Video Adapters](https://developers.google.com/admob/ios/rewarded-video-adapters?hl=zh-CN)官网指南

请求激励视频方式请参考[Rewarded Video](https://developers.google.com/admob/ios/rewarded-video?hl=zh-CN)官方指南

广告测试请参考[Test Ads](https://developers.google.com/admob/ios/test-ads?hl=zh-CN#enable_test_devices)

为了接入少踩坑值，请注意的是有以下几点：

+ **配置CustomEvent时，Class Name与实现的Adapter类名要保持统一，否则无法调起adapter**
+ **iOS simulator默认是 Enable test device类型设备，只能获取到Google Test Ads，无法取得今日头条测试广告，若要测试今日头条广告，请使用iOS真机设备，并且不要添加成AdMob TestDevices**

### 2.11 全屏视频(WMFullscreenVideoAd)

+ **类型说明：** 全屏视频是全屏展示视频广告的广告形式，用户可选择在不同场景插入对应广告；这类广告的长度为 15-30 秒，可以跳过，且广告会显示结束endCard页面，引导用户进行后续动作。

#### 2.11.1 WMFullscreenVideoAd接口说明
**每次需要生成新的WMFullscreenVideoAd对象调用loadAdData方法请求最新激励视频，请勿重复使用本地缓存激励视频多次展示.**

```Objctive-C
@interface WMRewardedVideoAd : NSObject
@property (nonatomic, weak, nullable) id<WMFullscreenVideoAdDelegate> delegate;
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;

/**
 初始化 WMFullscreenVideoAd
 
 @param slotID 代码位ID
 @return WMFullscreenVideoAd
 */
- (instancetype)initWithSlotID:(NSString *)slotID;

/**
 加载数据
 */
- (void)loadAdData;

/**
 展示视频广告

 @param rootViewController 展示视频的根视图
 @return 是否成功展示
 */
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;

@end
```

#### 2.11.2 WMFullscreenVideoAd回调说明

```Objective-C
/**
 视频广告物料加载成功
 */
- (void)fullscreenVideoMaterialMetaAdDidLoad:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告视频素材缓存成功
 */
- (void)fullscreenVideoAdVideoDataDidLoad:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 广告位即将展示
 */
- (void)fullscreenVideoAdWillVisible:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告关闭
 */
- (void)fullscreenVideoAdDidClose:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告点击下载
 */
- (void)fullscreenVideoAdDidClickDownload:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告素材加载失败
 
 @param fullscreenVideoAd 当前视频对象
 @param error 错误对象
 */
- (void)fullscreenVideoAd:(WMFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error;

/**
 视频广告播放完成或发生错误
 
 @param fullscreenVideoAd 当前视频对象
 @param error 错误对象
 */
- (void)fullscreenVideoAdDidPlayFinish:(WMFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error;

/**
 视频广告播放点击跳过

 @param fullscreenVideoAd 当前视频对象
 */
- (void)fullscreenVideoAdDidClickSkip:(WMFullscreenVideoAd *)fullscreenVideoAd;

@end
```
#### 2.11.3 实例

```Objctive-C
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#warning 每次请求数据 需要重新创建一个对应的 WMFullscreenVideoAd管理,不可使用同一条重复请求数据.
    self.fullscreenVideoAd = [[WMFullscreenVideoAd alloc] initWithSlotID:self.viewModel.slotID];
    self.fullscreenVideoAd.delegate = self;
    [self.fullscreenVideoAd loadAdData];
}

// 视频数据加载完成后可以选择时机展示,保证视频流畅性
- (void)fullscreenVideoAdVideoDataDidLoad:(WMFullscreenVideoAd *)fullscreenVideoAd {
    // 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
    [self.fullscreenVideoAd showAdFromRootViewController:self.navigationController];
}

```



## 附录

### SDK错误码

主要在数据获取异常在回调方法中处理

```Objective-C
// WMNativeAd广告加载失败后的回调方法，在delegate中处理

- (void)nativeAd:(WMNativeAd *)nativeAd didFailWithError:(NSError * _Nullable)error;

// banner广告加载失败后的回调方法，在delegate中处理

- (void)bannerAdView:(WMBannerAdView *)bannerAdView didLoadFailWithError:(NSError * _Nullable)error

```

下面是各种error code的值

```Objective-C
    WMErrorCodeNOAdError        = -3,     // 解析的数据没有广告
    WMErrorCodeNetError         = -2,     // 网络请求失败
    WMErrorCodeParseError       = -1,     // 解析失败
    WMErrorCodeParamEroor       = 10001,  // 参数错误
    WMErrorCodeTimeout          = 10002,
    WMErrorCodeSuccess          = 20000,
    WMErrorCodeNOAD             = 20001,  // 没有广告
    WMErrorCodeContentType      = 40000,  // http conent_type错误
    WMErrorCodeRequestPBError   = 40001,  // http request pb错误
    WMErrorCodeAppEmpty         = 40002,  // 请求app不能为空
    WMErrorCodeWapEMpty         = 40003,  // 请求wap不能为空
    WMErrorCodeAdSlotEmpty      = 40004,  // 缺少广告位描述
    WMErrorCodeAdSlotSizeEmpty  = 40005,  // 广告位尺寸 不合法
    WMErrorCodeAdSlotIDError    = 40006,  // 广告位 ID 不合法
    WMErrorCodeAdCountError     = 40007,  // 请求广告数量 错误
    WMErrorCodeSysError         = 50001   // 广告服务器错误
    服务器错误码
    ERROR_CODE_SIZE_ERROR     		      = 40008 //没有填写素材尺寸，或者素材尺寸大于 10000
    ERROR_CODE_UnionAdSiteId_ERROR		  = 40009 //媒体是空，或者没有运行
    ERROR_CODE_UnionRequestInvalid_ERROR  = 40015 //媒体已经被通知整改三次以上,进行校验,如果字段非法,则不返回广告
    ERROR_CODE_UnionAppSiteRel_ERROR      = 40016 //请求的 appid 与媒体平台的 appid 不一致 
    									  = 40018 //SDK包名与穿山甲配置包名不一致

```


### FAQ
1. 媒体平台配置了只出小图和组图，为什么会返回大图？（类似返回素材类型和媒体平台不符问题）

	答：先check下接入版本，1.2.0及之前版本的SDK对素材类型解析有问题，如果版本问题建议升级；

2. iOS的广告页面在我们app内打开，没有办法关闭或返回。

	答：无法返回是由于 您的主页ViewController 隐藏了NavigationBar；

3.	发现头条 SDK里 WMWebViewController 类 TTRUIWebView 类有内存泄漏。

	答：是系统的问题， UIWebView 一致有泄漏， 我们后续会考虑用 WKWebView 替换
	
4. 激励视频播放可以设置orientation吗?

	答：orientation由sdk读取当前屏幕状态 ,不需要开发者设置，后端会返回相应的广告素材（横版素材、竖版素材)
	
5. userId 是什么?

	答 : 是第三方游戏 user_id 标识. 主要是用于奖励判定过程中，服务器到服务器回调透传的参数，是游戏对用户的唯一标识；非服务器回调模式在视频播完回调时也会透传给游戏应用,这时可传空字符串,不能传nil;

6. iOS集成的包大小是多少?

	答	: 根据我们demo打包后的计算为580k左右. 但是具体大小会根据导入的功能有所差别. 实际情况以集成后的包大小为主.

7. 激励视频和全屏视频中物料加载成功回调和广告视频素材缓存成功回调有什么区别? 

	答  : 物料加载成功是指广告物料的素材加载完成,这时就可以展示广告了,但是由于视频是单独线程加载的,这时视频数据是没有缓存好的,如果网络不好的情况下播放视频类型是实时加载数据,可能会有卡顿现象. 为了更好的播放体验,建议在广告视频素材缓存成功时展示广告.

8. 接入原生广告后页面元素怎么添加啊? 为什么添加了关闭按钮点击没有响应? 为什么视频视图不播放?

	答	: 建议原生广告的视图形式参考我们Feed写法,我们提供的WMNativeAdRelatedView中,封装了广告展示的必要视图,按需要依次添加进相应的父控件中就可以了. 关于没有响应的问题,记得初始化WMNativeAdRelatedView,以及在数据加载成功后,及时调用对象中的refreshData方法更新数据刷新视图.
			
