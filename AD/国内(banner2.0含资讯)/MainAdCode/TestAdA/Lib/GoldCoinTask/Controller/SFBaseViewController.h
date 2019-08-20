//
//  SFBaseViewController.h
//  TestAdA
//
//  Created by lurich on 2019/8/12.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetTool.h"
#import "Network.h"
#import "YXLaunchAdConst.h"
#import "NSObject+SF_MJParse.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "YXLoading.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFBaseViewController : UIViewController

@property (nonatomic, copy) NSString *channelID;
@property (nonatomic, copy) NSString *vuid;

@end

NS_ASSUME_NONNULL_END
