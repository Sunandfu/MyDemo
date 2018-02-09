//
//  HTBodyfat.h
//
//  Created by Holtek on 16/9/28.
//  Copyright © 2016年 Holtek. All rights reserved.
//
//  Version: 2.00
//
#import <UIKit/UIKit.h>


///性别类型
typedef NS_ENUM(NSInteger, SexType){
    Female = 0,        //!< 女性
    Male  = 1          //!< 男性
};

///错误类型(针对输入的参数)
typedef NS_ENUM(NSInteger, BodyfatErrorType){
    ErrorTypeNone,         //!< 无错误
    ErrorTypeImpedance,    //!< 阻抗有误,阻抗有误时, 依然可以获取BMI,但其他体成分参数为0
    ErrorTypeAge,          //!< 年龄参数有误，需在 6   ~ 80岁
    ErrorTypeWeight,       //!< 体重参数有误，需在 10  ~ 200kg
    ErrorTypeHeight        //!< 身高参数有误，需在 100 ~ 220cm
    
};

///people类型
typedef NS_ENUM(NSInteger, PeopleType){
    PeopleTypeOrdinary,     //!< 普通人
    PeopleTypeAmatuer,      //!< 业余运动员
    PeopleTypeProfession    //!< 专业运动员
};


#pragma mark - HTGeneralPeople
/// 计算体脂参数所需数据model
@interface HTPeopleGeneral : NSObject

@property (nonatomic,assign) SexType          sex;         //!< 性别

@property (nonatomic,assign) CGFloat          weightKg;    //!< 体重(kg)，需在 10  ~ 200kg

@property (nonatomic,assign) CGFloat          heightCm;    //!< 身高(cm)，需在 100 ~ 220cm

@property (nonatomic,assign) NSInteger        age;         //!< 年龄(岁)，需在6 ~ 80岁

@property (nonatomic,assign) PeopleType       peopleType;  //!< 测量者类型，普通人、业余运动员、专业运动员

@property (nonatomic,assign) CGFloat          ZTwoLegs;    //!< 脚对脚阻抗值(Ω), 范围200.0 ~ 1200.0

@property (nonatomic,assign) CGFloat          BMI;         //!< Body Mass Index 人体质量指数, 分辨率0.1, 范围10.0 ~ 90.0

@property (nonatomic,assign) NSInteger        BMR;         //!< Basal Metabolic Rate基础代谢, 分辨率1, 范围500 ~ 10000

@property (nonatomic,assign) NSInteger        VFAL;        //!< Visceral fat area leverl内脏脂肪, 分辨率1, 范围1 ~ 50

@property (nonatomic,assign) CGFloat          boneKg;      //!< 骨量(kg), 分辨率0.1, 范围0.5 ~ 8.0

@property (nonatomic,assign) CGFloat          bodyfatPercentage;    //!< 脂肪率(%), 分辨率0.1, 范围1.0% ~ 45.0%

@property (nonatomic,assign) CGFloat          waterPercentage;      //!< 水分率(%), 分辨率0.1, 范围35.0% ~ 75.0%

@property (nonatomic,assign) CGFloat          muscleKg;     //!< 肌肉量(kg), 分辨率0.1, 范围10.0 ~ 120.0

/**
 *  根据人体数据计算体脂参数
 *
 *  @param peopleType 测量者类型
 *  @param weightKg   体重，单位kg
 *  @param heightCm   身高，单位cm
 *  @param sex        性别
 *  @param age        年龄
 *  @param impedance  阻抗系数
 *
 *  @return 人体数据是否有误，计算成功则返回ErrorTypeNone
 */
- (BodyfatErrorType )getBodyfatWithPeopleType:(PeopleType)peopleType weightKg:(CGFloat)weightKg heightCm:(CGFloat)heightCm sex:(SexType)sex age:(NSInteger)age impedance:(NSInteger)impedance;

@end

