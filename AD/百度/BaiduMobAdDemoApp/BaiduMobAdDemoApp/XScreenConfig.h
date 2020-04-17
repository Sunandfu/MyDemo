//
//  XScreenConfig.h
//  XAdSDKDevSample
//
//  Created by 吴晗 on 2017/12/17.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#ifndef XScreenConfig_h
#define XScreenConfig_h

#define kScreenWidth [[UIApplication sharedApplication]keyWindow].bounds.size.width
#define kScreenHeight [[UIApplication sharedApplication]keyWindow].bounds.size.height

#define IPHONEX_TABBAR_FIX_HEIGHT 34
#define IPHONEX_TOPBAR_FIX_HEIGHT 44
#define ISIPHONEX CGSizeEqualToSize([[UIScreen mainScreen] currentMode].size, CGSizeMake(1125, 2436))

#endif /* XScreenConfig_h */
