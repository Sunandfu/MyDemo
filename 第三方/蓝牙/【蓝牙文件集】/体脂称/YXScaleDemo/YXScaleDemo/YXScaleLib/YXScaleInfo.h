//
//  YXScaleInfo.h
//  fitness
//
//  Created by 云镶网络科技公司 on 2016/11/4.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YXScaleInfo : NSObject

@property (nonatomic,assign) NSInteger dataID;

@property (nonatomic,copy,readonly) NSString * signStr;

@property (nonatomic,strong,readonly) NSDate * signDate;
/**
 运动员级别 0 普通 1 业余 2 专业
 */
@property (nonatomic,assign) NSInteger athleteLevel;
//组别 00~09
@property (nonatomic,assign) NSInteger group;
/**
 性别 1 男 0 女
 */
@property (nonatomic,assign) NSInteger gender;
/**
 年龄
 */
@property (nonatomic,assign) NSInteger age;
/**
 身高 cm
 */
@property (nonatomic,assign) NSInteger height;
/**
 体重 kg
 */
@property (nonatomic,assign) CGFloat weight;
/**
 人体脂肪含量 1%
 */
@property (nonatomic,assign) CGFloat fat;
/**
 骨骼含量 kg
 */
@property (nonatomic,assign) CGFloat skeleton;
/**
 肌肉含量 kg
 */
@property (nonatomic,assign) CGFloat muscle;
/**
 内脏脂肪指数
 */
@property (nonatomic,assign) NSInteger visceralFatRating;
/**
 人体水分含量 1%
 */
@property (nonatomic,assign) CGFloat moisture;
/**
 基础代谢率
 */
@property (nonatomic,assign) NSInteger metabolicRate;
/**
 身体质量指数
 */
@property (nonatomic,assign) CGFloat BMI;
/**
 身体年龄
 */
@property (nonatomic,assign) NSInteger bodyAge;
/**
 记录的时间
 */
@property (nonatomic,copy) NSString * dateStr;
/**
是否有错误
 */
@property (nonatomic,assign) BOOL isError;
/**
 错误说明
 */
@property (nonatomic,copy) NSString *error;

@end
