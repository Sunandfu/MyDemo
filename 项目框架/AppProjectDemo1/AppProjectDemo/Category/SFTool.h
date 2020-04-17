//
//  SFTool.h
//  fitness
//
//  Created by 云镶网络科技公司 on 2016/10/21.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFTool : NSObject

+ (BOOL)checkPhoneNum:(NSString *)phoneNum;
+ (BOOL) validateEmail:(NSString *)email;
+ (NSString *)returnRandomNum;
+ (NSString *)getNowDayNumberStr;
+ (NSString *)nextDayWithDate:(NSDate *)date Number:(NSInteger)number;
+ (NSString *)nextDayWithDateStr:(NSString *)nowDateStr Number:(NSInteger)number;
+ (NSString *)getLunarSpecialDate;
+ (NSString *)getCustomPassword;
+ (NSString *)getShowDateStrWithDateStr:(NSString *)str;
+ (NSInteger)getCountDownDateStrWithDateStr:(NSString *)str;
+ (NSInteger)getAgeWithBirthday:(NSString *)str;
+ (NSString *)getDateStrWithTimeStr:(NSString *)timeStr;
+ (NSInteger)getDayWithBirthdayDate:(NSDate *)date;
+ (NSInteger)getAgeWithBirthdayDate:(NSDate *)date;

+ (CGFloat)getRoundValueWithFloat:(CGFloat)value roundingMode:(NSRoundingMode)roundingMode scale:(NSInteger)scale;

+ (BOOL)checkRunDateIsOkWithStartDate:(NSString *)start stopDate:(NSString *)stop;

+ (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop;
//行高
+ (NSAttributedString *)createAttriWithText:(NSString *)text lineHeight:(CGFloat)lineHeight alignment:(NSTextAlignment)alignment;
//行间距
+ (NSAttributedString *)createAttriWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment;

+ (CGFloat)countLengthWithText:(NSString *)text font:(UIFont *)font certainLength:(CGFloat)certainLength certainWidth:(BOOL)isWidth;

+ (NSString *)compareCurrentTime:(NSDate *)compareDate;

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color fontSize:(CGFloat)size;
+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector;
+ (UIView *)createViewWithBackgroundColor:(UIColor *)color frame:(CGRect)frame;
+ (UIImageView *)createImageViewWithframe:(CGRect)frame Image:(NSString *)imageStr Radius:(CGFloat)radius;
+ (UITextField *)createTextFieldWithframe:(CGRect)frame placeholder:(NSString *)placeholder Font:(CGFloat)font;

//获取当前的北京时间
+(NSString *)getBeijingNowTime;
+(NSString *)getBeijingDate;
+(NSString *)getBeijingDateWithFormatStr:(NSString *)formatStr;
+(NSString *)getBeijingDateWithTimeStr:(NSString *)timeStr FormatStr:(NSString *)formatStr;
+(NSString *)getBeijingLastDate;
//把图片按照新大小进行裁剪，生成一个新图片
+ (UIImage*) imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *) sourceImage;
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
+ (NSString *)getCurrentDeviceModel;

+ (NSString *)yihuoStrWithString:(NSString *)codeStr;

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
//绘制layer截图
+ (UIImage *)captureView:(UIView *)view;
//绘制View截图
+ (UIImage *)snapshotScreenInView:(UIView *)contentView;

/**
 获取当前视图控制器

 @return 当前视图控制器
 */
+ (UIViewController *)getCurrentViewController;

/**
 获取当前响应的视图控制器

 @return 当前响应的视图控制器
 */
+ (UIViewController *)getCurrentResponderViewController;

/**
 获取当前view所在的视图控制器

 @param currentView 当前的view
 @return view所在的视图控制器
 */
+ (UIViewController *)getViewControllerWithView:(UIView *)currentView;

/**
 获取当前的模态视图控制器

 @return 当前的模态视图控制器
 */
+ (UIViewController *)getCurrentPresentedViewController;

/**
 description Alert iOS9.0之后新增功能
 
 */
+(void)showAlertVC:(UIViewController*)vc Alert:(NSString *)string;

/**
 NSArray or NSDictionary 转化为json字符串
 */
+ (NSString *)jsonStringWithObject:(id)object;

+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;

@end
