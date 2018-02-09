//
//  SynchronizeDervice.m
//  fitness
//
//  Created by 小富 on 2016/11/28.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import "SynchronizeDervice.h"
#import "SFBleCenter.h"

@interface SynchronizeDervice ()

@property (nonatomic, assign) long selectedInt;

@end

@implementation SynchronizeDervice

- (instancetype)initWith:(CBPeripheral*)pheripheral{
    self = [super init];
    if (self) {
        self.heartLongStr = @"";
        self.HeartRateArray = [NSMutableArray arrayWithCapacity:0];
        self.SleepDataArray = [NSMutableArray arrayWithCapacity:0];
        self.SportDataArray = [NSMutableArray arrayWithCapacity:0];
        self.synCmdArray = [NSMutableArray arrayWithCapacity:0];
        self.orignalData = @"";
        self.sleepOrigArray = [NSMutableArray arrayWithCapacity:0];
        self.latestTime = @"";
        self.signTime = @"";
        self.updateSleepData = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
#pragma mark - 同步时间和身体特征
- (void)upDateHeartRateForCharacteristic:(NSString *)value{
    NSUserDefaults *currUser = [NSUserDefaults standardUserDefaults];
    if ([value hasPrefix:@"25"]) {
        self.heartLongStr = [self.heartLongStr stringByAppendingString:[value substringWithRange:NSMakeRange(6, value.length-8)]];
        if ([currUser objectForKey:@"dateStr"]==nil) {
            if (self.heartLongStr.length==48) {
                //            long dataLength = strtoul([[self.heartLongStr substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                //            NSString *dataStr = [self.heartLongStr substringWithRange:NSMakeRange(6, 2*dataLength)];
                NSMutableArray *tmpHateRate = [NSMutableArray arrayWithCapacity:0];
                for (int i=0; i<24; i++) {
                    long heartRate = strtoul([[self.heartLongStr substringWithRange:NSMakeRange(i*2, 2)] UTF8String], 0, 16);
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *Date_sub = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",[[self getBeijingNowTime] substringToIndex:10]]];//格林尼治时间
                    NSTimeInterval interval = 60*i*60; //秒数
                    NSString *heartRateTime = [dateFormatter stringFromDate:[Date_sub  initWithTimeInterval:interval  sinceDate:  Date_sub]];
                    
                    NSInteger integer = [self compareDate:heartRateTime withDate:[self getBeijingNowTime]];
                    if (integer==-1) {
                        heartRate = 0;
                    }
                    
                    NSString *updataRate = [NSString stringWithFormat:@"%ld",heartRate];
                    [tmpHateRate addObject:updataRate];
                }
                NSDictionary *dic = @{@"hateArr":tmpHateRate};
                [self.HeartRateArray addObject:dic];
                if ([self.delegate respondsToSelector:@selector(synchronizeHeartRateDoneWithArray:)]) {
                    [self.delegate synchronizeHeartRateDoneWithArray:self.HeartRateArray];
                }
            }
        } else {
            NSArray *dateArr = [self arrayWithOldTime:[currUser objectForKey:@"dateStr"] nowTime:[[self getBeijingNowTime] substringToIndex:10]];
            if (self.heartLongStr.length==48*dateArr.count) {
                //            long dataLength = strtoul([[self.heartLongStr substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                
                for (int i=0; i<dateArr.count; i++) {
                    NSString *dataStr = [self.heartLongStr substringWithRange:NSMakeRange(48*i, 48)];
                    NSMutableArray *tmpHateRate = [NSMutableArray arrayWithCapacity:0];
                    for (int j=0; j<24; j++) {
                        long heartRate = strtoul([[dataStr substringWithRange:NSMakeRange(j*2, 2)] UTF8String], 0, 16);
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSDate *Date_sub = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",dateArr[i]]];//格林尼治时间
                        NSTimeInterval interval = 60*j*60; //秒数
                        NSString *heartRateTime = [dateFormatter stringFromDate:[Date_sub  initWithTimeInterval:interval  sinceDate:  Date_sub]];
                        
                        NSInteger integer = [self compareDate:heartRateTime withDate:[self getBeijingNowTime]];
                        if (integer==-1) {
                            heartRate = 0;
                        }
                        
                        NSString *updataRate = [NSString stringWithFormat:@"%ld",heartRate];
                        [tmpHateRate addObject:updataRate];
                    }
                    NSDictionary *dic = @{@"hateArr":tmpHateRate};
                    [self.HeartRateArray addObject:dic];
                }
                if ([self.delegate respondsToSelector:@selector(synchronizeHeartRateDoneWithArray:)]) {
                    [self.delegate synchronizeHeartRateDoneWithArray:self.HeartRateArray];
                    self.heartLongStr = @"";
                }
                
            }
        }
    }
}

// 同步睡眠运动数据
-(void) syncSleepAndSportWithDateStr:(NSString *)datestr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentTime = [[self getBeijingNowTime] substringToIndex:10];
    NSDate *currentDate = [dateFormatter dateFromString:currentTime];
    NSDate * latestDate = nil;
    NSString *curDate = [currentTime substringToIndex:10];
    
    int idx = 0;
    // 时间间隔
    if (datestr==nil) {
        idx = 1;
    } else {
        latestDate = [dateFormatter dateFromString:datestr];
        idx = (int)(([currentDate timeIntervalSince1970] - [latestDate timeIntervalSince1970]) / 60 / 60 / 24);
        if (idx>1) {
            idx=1;
        }
    }
    
    NSInteger timeTmp = [NSDate date].timeIntervalSince1970 - idx * 60 * 60 * 24;
    NSDate *syntimeTmp = [NSDate dateWithTimeIntervalSince1970: timeTmp];
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = @"yyyy-MM-dd";
    self.latestTime =  [recordDateFormatter stringFromDate:syntimeTmp];
    
    while(idx >= 0) {
        NSInteger time = [NSDate date].timeIntervalSince1970 - idx * 60 * 60 * 24;
        NSDate *syntime = [NSDate dateWithTimeIntervalSince1970: time];
        NSInteger week = [self getWeekByDateString:syntime];
        
        int hour = 0;
        NSString *hexHour = @"";
        NSString *hexCheckNum = @"";
        NSString *synCommand = @"";
        for (int i = 0; i < 8; i++) {
            hour = 3 * i;
            unsigned long checkNum = (week ^ hour ^0x03) & 0xff;
            hexCheckNum = checkNum < 16 ?([NSString stringWithFormat:@"0%lx", checkNum]) : ([NSString stringWithFormat:@"%lx", checkNum]);
            hexHour = hour < 16 ?([NSString stringWithFormat:@"0%x", hour]) : ([NSString stringWithFormat:@"%x", hour]);
            
            synCommand = [NSString stringWithFormat:@"C403%@%@03%@", [NSString stringWithFormat:@"0%x", (int)week], hexHour, hexCheckNum];
            
            NSString *theDate = [dateFormatter stringFromDate:syntime];
            if ([curDate isEqualToString:theDate] && hour > 9) {
                break;
            }
            [self.synCmdArray addObject:synCommand];

        }
        idx--;
    }
    if ([self.synCmdArray count] > 0) {
        
        NSString *last = [self.synCmdArray firstObject];
        
        [[SFBleCenter shareManager] writeValue:last forCharacteristicUUIDStr:YXBraceletFFF2 toBracelet:[SFBleCenter shareManager].currentBracelet];
        
        [self.synCmdArray removeObjectAtIndex:0];
    }

}

-(void) handleSleepAndSportData:(NSString *) value{
    
    if ([value hasPrefix:@"25"] || [value hasPrefix:@"22"]
        || [value hasPrefix:@"26"] || [value hasPrefix:@"96"] || [value hasPrefix:@"230000"]) {
        return;
    }
    
    if ([value hasPrefix:@"24"] || [value hasPrefix:@"4"] || [value hasPrefix:@"0"]) {
        
        if (self.orignalData.length == 0 && [value hasPrefix:@"2470"]) {
            self.orignalData = [self.orignalData stringByAppendingString:value];
        } else if ([self.orignalData hasPrefix:@"2470"] && self.orignalData.length < 230) {
            self.orignalData = [self.orignalData stringByAppendingString:value];
        }
        
        if (self.orignalData.length == 230) {
            
            NSString *originStr = [self.orignalData substringWithRange:NSMakeRange(12, 216)];
            
            NSString *str = [originStr stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"0"]];
            str = @"111";
            if(str.length > 0){
                int mins = 0;
                
                NSString *currentTime = [self getBeijingNowTime];
                NSString *curDate = [currentTime substringToIndex:10];
                
                NSString *hexYear = [self.orignalData substringWithRange:NSMakeRange(4, 2)];
                NSInteger year = strtoul([hexYear UTF8String], 0, 16);
                NSString *hexMonth = [self.orignalData substringWithRange:NSMakeRange(6, 2)];
                NSInteger month = strtoul([hexMonth UTF8String], 0, 16);
                NSString *hexDay = [self.orignalData substringWithRange:NSMakeRange(8, 2)];
                NSInteger day = strtoul([hexDay UTF8String], 0, 16);
                NSString *hexHour = [self.orignalData substringWithRange:NSMakeRange(10, 2)];
                NSInteger hour = strtoul([hexHour UTF8String], 0, 16);
                
                NSString *dtime = [NSString stringWithFormat:@"20%.2d-%.2d-%.2d",(int)year, (int)month, (int)day];
                
                if (hour>=21) {
                    [self.updateSleepData addObject:self.orignalData];
                }
                if ((self.updateSleepData.count>=1)&&(hour<12)) {
                    [self.updateSleepData addObject:self.orignalData];
                }
                
                
                // 格式化时间，当时间异常
                if ([hexYear isEqualToString:@"00"]) {
                    dtime = self.latestTime;
                    
                    if (hour == 0) {
                        if ([self.signTime isEqualToString:@""]) {
                            // 第一天日期 时间为空
                            self.signTime = dtime;
                        }else {
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            NSDate *d = [NSDate dateWithTimeInterval: 24*60*60 sinceDate:[dateFormatter dateFromString:dtime]];
                            dtime = [dateFormatter stringFromDate:d];
                        }
                        self.latestTime = dtime;
                    }
                } else {
                    self.signTime = dtime;
                    self.latestTime = dtime;
                }
                
                for (int i = 0; i < 18; ++i) {
                    NSString *perTenMin = [[originStr substringWithRange:NSMakeRange(i * 12, 4)] uppercaseString];
                    NSString *binary = [self getBinaryByHex:perTenMin];
                    NSString *mode = [binary substringToIndex:2];
                    unsigned long num = strtoul([[binary substringWithRange:NSMakeRange(2, 14)] UTF8String], 0, 2);
                    if (dtime.length!=10) {
                        dtime = [[self getBeijingNowTime] substringToIndex:10];
                    }
                    NSString *time = [NSString stringWithFormat:@"%@ %.2d:%.2d:00",dtime, (int)hour, mins];
                    
                    NSString *thisDate = [time substringToIndex:10];
                    NSInteger ingter = [self compareDate:time withDate:[self getBeijingNowTime]];
                    // 当前日期之前的历史计步数据
                    if (![thisDate isEqualToString:curDate] && ingter==1) {
                        NSDictionary *dic = @{@"walkTime":time,@"walkNum":[NSString stringWithFormat:@"%ld",num],@"state":mode};
                        [self.SportDataArray addObject:dic];
                    }
                    
                    // 睡眠区间过滤
                    NSString *data = [NSString stringWithFormat:@"%@_%@_%ld", time, mode, num];
                    if (hour>=21) {
                        [self.sleepOrigArray addObject:data];
                    }
                    if ([self.sleepOrigArray count] >= 18) {
                        if (hour >=0 && hour <= 11) {
                            [self.sleepOrigArray addObject:data];
                        }
                    }
                    
                    mins += 10;
                    if (mins == 60) {
                        mins = 0;
                        hour += 1;
                    }
                    
                    if (hour == 24) {
                        hour = 0;
                    }
                    
                    if ([self.sleepOrigArray count] == 90) {
                        NSArray *sleeps = [self.sleepOrigArray copy];
                        NSArray *updateSleeps = [self.updateSleepData copy];
                        [self.sleepOrigArray removeAllObjects];
                        [self.updateSleepData removeAllObjects];
                        [self spleepAlgorithm:sleeps up:updateSleeps];
                    }
                }
                if ([self.SportDataArray count] == 144) {
                    if ([self.delegate respondsToSelector:@selector(synchronizeSportDataDoneWithArray:)]) {
                            NSArray *sports = [self.SportDataArray copy];
                            [self.SportDataArray removeAllObjects];
                            [self.delegate synchronizeSportDataDoneWithArray:sports];
                    }
                }
            }
            
            NSString *last = [self.synCmdArray firstObject];
            [[SFBleCenter shareManager] writeValue:last forCharacteristicUUIDStr:YXBraceletFFF2 toBracelet:[SFBleCenter shareManager].currentBracelet];
            if ([self.synCmdArray count] > 0) {
                [self.synCmdArray removeObjectAtIndex:0];
            }
            self.orignalData = @"";
        }
        
    }
}

