//
//  WMDActionCellView.h
//  WMAdSDKDemo
//
//  Created by carl on 2017/7/29.
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WMDActionCellDefine.h"

@interface WMDPlainTitleActionModel : WMDActionModel
@property (nonatomic, copy) NSString *title;
@end

@interface WMDActionModel (WMDModelFactory)
+ (instancetype)plainTitleActionModel:(NSString *)title action:(ActionCommandBlock)action;
@end

@interface WMDActionCellView : UITableViewCell <WMDActionCellConfig, WMDCommandProtocol>

@end
