//
//  WMDActionCellDefine.h
//  WMAdSDKDemo
//
//  Created by carl on 2017/7/29.
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMDActionModel;
@class WMDPlainTitleActionModel;

typedef void(^ActionCommandBlock)(void);

@protocol WMDCommandProtocol <NSObject>
- (void)execute;
@end

@protocol WMDActionCellConfig <NSObject>

- (void)configWithModel:(WMDActionModel *)model;

@end

@interface WMDActionModel : NSObject
@property (nonatomic, copy) ActionCommandBlock action;
@end

