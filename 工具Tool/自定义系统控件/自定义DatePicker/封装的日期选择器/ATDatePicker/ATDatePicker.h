//
//  ATDatePicker.h
//  ATDatePicker
//
//  Created by Jam on 16/8/4.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickerFinishBlock)(NSString *dateString);

@interface ATDatePicker : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

- (instancetype)initWithDatePickerMode:(UIDatePickerMode) datePickerMode DateFormatter:(NSString *)dateFormatter datePickerFinishBlock:(DatePickerFinishBlock)datePickerFinishBlock;

- (void)show;

@end