-(void) spleepAlgorithm:(NSArray *) dataArray up:(NSArray *) updateSleepArray{
    
    NSInteger length = [dataArray count];
    NSString *startTime = @"";
    NSString *endTime = @"";
    int wakeUpFlag = 0;
    
    int deep = 0;
    int shallow = 0;
    int wakeUp = 0;
    
    bool sleepStart = false;
    bool sleepEnd = false;
    int selectedIndex = 0;
    
    int startIndex = 0;
    int endIndex = 0;
    
    int stopIndex = 0;
    
    NSString *sleepType = @"";
    
    int track_sleep_status = 0;
    
    for (int i = 0; i < length; i++) {
        NSString *data = dataArray[i];
        NSArray *items = [data componentsSeparatedByString:@"_"];
        NSString *time = items[0];
        NSString *mode = items[1];
        int num = [items[2] intValue];

        int hour = [[time substringWithRange:NSMakeRange(11, 2)] intValue];
        
        // 校验数据格式
        if (i < 18) {
            // 21 22 23
            if (hour < 21) {
                return;
            }
        } else if (i < 36) {
            // 0 1 2
            if (hour >= 3) {
                return;
            }
        } else if (i < 54) {
            // 3 4 5
            if (hour >= 6) {
                return;
            }
        } else if (i < 72) {
            // 6 7 8
            if (hour >= 9) {
                return;
            }
        } else if (i < 90) {
            // 9 10 11
            if (hour >= 12) {
                return;
            }
        }
        
        // 21:00~01:00 查找入睡时间点
        if ((hour <= 23 && hour >= 20) || (hour >= 0 && hour <= 1)) {
            if ([mode isEqualToString:@"00"] || ([mode isEqualToString:@"01"] && num>300)) {
                startTime = @"";
                sleepStart = false;
                continue;
            } else if([mode isEqualToString:@"01"] && !sleepStart){
                sleepStart = true;
                startTime = time;
                startIndex = i;
            }
        }
        
        // 03:00~06:00 查找入睡时间点
        if (hour > 1 && hour <= 5) {
            if (sleepStart){
                if([mode isEqualToString:@"00"] || ([mode isEqualToString:@"01"] && num > 100)){
                    wakeUpFlag += 1;
                }
                
                if (wakeUpFlag >= 8){
                    sleepStart = false;
                }
            } else {
                if([mode isEqualToString:@"01"]){
                    sleepStart = true;
                    startTime = time;
                    startIndex = i;
                } else{
                    //
                }
            }
        }
        
        
        // 05:00~11:00查找睡醒时间点
        if (hour >= 6 && hour < 12) {
            if ([mode isEqualToString:@"00"] || ([mode isEqualToString:@"01"] && num>300)) {
                NSString *temp = dataArray[i - 1];
                NSArray *it = [temp componentsSeparatedByString:@"_"];
                endTime = it[0];
                sleepEnd = true;
                endIndex = i - 1;
                //break;
                if (num > 30) {
                    break;
                }
            }
            
            if (sleepEnd && i > endIndex + 1) {
                // 清醒状态为误判 过滤
                if ([mode isEqualToString:@"01"] && num > 0 && num < 30) {
                    stopIndex += 1;
                }
                
                if (stopIndex >= 3 && [mode isEqualToString:@"00"])  {
                    NSString *temp = dataArray[i - 1];
                    NSArray *it = [temp componentsSeparatedByString:@"_"];
                    endTime = it[0];
                    sleepEnd = true;
                    endIndex = i - 1;
                }
                
                if ((!sleepEnd)&&([self compareDate:[self getBeijingNowTime] withDate:time])) {
                    NSString *temp = dataArray[i - 1];
                    NSArray *it = [temp componentsSeparatedByString:@"_"];
                    endTime = it[0];
                    sleepEnd = true;
                    endIndex = i - 1;
                }
            }
            
            if ((!sleepEnd)&&([self compareDate:[self getBeijingNowTime] withDate:time])) {
                NSString *temp = dataArray[i - 1];
                NSArray *it = [temp componentsSeparatedByString:@"_"];
                endTime = it[0];
                sleepEnd = true;
                endIndex = i - 1;
            }
        }
        
        if (hour >= 0 && hour <=6) {
            // 手环静止 没有佩戴过滤
            if (num > 0 && num <= 50) {
                track_sleep_status += 1;
            }
        }
    }
    
    // 0点到6点一直处于静止状态
    if (track_sleep_status >= 8) {
        for (int j = startIndex; j < endIndex; ++j) {
            NSString *data = dataArray[j];
            NSArray *items = [data componentsSeparatedByString:@"_"];
            int num = [items[2] intValue];
            
            if (num <=10) {
                deep += 10;
                sleepType = [sleepType stringByAppendingString:@"1,"];
            } else if (num > 10 && num <= 30) {
                shallow += 10;
                sleepType = [sleepType stringByAppendingString:@"2,"];
            } else{
                shallow += 10;
                
                if (j > 0) {
                    if (selectedIndex + 1 == j) {
                        sleepType = [sleepType stringByAppendingString:@"2,"];
                    } else {
                        if (j < endIndex - 1 ) {
                            wakeUp += 1;
                            sleepType = [sleepType stringByAppendingString:@"3,"];
                            selectedIndex = j;
                        }
                    }
                }
                
            }
        }
    }
    
    if(shallow > 30 && startIndex >= 0 && endIndex > startIndex && startTime != nil && endTime != nil){
        // nothing to do
    }else if(track_sleep_status >= 8){
        // special conditions
        sleepType = @"";
        bool start = false;
        deep = 0;
        shallow = 0;
        wakeUp = 0;
        for (int i = 0; i < length; i++) {
            NSString *d = dataArray[i];
            NSArray *it = [d componentsSeparatedByString:@"_"];
            NSString *t = it[0];
            NSString *m = it[1];
            int num = [it[2] intValue];
            
            int hour = [[t substringWithRange:NSMakeRange(11, 2)] intValue];
            
            if (hour <= 1 || hour >= 23) {
                if([m isEqualToString:@"01"] && num < 100 && !start){
                    startIndex = i;
                    startTime = t;
                    start = true;
                }
            }
            
            if (hour > 1 && hour <= 2 && !start) {
                startIndex = i;
                startTime = t;
                start = true;
            }
            
            if (start) {
                // deep, shadow, wakeup
                if (num <=10) {
                    deep += 10;
                    sleepType = [sleepType stringByAppendingString:@"1,"];
                } else if (num > 10 && num <= 30) {
                    shallow += 10;
                    sleepType = [sleepType stringByAppendingString:@"2,"];
                }else {
                    NSUInteger r = arc4random_uniform(1000) % 10;
                    if (r < 7) {
                        shallow += 10;
                        sleepType = [sleepType stringByAppendingString:@"2,"];
                    } else {
                        deep += 10;
                        sleepType = [sleepType stringByAppendingString:@"1,"];
                    }
                }
            }
            
            
            if (hour >= 5 && hour < 7) {
                if(([m isEqualToString:@"01"] && num > 400) || [m isEqualToString:@"00"]){
                    NSString *temp = dataArray[i - 1];
                    NSArray *it = [temp componentsSeparatedByString:@"_"];
                    endTime = it[0];
                    endIndex = i - 1;
                    
                    NSUInteger r = arc4random_uniform(100) % 3;
                    if (r < 2) {
                        shallow -= 10;
                        deep -= 10;
                    } else {
                        deep -= 20;
                    }
                    
                    break;
                }
            }
            
            if (start && hour >= 7 && hour < 8) {
                NSString *temp = dataArray[i - 1];
                NSArray *it = [temp componentsSeparatedByString:@"_"];
                endTime = it[0];
                endIndex = i - 1;
                
                NSUInteger r = arc4random_uniform(100) % 3;
                if (r < 2) {
                    shallow -= 10;
                    deep -= 10;
                } else {
                    deep -= 20;
                }
                break;
            }
            
        }
    }
    
    startTime = [self dateStrWithTenMinuteLater:startTime];
    endTime = [self dateStrWithTenMinuteLater:endTime];
    NSInteger integer = [self compareDate:endTime withDate:[self getBeijingNowTime]];
    if(shallow > 30 && startIndex >= 0 && endIndex > startIndex && integer==1 && startTime != nil && endTime != nil && track_sleep_status >= 8){
        if (sleepType.length>1) {
            sleepType = [sleepType substringToIndex:sleepType.length-1];
        }
        [self.SleepDataArray removeAllObjects];
        
        [self.SleepDataArray addObject:@{@"key":@"19",@"sleepDetail":sleepType,@"sleepDate":startTime,@"sleepStoptime":endTime,@"sleepDeep":[NSString stringWithFormat:@"%d",deep],@"sleepShallow":[NSString stringWithFormat:@"%d",shallow],@"sleepSober":[NSString stringWithFormat:@"%d",wakeUp],@"sleepSycTime":[self getBeijingNowTime],@"sleepTime":[NSString stringWithFormat:@"%d",shallow+deep]}];
        if ([self.delegate respondsToSelector:@selector(synchronizeSleepDataDoneWithArray:)]) {
            [self.delegate synchronizeSleepDataDoneWithArray:self.SleepDataArray];
        }
    } else if (shallow==0) {
        [self.SleepDataArray removeAllObjects];
        [self.SleepDataArray addObject:@{@"key":@"19",@"error":@"未解析出睡眠数据"}];
        if ([self.delegate respondsToSelector:@selector(synchronizeSleepDataDoneWithArray:)]) {
            [self.delegate synchronizeSleepDataDoneWithArray:self.SleepDataArray];
        }
    }
}
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}
- (NSString *)dateStrWithTenMinuteLater:(NSString *)DateStr{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [dateFormatter dateFromString:DateStr];
    NSTimeInterval interval = 60*10; //秒数
    NSString *nowTime = [dateFormatter stringFromDate:[nowDate  initWithTimeInterval:interval sinceDate:nowDate]];
    return nowTime;
}

