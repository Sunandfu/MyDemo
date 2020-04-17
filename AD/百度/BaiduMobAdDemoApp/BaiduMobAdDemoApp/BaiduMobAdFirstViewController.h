//
//  BaiduMobAdFirstViewController.h
//  APIExampleApp
//
//  Created by jaygao on 11-10-26.
//  Copyright (c) 2011年 Baidu,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"

#define kBannerSize_20_3 @"3722589"
#define kBannerSize_3_2 @"3722694"
#define kBannerSize_7_3 @"3722704"
#define kBannerSize_2_1 @"3722709"

@interface BaiduMobAdFirstViewController : UIViewController<BaiduMobAdViewDelegate>
{
    BaiduMobAdView* sharedAdView;
}

- (void)startAdViewWithHeightScale:(CGFloat)scale
                         adUnitTag:(NSString *)adUnitTag;
@end



