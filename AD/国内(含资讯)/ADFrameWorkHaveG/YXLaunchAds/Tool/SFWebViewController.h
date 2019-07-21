//
//  SFWebViewController.h
//  TestAdA
//
//  Created by lurich on 2019/4/25.
//  Copyright © 2019 YX. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import "YXLaunchAdConst.h"
#import "YXAdSDKManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SFWebViewDelegate <NSObject>

@optional
- (void)customWebViewClicked;

@end
API_AVAILABLE(ios(9.0))
@interface SFWebViewController : SFSafariViewController

@property(nonatomic,assign) id<SFWebViewDelegate> sfwebdelegate;


@end

NS_ASSUME_NONNULL_END
