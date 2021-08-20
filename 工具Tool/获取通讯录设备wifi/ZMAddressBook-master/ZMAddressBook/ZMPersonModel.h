//
//  ZMPersonModel.h
//  ZMAddressBook
//
//  Created by ZengZhiming on 2017/4/7.
//  Copyright © 2017年 菜鸟基地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@class ZMAlternateBirthdayModel;
@class ZMLabelStringModel;
@class ZMLabelDateModel;
@class ZMAddressModel;
@class ZMInstantMessageModel;
@class ZMSocialProfileModel;


#pragma mark - 类型枚举

typedef enum : NSUInteger {
    KindPerson,
    KindOrganization,
} KindType;


#pragma mark - 主Model

@interface ZMPersonModel : NSObject

@property (nonatomic, assign) ABRecordID recordID;          //!< 联系人ID.

/** 姓名相关 */
@property (nonatomic, strong) NSString *firstName;          //!< 名字.
@property (nonatomic, strong) NSString *lastName;           //!< 姓氏.
@property (nonatomic, strong) NSString *middleName;         //!< 中间名.
@property (nonatomic, strong) NSString *prefix;             //!< 前缀.
@property (nonatomic, strong) NSString *suffix;             //!< 后缀.
@property (nonatomic, strong) NSString *nickname;           //!< 昵称.
@property (nonatomic, strong) NSString *firstNamePhonetic;  //!< 名字拼音或音标.
@property (nonatomic, strong) NSString *lastNamePhonetic;   //!< 姓氏拼音或音标.
@property (nonatomic, strong) NSString *middleNamePhonetic; //!< 中间名拼音或音标.

/** 工作相关 */
@property (nonatomic, strong) NSString *organization;       //!< 公司名称.
@property (nonatomic, strong) NSString *department;         //!< 部门.
@property (nonatomic, strong) NSString *jobTitle;           //!< 职位.

/** 备注 */
@property (nonatomic, strong) NSString *note;               //!< 备注.

/** 日期相关 */
@property (nonatomic, strong) NSDate   *birthday;           //!< 生日.
@property (nonatomic, strong) NSDate   *creationDate;       //!< 创建时间.
@property (nonatomic, strong) NSDate   *modificationDate;   //!< 最近修改时间.
@property (nonatomic, strong) ZMAlternateBirthdayModel *alternateBirthday; //!< 农历生日.

/** 其他 */
@property (nonatomic, assign) KindType kind;                //!< 分类.
@property (nonatomic, strong) UIImage  *headImage;          //!< 头像.

/** 多值属性 */
@property (nonatomic, strong) NSArray<ZMLabelStringModel *> *emails;            //!< 电子邮件列表.
@property (nonatomic, strong) NSArray<ZMAddressModel *> *addresses;             //!< 地址列表.
@property (nonatomic, strong) NSArray<ZMLabelDateModel *> *dates;               //!< 日期列表.
@property (nonatomic, strong) NSArray<ZMLabelStringModel *> *phones;            //!< 电话列表.
@property (nonatomic, strong) NSArray<ZMInstantMessageModel *> *instantMessages;//!< 即时信息列表.
@property (nonatomic, strong) NSArray<ZMLabelStringModel *> *urls;              //!< URL列表.
@property (nonatomic, strong) NSArray<ZMLabelStringModel *> *relatedNames;      //!< 关联人列表.
@property (nonatomic, strong) NSArray<ZMSocialProfileModel *> *socialProfiles;  //!< 社交资料列表.


/**
 使用ABRecordRef来初始化Model
 
 @param person ABRecordRef对象
 @return model
 */
- (instancetype)initWithPerson:(ABRecordRef)person;


/**
 将Model转为ABRecordRef返回
 
 @return ABRecordRef对象
 */
- (ABRecordRef)getRecordRef;


/**
 将Model数据赋值到ABRecordRef
 
 @param person ABRecordRef对象
 @return 赋值结果
 */
- (BOOL)updateToRecordRef:(ABRecordRef)person;


@end


#pragma mark - 子Model


/** String标签Model */
@interface ZMLabelStringModel : NSObject

@property (nonatomic, strong) NSString *label;  //!< Label标签.
@property (nonatomic, strong) NSString *content;//!< Content内容.

@end


/** Date标签Model */
@interface ZMLabelDateModel : NSObject

@property (nonatomic, strong) NSString *label;  //!< Label标签.
@property (nonatomic, strong) NSDate   *date;   //!< date日期.

@end


/** 即时信息Model */
@interface ZMInstantMessageModel : NSObject

@property (nonatomic, strong) NSString *label;      //!< Label标签.
@property (nonatomic, strong) NSString *username;   //!< 服务账号(如QQ号).
@property (nonatomic, strong) NSString *service;    //!< 服务名称(如QQ).

@end


/** 社交资料Model */
@interface ZMSocialProfileModel : NSObject

@property (nonatomic, strong) NSString *url;            //!< 社交链接的地址(按照下面两项自动为http://weibo.com/n/123456).
@property (nonatomic, strong) NSString *service;        //!< 社交服务名称(如sinaweibo).
@property (nonatomic, strong) NSString *username;       //!< 社交服务账号(如123456).
@property (nonatomic, strong) NSString *userIdentifier; //!< 用户标识.

@end


/** 农历生日Model */
@interface ZMAlternateBirthdayModel : NSObject

@property (nonatomic, strong) NSString *calendar;   //!< 标志,比如“chinese”.
@property (nonatomic, assign) NSInteger era;        //!< 纪元.
@property (nonatomic, assign) NSInteger year;       //!< 年份.
@property (nonatomic, assign) NSInteger month;      //!< 月份.
@property (nonatomic, assign) NSInteger day;        //!< 日期.
@property (nonatomic, assign) NSInteger leapMonth;  //!< 是否闰月.

@end


/** 地址Model */
@interface ZMAddressModel : NSObject

@property (nonatomic, strong) NSString *label;      //!< Label标签.
@property (nonatomic, strong) NSString *street;     //!< 街道.
@property (nonatomic, strong) NSString *city;       //!< 城市.
@property (nonatomic, strong) NSString *state;      //!< 省.
@property (nonatomic, strong) NSString *zip;        //!< 邮政编码.
@property (nonatomic, strong) NSString *country;    //!< 国家.
@property (nonatomic, strong) NSString *countryCode;//!< 国别码.


@end
