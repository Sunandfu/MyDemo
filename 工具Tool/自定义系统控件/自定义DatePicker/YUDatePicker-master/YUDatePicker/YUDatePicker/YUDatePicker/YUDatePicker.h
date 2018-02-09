//
//  YUDatePicker.h
//  YUDatePicker
//
//  Created by BruceYu on 15/4/26.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+YU.h"
#import "YUDateConfig.h"

typedef NS_ENUM(NSInteger, YUUIDatePickerMode) {
    UIYUDatePickerModeTime,           // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    
    UIYUDatePickerModeDate,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    
    UIYUDatePickerModeDateAndTime,    // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    UIYUDatePickerModeCountDownTimer, // Displays hour and minute (e.g. 1 | 53)
    
    UIYUDatePickerModeDateYYYYMMDDHHmm,    // (e.g.  2015年 | 05月 | 01日 | 11时 | 59分)
};



NS_CLASS_AVAILABLE_IOS(6_0)@interface YUDatePicker : UIControl

@property (nonatomic) YUUIDatePickerMode datePickerMode; // default is UIXYDatePickerModeDateAndTime

@property (nonatomic, retain) NSLocale   *locale;   // default is [NSLocale currentLocale]. setting nil returns to default

@property (nonatomic, copy)   NSCalendar *calendar; // default is [NSCalendar currentCalendar]. setting nil returns to default

@property (nonatomic, retain) NSTimeZone *timeZone; // default is nil. use current time zone or time zone from calendar

@property (nonatomic, retain) NSDate *date;        // default is current date when picker created. Ignored in countdown timer mode. for that mode, picker starts at 0:00
@property (nonatomic, readonly) NSString *dateStr;//return current date Formatter yyyy-MM-dd HH:mm:ss

@property (nonatomic, retain) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, retain) NSDate *maximumDate; // default is nil


@property (nonatomic) NSTimeInterval countDownDuration; // for UIDatePickerModeCountDownTimer, ignored otherwise. default is 0.0. limit is 23:59 (86,399 seconds). value being set is div 60 (drops remaining seconds).
@property (nonatomic) NSInteger      minuteInterval;    // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30
- (void)setDate:(NSDate *)date animated:(BOOL)animated; // if animated is YES, animate the wheels of time to display the new date

@property (nonatomic, assign) BOOL showToolbar;

@end

typedef void (^dateBlock)(YUDatePicker *date);

@interface YUDatePicker(YU)

-(void)showInView:(UIView *)view block:(dateBlock)dateBlock;

-(void)hidden;

@end
