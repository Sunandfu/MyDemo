//
//  WMDActionCellView.m
//  WMAdSDKDemo
//
//  Created by carl on 2017/7/29.
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import "WMDActionCellView.h"

@class WMDPlainTitleActionModel;

@implementation WMDPlainTitleActionModel

@end

@implementation WMDActionModel (WMDModelFactory)

+ (instancetype)plainTitleActionModel:(NSString *)title action:(ActionCommandBlock)action {
    WMDPlainTitleActionModel *model = [WMDPlainTitleActionModel new];
    model.title = title;
    model.action = [action copy];
    return model;
}

@end

@interface WMDActionCellView ()
@property (nonatomic, strong) WMDPlainTitleActionModel *model;
@end

@implementation WMDActionCellView

- (void)configWithModel:(WMDPlainTitleActionModel *)model {
    if ([model isKindOfClass:[WMDPlainTitleActionModel class]]) {
        self.model = model;
        self.textLabel.text = self.model.title;
    }
}

- (void)execute {
    if (self.model.action) {
        self.model.action();
    }
}

@end
