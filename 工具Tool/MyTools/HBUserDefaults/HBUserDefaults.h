//
//  HBUserDefaults.h
//  HuiBeauty
//
//  Created by darren on 14-9-10.
//  Copyright (c) 2014年 BrooksWon. All rights reserved.
//

#import "PAPreferences.h"

//PAPreferences : https://github.com/dhennessy/PAPreferences/blob/master/README.md
//添加新属性时,需要先在头文件中添加@property,然后在Impletion文件中添加相应的@dynamic属性
//使用时直接用[HBUserDefaults sharedInstance]'dot syntax'(点属性)操作即可.

@interface HBUserDefaults : PAPreferences
//用户信息
@property (nonatomic,assign) NSString *userSessionId;//通行ID
@property (nonatomic,assign) NSString *realName;//用户名
@property (nonatomic,assign) NSString *userPhoneNum;//手机号
@property (nonatomic,assign) NSString *passWord;//登录密码
@property (nonatomic,assign) BOOL isLogin;//判断是否登录
@property (nonatomic,assign) NSString *company;//公司
@property (nonatomic,assign) NSString *address;//地址
@property (nonatomic,assign) NSString *cityName;//城市名

@property (nonatomic,assign) BOOL isRefresh;//解决连续两个页面需要刷新的问题
@property (nonatomic,assign) BOOL isRefreshPatch;//解决发货返回刷新的问题

@property (nonatomic,assign) BOOL isFirstLaunch;//是否第一个加载
@property (nonatomic,assign) NSString *province;
@property (nonatomic,assign) NSString *city;
@property (nonatomic,assign) NSString *provinceId;
@property (nonatomic,assign) NSString *cityId;
@property (nonatomic,assign) NSString *selectProvinceIndex;
@property (nonatomic,strong) NSArray *userSendScopeList;//配送地址
@property (nonatomic,strong) NSArray *goodsTypeArray;//商品类型

@end
