//
//  THPlayer.h
//  THPlayer
//
//  Created by inveno on 16/3/23.
//  Copyright © 2016年 inveno. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MediaPlayer;
@import AVFoundation;

//获取设备的物理宽高
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kTabBarHeight 49
#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]
#define kNavbarHeight ((kDeviceVersion>=7.0)? 64 :44 )

typedef NS_ENUM(NSInteger, UIHTPlayerSizeType) {
    UIHTPlayerSizeFullScreenType     = 0, //全屏
    UIHTPlayerSizeSmallScreenType    = 1,//小屏
    UIHTPlayerSizeDetailScreenType   = 2,//详情页面显示
    UIHTPlayerSizeRecoveryScreenType = 3//恢复大小
};

typedef NS_ENUM(NSInteger, UIHTPlayerStatusChangeType) {
    UIHTPlayerStatusLoadingType          = 0, //正在加载
    UIHTPlayerStatusReadyToPlayTyep      = 1,//开始播放
    UIHTPlayeStatusrLoadedTimeRangesType = 2//开始缓存
};

extern NSString *const kHTPlayerFinishedPlayNotificationKey; //播放完成通知
extern NSString *const kHTPlayerCloseVideoNotificationKey; //关闭播放视图通知
extern NSString *const kHTPlayerCloseDetailVideoNotificationKey; //关闭详情播放视图
extern NSString *const kHTPlayerFullScreenBtnNotificationKey;//全屏通知
extern NSString *const kHTPlayerPopDetailNotificationKey;//退出详情页面通知
//请求成功
typedef void (^PlayerStatusChange) (UIHTPlayerStatusChangeType status);
typedef void (^PlayerAnimateFinish) (void);

@interface HTPlayer : UIView

@property (strong, nonatomic)PlayerStatusChange status;//播放状态
//@property (strong, nonatomic)PlayerAnimateFinish playerAnimateFinish;//To cell 动画完成
@property(nonatomic,copy) NSString *videoURLStr;//播放地址
@property (assign, nonatomic)UIHTPlayerSizeType screenType;

- (id)initWithFrame:(CGRect)frame videoURLStr:(NSString *)videoURLStr;

- (void)play;
- (void)setPlayTitle:(NSString *)str;

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation;
-(void)reductionWithInterfaceOrientation:(UIView *)view;
-(void)toDetailScreen:(UIView *)view;
-(void)toSmallScreen;
-(void)releaseWMPlayer;
-(void)colseTheVideo:(UIButton *)sender;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com