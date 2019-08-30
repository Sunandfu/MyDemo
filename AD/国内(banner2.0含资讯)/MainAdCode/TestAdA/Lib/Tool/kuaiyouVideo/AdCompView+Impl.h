//
//  AdCompView+Impl.h
//  KuaiYouAdHello
//
//  Created by adview on 13-12-23.
//
//

#import "AdCompView.h"

#define ADCOMPVIEW_SIZE_320x50		CGSizeMake(320, 50)
#define ADCOMPVIEW_SIZE_480x44		CGSizeMake(480, 44)
#define ADCOMPVIEW_SIZE_300x250		CGSizeMake(300, 250)
#define ADCOMPVIEW_SIZE_480x60		CGSizeMake(480, 60)
#define ADCOMPVIEW_SIZE_728x90		CGSizeMake(728, 90)

#define ADCOMPVIEWADPLATTYPE_ADDIRECT		          0			//直投
#define ADCOMPVIEWADPLATTYPE_ADEXCHANGE               1         //交换
#define ADCOMPVIEWADPLATTYPE_SUIZONG		          2			//suizong
#define ADCOMPVIEWADPLATTYPE_IMMOB		              3			//Immob, server response limit
#define ADCOMPVIEWADPLATTYPE_INMOBI		              4         //inmobi
#define ADCOMPVIEWADPLATTYPE_ADUU			          5         //Aduu
#define ADCOMPVIEWADPLATTYPE_WQMOBILE		          6         //wq
#define ADCOMPVIEWADPLATTYPE_KOUDAI		              7         //koudai
#define ADCOMPVIEWADPLATTYPE_ADFILL                   8         //adfill
#define ADCOMPVIEWADPLATTYPE_ADVIEW                   9         //adview流量优化
#define ADCOMPVIEWADPLATTYPE_ADVIEWRTB                10        //adview RTB

@interface AdCompView (Impl)
/**
 * 按尺寸请求条广告
 */

+(AdCompView*) requestOfSize:(CGSize)size withDelegate:(id<AdCompViewDelegate>)delegate
              withAdPlatType:(int)adPlatType;
/**
 * 请求条广告，自动适配320x50或728x90
 */

+(AdCompView*) requestWithDelegate:(id<AdCompViewDelegate>)delegate
                    withAdPlatType:(int)adPlatType;

/**
 * 请求插屏广告
 */

+(AdCompView*) requestAdInstlWithDelegate:(id<AdCompViewDelegate>)delegate
                           withAdPlatType:(int)adPlatType;

/**
 * 请求开屏广告
 */
+(AdCompView*) requestSpreadActivityWithDelegate:(id<AdCompViewDelegate>)delegate
                                  withAdPlatType:(int)adPlatType;

/**
 * 所对应的SDK版本
 */
+(NSString*) sdkVersion;

/**
 * 展示插屏 给定一个UIViewController 用来放置插屏显示的位置
 */
- (BOOL)showWithRootViewController:(UIViewController*)rootViewController;

-(void) pauseRequestAd;
-(void) resumeRequestAd;

/**
 * 清理数据缓存
 */
- (void)clearCaches;

@end
