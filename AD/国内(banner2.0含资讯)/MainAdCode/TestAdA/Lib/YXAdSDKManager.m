//
//  YXAdSDKManager.m
//  LunchAd
//
//  Created by shuai on 2018/11/28.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXAdSDKManager.h"
#import "Network.h"

@implementation YXAdSDKManager

static YXAdSDKManager * manager = nil;

+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXAdSDKManager alloc]init];
    });
    return manager;
}
- (void)setUserDefault:(BOOL)userDefault{
    _userDefault = userDefault;
    if (userDefault) {
        UIView *webCusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 104, 33)];
        webCusView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        webCusView.autoresizesSubviews =YES;
        UILabel *label = [[UILabel alloc] initWithFrame:webCusView.bounds];
        label.text = @"会员去广告";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:255/255.0 green:205/255.0 blue:50/255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        [webCusView addSubview:label];
        [self setWebCustomView:webCusView];
        
        UIView *kpCusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 86, 27)];
        kpCusView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        kpCusView.autoresizesSubviews =YES;
        UILabel *kalabel = [[UILabel alloc] initWithFrame:kpCusView.bounds];
        kalabel.text = @"会员去广告";
        kalabel.font = [UIFont systemFontOfSize:13];
        kalabel.textColor = [UIColor colorWithRed:229/255.0 green:188/255.0 blue:74/255.0 alpha:1.0];
        kalabel.textAlignment = NSTextAlignmentCenter;
        [kpCusView addSubview:kalabel];
        [self setKpCustomView:kpCusView];
    }
}
- (void)setWebCustomView:(UIView *)webCustomView{
    _webCustomView = webCustomView;
}
- (void)setKpCustomView:(UIView *)kpCustomView{
    _kpCustomView = kpCustomView;
}
+ (void)addBlackList:(NSString*)media andTime:(NSInteger)day
{
    
    [Network blackListUrl:APIAddBlack andMedia:media andTime:day isAdd:YES];
}

+ (void)removeBlackList:(NSString *)media
{
    [Network blackListUrl:APIRemoveBlack andMedia:media andTime:0 isAdd:NO];
}
- (void)setCityCode:(NSString *)cityCode{
    _cityCode = cityCode;
    [[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:KeyADSDKCityCode];
}


@end
