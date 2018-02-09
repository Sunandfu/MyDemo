//
//  TXTimeChoose.h
//  TYSubwaySystem
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 TXZhongJiaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BHXDatePikerViewDelegate <NSObject>
//必须实现的两个代理
@required
//当时间改变时触发
- (void)changeTime:(NSDate *)date;
//确定时间
- (void)determine:(NSDate *)date;

@end


@protocol BHXPickerViewDelegate <NSObject>

//改变时触发
- (void)changeDate:(NSString *)dateString andComponent:(NSInteger)component;
//确定时触发
- (void)deterDate:(NSString *)dateString andComponent:(NSInteger)component;

@end





@interface BHXPikerView : UIView
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame type:(UIDatePickerMode)type;

- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array;


//设置初始时间
- (void)setNowTime:(NSString *)dateStr;

// NSDate --> NSString
- (NSString*)stringFromDate:(NSDate*)date;
//NSDate <-- NSString
- (NSDate*)dateFromString:(NSString*)dateString;

- (void)handleDateTopViewCancel;
- (void)handleDateTopViewCertain;
- (void)handleDateTopViewCertain1;


@property (assign,nonatomic)id<BHXDatePikerViewDelegate>delegate;

@property (assign,nonatomic)id<BHXPickerViewDelegate>pickerdelegate;

@end
