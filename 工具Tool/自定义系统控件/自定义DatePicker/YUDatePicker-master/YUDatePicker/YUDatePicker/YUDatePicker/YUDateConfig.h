//
//  YUDateConfig.h
//  YUDatePicker
//
//  Created by BruceYu on 15/4/26.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#ifndef YUDatePicker_YUDateConfig_h
#define YUDatePicker_YUDateConfig_h

#import <UIKit/UIKit.h>

#ifndef isIOS7
#define isIOS7  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#endif

#ifndef isIOS8
#define isIOS8   ([[[UIDevice currentDevice]systemVersion]integerValue] >= 8.0)
#endif

#define NOT_DEFINED         -1
#define L2S(x) ((x)==NOT_DEFINED?@"":[NSString stringWithFormat:@"%ld",((long)x)])
#define I2S(x) ((x)==NOT_DEFINED?@"":[NSString stringWithFormat:@"%d",((int)x)])

//config
#define YU_PICKER_MAXDATE 2050

#define YU_PICKER_MINDATE 1970

#define YU_PICKER_MONTH 12

#define YU_PICKER_DAY 31

#define YU_PICKER_HOUR 24

#define YU_PICKER_MINUTE 60

#define YU_LIGHTGRAY [UIColor lightGrayColor]//不可选颜色( date < min || date > max)

#define YU_BLACK [UIColor blackColor]//可选颜色< min < date < max >

#define YU_FORMAT @"yyyyMMddHHmm"

#define YU_FORMATSTR @"%@%@%@%@%@"

#define YU_DATESTR @"%@-%@-%@ %@:%@:00"


#endif
