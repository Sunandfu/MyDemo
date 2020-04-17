//
//  YXLaunchAdConfiguration.m
//  TestAdA
//
//  Created by lurich on 2019/7/22.
//  Copyright © 2019 YX. All rights reserved.
//

#import "SFNewsConfiguration.h"
#import "YXLaunchAdConst.h"

#pragma mark - 图片广告相关
@implementation SFNewsConfiguration

+ (instancetype)defaultConfiguration{
    static dispatch_once_t onceToken;
    static SFNewsConfiguration *configuration;
    dispatch_once(&onceToken, ^{
        configuration = [[SFNewsConfiguration alloc] init];
    });
    return configuration;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleFont = [UIFont systemFontOfSize:HFont(18) weight:UIFontWeightRegular];
        self.titleColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:0.85];
        self.fromFont = [UIFont systemFontOfSize:HFont(13) weight:UIFontWeightRegular];
        self.fromColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.85];
        self.cornerRadius = 0;
    }
    return self;
}
//- (void)setTitleFont:(UIFont *)titleFont{
//    _titleFont = titleFont;
//}


@end

