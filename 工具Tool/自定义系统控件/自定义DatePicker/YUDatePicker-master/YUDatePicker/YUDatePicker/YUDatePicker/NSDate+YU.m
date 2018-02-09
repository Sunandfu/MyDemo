

//
//  NSDate+YU.m
//  YUDatePicker
//
//  Created by BruceYu on 15/4/26.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "NSDate+YU.h"
#import "YUDateConfig.h"

@implementation NSDate (YU)

+(NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:YU_FORMAT];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+(unsigned)UnitFlags
{
    unsigned unitFlags = 0;
    
#ifdef isIOS8
            unitFlags = kCFCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond|NSCalendarUnitWeekday|kCFCalendarUnitWeekdayOrdinal;
#else
            unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit ;
#endif

    return unitFlags;
}

+(NSDateComponents*)dateComponentsFromDate:(NSDate*)date{
    
    if (!date) {
        date = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *_dateComponents = [calendar components:self.UnitFlags fromDate:date];
    return _dateComponents;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString: string];
}

+(NSDate*)dateWithYea:(NSInteger)yeaNum{
    NSCalendar *_greCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponentsAsTimeQantum = [[NSDateComponents alloc] init];
    [dateComponentsAsTimeQantum setYear:yeaNum];
    NSDate *dateFromDateComponentsAsTimeQantum = [_greCalendar dateFromComponents:dateComponentsAsTimeQantum];
    return dateFromDateComponentsAsTimeQantum;
}


+ (NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSAssert(!(month < 1||month > 12), @"invalid month number");
    NSAssert(!(year < 1), @"invalid year number");
    month = month - 1;
    static int daysOfMonth[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int days = daysOfMonth[month];
    /*
     * feb
     */
    if (month == 1) {
        if ([self isLeapYear:year]) {
            days = 29;
        }
        else {
            days = 28;
        }
    }
    return days;
}


+ (BOOL)isLeapYear:(NSInteger)year
{
    NSAssert(!(year < 1), @"invalid year number");
    BOOL leap = FALSE;
    if ((0 == (year % 400))) {
        leap = TRUE;
    }
    else if((0 == (year%4)) && (0 != (year % 100))) {
        leap = TRUE;
    }
    return leap;
}
@end

