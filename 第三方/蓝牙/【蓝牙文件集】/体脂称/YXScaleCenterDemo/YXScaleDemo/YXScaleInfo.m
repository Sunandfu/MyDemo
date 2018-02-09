//
//  YXScaleInfo.m
//  fitness
//
//  Created by 云镶网络科技公司 on 2016/11/4.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import "YXScaleInfo.h"

@interface YXScaleInfo ()


@property (nonatomic,strong) NSDateFormatter * dateFormatter;

@end

@implementation YXScaleInfo

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

- (void)setDateStr:(NSString *)dateStr
{
    _dateStr = [dateStr copy];
    _signStr = [[_dateStr substringToIndex:10] copy];
    _signDate = [self.dateFormatter dateFromString:_dateStr];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"athleteLevel:%ld,group:%ld,gender:%ld,age:%ld,height:%ld,weight:%f,fat:%f,skeleton:%f,muscle:%f,visceralFatRating:%ld,moisture:%f,metabolicRate:%ld,bodyAge:%ld",(long)self.athleteLevel,(long)self.group,(long)self.gender,(long)self.age,(long)self.height,self.weight,self.fat,self.skeleton,self.muscle,(long)self.visceralFatRating,self.moisture,(long)self.metabolicRate,(long)self.bodyAge];
}

@end
