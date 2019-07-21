//
//  UnifiedNativeAdViewInTableViewViewController.h
//  GDTMobApp
//
//  Created by nimomeng on 2018/11/13.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnifiedNativeAdViewInTableViewViewController : UIViewController
@property (nonatomic) BOOL shouldMuteOnVideo;
@property (nonatomic) BOOL shouldPlayOnWWAN;
- (instancetype)initWithPlacementId:(NSString *)placementId;
@end

NS_ASSUME_NONNULL_END
