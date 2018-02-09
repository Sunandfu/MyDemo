//
//  YXRunItem.h
//  fitness
//
//  Created by 云镶网络科技公司 on 2016/11/30.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFRunItem : NSObject

/**
 间隙时间 2分钟存储一次
 */
@property (nonatomic,assign) NSInteger gap;

@property (nonatomic,assign) NSInteger runSteps;

@property (nonatomic,assign) NSInteger startYear;

@property (nonatomic,assign) NSInteger startMonth;

@property (nonatomic,assign) NSInteger startDay;

@property (nonatomic,assign) NSInteger startHour;

@property (nonatomic,assign) NSInteger startMinute;

@property (nonatomic,assign) NSInteger startSecond;

@property (nonatomic,assign) NSInteger stopYear;

@property (nonatomic,assign) NSInteger stopMonth;

@property (nonatomic,assign) NSInteger stopDay;

@property (nonatomic,assign) NSInteger stopHour;

@property (nonatomic,assign) NSInteger stopMinute;

@property (nonatomic,assign) NSInteger stopSecond;

@property (nonatomic,assign) NSInteger spendTime;

@property (nonatomic,copy) NSString * startDate;

@property (nonatomic,copy) NSString * stopDate;

@property (nonatomic,copy) NSString * showStartDate;

@property (nonatomic,copy) NSString * showStopDate;

@property (nonatomic,assign) NSInteger heartCount;

@property (nonatomic,copy) NSArray<NSString *> * heartArr;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
