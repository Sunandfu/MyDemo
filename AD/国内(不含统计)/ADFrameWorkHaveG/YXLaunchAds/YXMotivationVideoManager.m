//
//  YXMotivationVideoManager.m
//  LunchAd
//
//  Created by shuai on 2018/11/29.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXMotivationVideoManager.h"

//#import <Tapjoy/Tapjoy.h>
#import "YXLaunchAdConst.h"

@interface YXMotivationVideoManager ()
//<TJPlacementDelegate>

@property (nonatomic,weak) UIViewController *showAdController;

//@property (nonatomic,strong) TJPlacement *p ;
@end

@implementation YXMotivationVideoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self videoSDK];
    }
    return self;
}
//
- (void)videoSDK
{
    //      设置成功和失败提醒
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(tjcConnectSuccess)
//                                                 name:TJC_CONNECT_SUCCESS
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(tjcConnectFail)
//                                                 name:TJC_CONNECT_FAILED
//                                               object:nil];
//
//    //打开 Tapjoy 调节模式
//    [Tapjoy setDebugEnabled:YX_DEBUG_MODE]; //Do not set this for any version of the app released to an app store
//
//
//    //当tapjoy连接时调用
//    [Tapjoy connect:@"ZTCXfY7SR1qCzfsHVzRfUAEBgbJqtKbbPhLQqUM1Bo42eWUzp61fGMi7iDzW"];
}

- (void)tjcConnectSuccess
{
    
}
- (void)tjcConnectFail
{
    
}

//-(void)openVideo:(UIViewController *)viewController{
//
//    self.showAdController = viewController;
//
//    if(_p.isContentReady) {
//        [_p showContentWithViewController:self.showAdController];
//    }
//    else {
//        YXLaunchAdLog(@"暂无视频");
//    }
//}
//
//- (void)loadVideoPlacementWithName:(NSString *)placement
//{
//    _p = [TJPlacement placementWithName:placement delegate:self ];
//
//
//    //当tapjoy连接时调用
//    [_p requestContent];
//}
//
//-(void)openVideo:(UIViewController*)viewController placementWithName:(nonnull NSString *)placement
//{
//
//
//}
//
//// Called when the SDK has made contact with Tapjoy's servers. It does not necessarily mean that any content is available.
//- (void)requestDidSucceed:(TJPlacement*)placement{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectSuccess)]) {
//        [self.delegate didConnectSuccess];
//    }
//}
//
//// Called when there was a problem during connecting Tapjoy servers.
//- (void)requestDidFail:(TJPlacement*)placement error:(NSError*)error{
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectFailed:)]) {
//        [self.delegate didConnectFailed:error];
//    }
//}
//
//// Called when the content is actually available to display.
//- (void)contentIsReady:(TJPlacement*)placement{
//
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(videoIsReadyToPlay)]) {
//        [self.delegate videoIsReadyToPlay];
//    }
//}
//
//// Called when the content is showed.
//- (void)contentDidAppear:(TJPlacement*)placement{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(videoContentDidAppear)]) {
//        [self.delegate videoContentDidAppear];
//    }
//}
//
//// Called when the content is dismissed.
//- (void)contentDidDisappear:(TJPlacement*)placement{
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(videoContentDidDisappear)]) {
//        [self.delegate videoContentDidDisappear];
//    }
//}





@end
