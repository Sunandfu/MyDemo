//
//  BaiduMapTools.h
//  baidumapTest
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBaiduMapTools : NSObject
/**单例*/
+(WJBaiduMapTools *)instance;

/**定位,能得到省市街道*/
- (void)startlocation:(BOOL)needaddress
      locationSuccess:(void(^)(double longitude,double latitude)) locationSuccess
       addressSuccess:(void(^)(double longitude,double latitude,BMKAddressComponent *address))addressSuccess;

/**停止定位*/
- (void)stoplocation;
@end