- (NSArray *)arrayWithOldTime:(NSString *)endTime nowTime:(NSString *)nowTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray *dates = [NSMutableArray array];
    NSInteger nowTimeNew = [dateFormatter dateFromString:endTime].timeIntervalSince1970+24*60*60;
    NSInteger endTimeNew = [dateFormatter dateFromString:nowTime].timeIntervalSince1970;
    NSInteger dayTime = 24*60*60;
    NSInteger time = nowTimeNew - nowTimeNew%dayTime;
    
    while (time <= endTimeNew) {
        NSString *showOldDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [dates addObject:showOldDate];
        time += dayTime;
    }
    [dates addObject:nowTime];
    return dates;
}
//  十六进制 转 二进制
-(NSString *)getBinaryByHex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"A"];
    
    [hexDic setObject:@"1011" forKey:@"B"];
    
    [hexDic setObject:@"1100" forKey:@"C"];
    
    [hexDic setObject:@"1101" forKey:@"D"];
    
    [hexDic setObject:@"1110" forKey:@"E"];
    
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binaryString = @"";
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    return binaryString;
    
}

//-(NSInteger) getWeekByDateString:(NSDate *) date {
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"ee"];
//    NSInteger weekNum = [formater stringFromDate:date].intValue;
//    if (weekNum == 1){
//        weekNum = 7;
//    } else  {
//        weekNum = weekNum - 1;
//    }
//    return weekNum;
//}
-(NSInteger) getWeekByDateString:(NSDate *) date {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formater stringFromDate:date];
    unsigned int year = [dateStr substringWithRange:NSMakeRange(0, 4)].intValue;
    unsigned int month = [dateStr substringWithRange:NSMakeRange(5, 2)].intValue;
    unsigned int day = [dateStr substringWithRange:NSMakeRange(8, 2)].intValue;
    
    unsigned int ye_ar = 0;
    unsigned int centu_ry = 0;
    unsigned int m = month;
    unsigned char week;
    if (m == 1 || m == 2) {
        m += 12;
        ye_ar = (year - 1)%100;
        centu_ry = (year-1)/100;
    } else {
        ye_ar = year%100;
        centu_ry = year/100;
    }
    week = ye_ar+ye_ar/4+centu_ry/4-2*centu_ry+(26*(m+1))/10+day-1;
    
    printf("week %d \t", week);
    
    if (week !=0) {
        if(week%7!=0){
            if(week){
                week = week%7;
            }
        }
        else{
            week = 7;
        }
    }
    else{
        week=7;
    }
    printf("%d/%d/%d is week %d\n", year, month, day, week);
    return week;
}
-(NSString *)getBeijingNowTime{
    //获取当前的UTC时间  并将其转换为北京时间
    NSDate *UTCNow=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *BeiJingTime=[dateFormatter stringFromDate:UTCNow];
    return BeiJingTime;
}
@end
