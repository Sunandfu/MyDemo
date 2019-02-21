//
//  WMDBaseExampleViewController.h
//  WMDemo
//
//  Created by carl on 2017/12/4.
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDExampleDefine.h"
#import <UIKit/UIKit.h>

@interface WMDBaseExampleViewController : UIViewController <WMDExampleViewControl>
@property (nonatomic, strong) id<WMDExampleViewModel> viewModel;
@end
