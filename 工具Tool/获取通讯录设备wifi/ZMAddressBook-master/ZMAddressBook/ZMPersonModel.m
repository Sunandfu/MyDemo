//
//  ZMPersonModel.m
//  ZMAddressBook
//
//  Created by ZengZhiming on 2017/4/7.
//  Copyright © 2017年 菜鸟基地. All rights reserved.
//

#import "ZMPersonModel.h"

@implementation ZMPersonModel


/**
 使用ABRecordRef来初始化Model
 
 @param person ABRecordRef对象
 @return model
 */
- (instancetype)initWithPerson:(ABRecordRef)person
{
    self = [super init];
    if (self) {
        // 设置属性值
        [self setValueWithPerson:person];
    }
    return self;
}


/**
 设置属性值
 */
- (void)setValueWithPerson:(ABRecordRef)person
{
    // 空值过滤
    if (person == NULL) {
        return;
    }
    
    /** 获取RecordID */
    _recordID = ABRecordGetRecordID(person);
    
    /** 姓名相关 */
    _firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));  //!< 名字.
    _lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));    //!< 姓氏.
    _middleName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));//!< 中间名.
    _prefix = CFBridgingRelease(ABRecordCopyValue(person, kABPersonPrefixProperty));        //!< 前缀.
    _suffix = CFBridgingRelease(ABRecordCopyValue(person, kABPersonSuffixProperty));        //!< 后缀.
    _nickname = CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty));    //!< 昵称.
    _firstNamePhonetic = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));  //!< 名字拼音或音标.
    _lastNamePhonetic = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty));    //!< 姓氏拼音或音标.
    _middleNamePhonetic = CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty));//!< 中间名拼音或音标.
    
    /** 工作相关 */
    _organization =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty));   //!< 公司名称.
    _department =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty));       //!< 部门.
    _jobTitle =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonJobTitleProperty));           //!< 职位.
    
    /** 备注 */
    _note =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonNoteProperty));                   //!< 备注.
    
    /** 日期相关 */
    _birthday =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty));                //!< 生日.
    _creationDate = CFBridgingRelease(ABRecordCopyValue(person, kABPersonCreationDateProperty));         //!< 创建时间.
    _modificationDate = CFBridgingRelease(ABRecordCopyValue(person, kABPersonModificationDateProperty)); //!< 最近修改时间.
    
    /** 农历生日 */
    
    NSDictionary *brithdayDict = CFBridgingRelease(ABRecordCopyValue(person, kABPersonAlternateBirthdayProperty));
    if (!IsNullDictionary(brithdayDict))
    {
        ZMAlternateBirthdayModel *brithdayModel = [[ZMAlternateBirthdayModel alloc] init];
        // 标志
        brithdayModel.calendar = [brithdayDict valueForKey:(NSString *)kABPersonAlternateBirthdayCalendarIdentifierKey];
        // 纪元
        brithdayModel.era = [[brithdayDict valueForKey:(NSString *)kABPersonAlternateBirthdayEraKey] integerValue];
        // 年份
        brithdayModel.year = [[brithdayDict valueForKey:(NSString *)kABPersonAlternateBirthdayYearKey] integerValue];
        // 月份
        brithdayModel.month = [[brithdayDict valueForKey:(NSString *)kABPersonAlternateBirthdayMonthKey] integerValue];
        // 日期
        brithdayModel.day = [[brithdayDict valueForKey:(NSString *)kABPersonAlternateBirthdayDayKey] integerValue];
        // 是否闰月
        brithdayModel.leapMonth = [[brithdayDict valueForKey:(NSString *)kABPersonAlternateBirthdayIsLeapMonthKey] boolValue];
    
        _alternateBirthday = brithdayModel;
    }
    
    
    /** 分类 */
    CFNumberRef kindType = ABRecordCopyValue(person, kABPersonKindProperty);
    _kind = (kindType == kABPersonKindOrganization) ? KindOrganization : KindPerson;
    if (kindType != NULL) CFRelease(kindType);
    
    /** 头像 */
    if (ABPersonHasImageData(person) == true) {
        // 获得头像原图
        NSData *imageData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize));
        _headImage = [UIImage imageWithData:imageData];
    }
    
    /** 电子邮件列表 */
    NSMutableArray<ZMLabelStringModel *> *emailArray = [NSMutableArray array];
    ABMultiValueRef emailRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i = 0; i < ABMultiValueGetCount(emailRef); i++)
    {
        ZMLabelStringModel *emailModel = [[ZMLabelStringModel alloc] init];
        // 标签
        emailModel.label    = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(emailRef, i));;
        // 邮箱地址
        emailModel.content  = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emailRef, i));
        // 添加到数组
        [emailArray addObject:emailModel];
    }
    if (emailRef) CFRelease(emailRef);
    _emails = emailArray;
    
    /** 地址列表 */
    NSMutableArray<ZMAddressModel *> *addressArray = [NSMutableArray array];
    ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
    for(int i = 0; i < ABMultiValueGetCount(addressRef); i++)
    {
        ZMAddressModel *addressModel = [[ZMAddressModel alloc] init];
        // 标签
        addressModel.label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(addressRef, i));
        // 获取地址字典
        NSDictionary *addressDict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(addressRef, i));
        if (!IsNullDictionary(addressDict)) {
            // 街道
            addressModel.street      = [addressDict valueForKey:(NSString *)kABPersonAddressStreetKey];
            // 城市
            addressModel.city        = [addressDict valueForKey:(NSString *)kABPersonAddressCityKey];
            // 省
            addressModel.state       = [addressDict valueForKey:(NSString *)kABPersonAddressStateKey];
            // 邮政编码
            addressModel.zip         = [addressDict valueForKey:(NSString *)kABPersonAddressZIPKey];
            // 国家
            addressModel.country     = [addressDict valueForKey:(NSString *)kABPersonAddressCountryKey];
            // 国别码
            addressModel.countryCode = [addressDict valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        }
        // 添加到数组
        [addressArray addObject:addressModel];
    }
    if (addressRef) CFRelease(addressRef);
    _addresses = addressArray;
    
    /** 日期列表 */
    NSMutableArray <ZMLabelDateModel *> *dateArray = [NSMutableArray array];
    ABMultiValueRef dateRef = ABRecordCopyValue(person, kABPersonDateProperty);
    for (int i = 0; i < ABMultiValueGetCount(dateRef); i++)
    {
        ZMLabelDateModel *dateModel = [[ZMLabelDateModel alloc] init];
        // 标签
        dateModel.label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(dateRef, i));
        // 日期
        dateModel.date  = CFBridgingRelease(ABMultiValueCopyValueAtIndex(dateRef, i));
        // 添加到数组
        [dateArray addObject:dateModel];
    }
    if (dateRef) CFRelease(dateRef);
    _dates = dateArray;
    
    /** 电话列表 */
    NSMutableArray<ZMLabelStringModel *> *phoneArray = [NSMutableArray array];
    ABMultiValueRef phoneRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i = 0; i < ABMultiValueGetCount(phoneRef); i++)
    {
        ZMLabelStringModel *phoneModel = [[ZMLabelStringModel alloc] init];
        // 标签
        phoneModel.label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneRef, i));
        // 电话号码
        phoneModel.content = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneRef, i));
        // 添加到数组
        [phoneArray addObject:phoneModel];
    }
    if (phoneRef) CFRelease(phoneRef);
    _phones = phoneArray;
    
    /** 即时信息列表 */
    NSMutableArray<ZMInstantMessageModel *> *instantMessageArray = [NSMutableArray array];
    ABMultiValueRef instantMessageRef = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
    for (int i = 1; i < ABMultiValueGetCount(instantMessageRef); i++)
    {
        ZMInstantMessageModel *instantMessageModel = [[ZMInstantMessageModel alloc] init];
        // 标签
        instantMessageModel.label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(instantMessageRef, i));
        // 获取即时信息字典
        NSDictionary *instantMessageDict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(instantMessageRef, i));
        if (!IsNullDictionary(instantMessageDict)) {
            // 服务账号
            instantMessageModel.username = [instantMessageDict valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            // 服务名称
            instantMessageModel.service = [instantMessageDict valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
        }
        // 添加到数组
        [instantMessageArray addObject:instantMessageModel];
    }
    if (instantMessageRef) CFRelease(instantMessageRef);
    _instantMessages = instantMessageArray;
    
    /** URL列表 */
    NSMutableArray<ZMLabelStringModel *> *urlArray = [NSMutableArray array];
    ABMultiValueRef urlRef = ABRecordCopyValue(person, kABPersonURLProperty);
    for (int i = 0; i < ABMultiValueGetCount(urlRef); i++)
    {
        ZMLabelStringModel *urlModel = [[ZMLabelStringModel alloc] init];
        // 标签
        urlModel.label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(urlRef,i));
        // URL地址
        urlModel.content = CFBridgingRelease(ABMultiValueCopyValueAtIndex(urlRef,i));
        // 添加到数组
        [urlArray addObject:urlModel];
    }
    if (urlRef) CFRelease(urlRef);
    _urls = urlArray;
    
    /** 关联人列表 */
    NSMutableArray<ZMLabelStringModel *> *relatedNameArray = [NSMutableArray array];
    ABMultiValueRef relatedNameRef = ABRecordCopyValue(person, kABPersonRelatedNamesProperty);
    for (int i = 0; i < ABMultiValueGetCount(relatedNameRef); i++)
    {
        ZMLabelStringModel *relatedNameModel = [[ZMLabelStringModel alloc] init];
        // 标签
        relatedNameModel.label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(relatedNameRef, i));
        // 关联人姓名
        relatedNameModel.content = CFBridgingRelease(ABMultiValueCopyValueAtIndex(relatedNameRef, i));
        // 添加到数组
        [relatedNameArray addObject:relatedNameModel];
    }
    if (relatedNameRef) CFRelease(relatedNameRef);
    _relatedNames = relatedNameArray;
    
    /** 社交资料列表 */
    NSMutableArray<ZMSocialProfileModel *> *socialProfileArray = [NSMutableArray array];
    ABMultiValueRef socialProfileRef = ABRecordCopyValue(person, kABPersonSocialProfileProperty);
    for (int i = 0 ; i < ABMultiValueGetCount(socialProfileRef); i++)
    {
        // 获取社交资料字典
        NSDictionary *socialProfileDict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(socialProfileRef, i));
        if (!IsNullDictionary(socialProfileDict)) {
            ZMSocialProfileModel *socialProfileModel = [[ZMSocialProfileModel alloc] init];
            // 社交链接
            socialProfileModel.url = [socialProfileDict valueForKey:(NSString *)kABPersonSocialProfileURLKey];
            // 服务名称
            socialProfileModel.service = [socialProfileDict valueForKey:(NSString *)kABPersonSocialProfileServiceKey];
            // 社交服务账号
            socialProfileModel.username = [socialProfileDict valueForKey:(NSString *)kABPersonSocialProfileUsernameKey];
            // 用户标识
            socialProfileModel.userIdentifier = [socialProfileDict valueForKey:(NSString *)kABPersonSocialProfileUserIdentifierKey];
            // 添加到数组
            [socialProfileArray addObject:socialProfileModel];
        }
    }
    if (socialProfileRef) CFRelease(socialProfileRef);
    _socialProfiles = socialProfileArray;
}


/**
 将Model转为ABRecordRef返回

 @return ABRecordRef对象
 */
- (ABRecordRef)getRecordRef
{
    // 创建新person
    ABRecordRef person = ABPersonCreate();
    
    // 将Model数据更新到person中
    [self updateToRecordRef:person];
    
    // 返回person
    return CFAutorelease(person);
}


/**
 将Model数据赋值到ABRecordRef
 
 @param person ABRecordRef对象
 @return 赋值结果
 */
- (BOOL)updateToRecordRef:(ABRecordRef)person
{
    // 空值处理
    if (person == NULL) {
        return NO;
    }
    
    // 实例化CFErrorRef
    CFErrorRef errorRef = NULL;
    
    /** 姓名相关 */
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)(_firstName), &errorRef);  //!< 名字.
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)(_lastName), &errorRef);    //!< 姓氏.
    ABRecordSetValue(person, kABPersonMiddleNameProperty, (__bridge CFStringRef)(_middleName), &errorRef);//!< 中间名.
    ABRecordSetValue(person, kABPersonPrefixProperty, (__bridge CFStringRef)(_prefix), &errorRef);        //!< 前缀.
    ABRecordSetValue(person, kABPersonSuffixProperty, (__bridge CFStringRef)(_suffix), &errorRef);        //!< 后缀.
    ABRecordSetValue(person, kABPersonNicknameProperty, (__bridge CFStringRef)(_nickname), &errorRef);    //!< 昵称.
    ABRecordSetValue(person, kABPersonFirstNamePhoneticProperty, (__bridge CFStringRef)(_firstNamePhonetic), &errorRef);  //!< 名字拼音或音标.
    ABRecordSetValue(person, kABPersonLastNamePhoneticProperty, (__bridge CFStringRef)(_lastNamePhonetic), &errorRef);    //!< 姓氏拼音或音标.
    ABRecordSetValue(person, kABPersonMiddleNamePhoneticProperty, (__bridge CFStringRef)(_middleNamePhonetic), &errorRef);//!< 中间名拼音或音标.
    
    /** 工作相关 */
    ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFStringRef)(_organization), &errorRef);//!< 公司名称.
    ABRecordSetValue(person, kABPersonDepartmentProperty, (__bridge CFStringRef)(_department), &errorRef);    //!< 部门.
    ABRecordSetValue(person, kABPersonJobTitleProperty, (__bridge CFStringRef)(_jobTitle), &errorRef);        //!< 职位.
    
    /** 备注 */
    ABRecordSetValue(person, kABPersonNoteProperty, (__bridge CFStringRef)(_note), &errorRef);                //!< 备注.
    
    /** 日期相关 */
    ABRecordSetValue(person, kABPersonBirthdayProperty, (__bridge CFDateRef)(_birthday), &errorRef);                //!< 生日.
    ABRecordSetValue(person, kABPersonCreationDateProperty, (__bridge CFDateRef)(_creationDate), &errorRef);        //!< 创建时间.
    ABRecordSetValue(person, kABPersonModificationDateProperty, (__bridge CFDateRef)(_modificationDate), &errorRef);//!< 最近修改时间.
    
    /** 农历生日 */
    if (_alternateBirthday)
    {
        NSMutableDictionary *brithdayDict = [NSMutableDictionary dictionary];
        // 标志
        brithdayDict[(NSString *)kABPersonAlternateBirthdayCalendarIdentifierKey] = _alternateBirthday.calendar;
        // 纪元
        brithdayDict[(NSString *)kABPersonAlternateBirthdayEraKey] = @(_alternateBirthday.era);
        // 年份
        brithdayDict[(NSString *)kABPersonAlternateBirthdayYearKey] = @(_alternateBirthday.year);
        // 月份
        brithdayDict[(NSString *)kABPersonAlternateBirthdayMonthKey] = @(_alternateBirthday.month);
        // 日期
        brithdayDict[(NSString *)kABPersonAlternateBirthdayDayKey] = @(_alternateBirthday.day);
        // 是否闰月
        brithdayDict[(NSString *)kABPersonAlternateBirthdayIsLeapMonthKey] = @(_alternateBirthday.leapMonth);
        
        ABRecordSetValue(person, kABPersonAlternateBirthdayProperty, (__bridge CFDictionaryRef)(brithdayDict), &errorRef);
    }
    
    /** 分类 */
    CFNumberRef personKind = (_kind == KindOrganization) ? kABPersonKindOrganization : kABPersonKindPerson;
    ABRecordSetValue(person, kABPersonKindProperty, personKind, &errorRef);
    
    /** 头像 */
    if (_headImage) {
        NSData *imageData = UIImagePNGRepresentation(_headImage);
        ABPersonSetImageData(person, (__bridge CFDataRef)(imageData),&errorRef);
    }
    
    /** 电子邮件列表 */
    ABMultiValueRef emailRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (ZMLabelStringModel *emailModel in _emails) {
        ABMultiValueAddValueAndLabel(emailRef, (__bridge CFStringRef)(emailModel.content), (__bridge CFStringRef)(emailModel.label), NULL);
    }
    ABRecordSetValue(person, kABPersonEmailProperty, emailRef, &errorRef);
    if (emailRef) CFRelease(emailRef);
    
    /** 地址列表 */
    ABMultiValueRef addressRef = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    for (ZMAddressModel *addressModel in _addresses)
    {
        NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
        // 街道
        addressDict[(NSString *)kABPersonAddressStreetKey] = addressModel.street;
        // 城市
        addressDict[(NSString *)kABPersonAddressCityKey] = addressModel.city;
        // 省
        addressDict[(NSString *)kABPersonAddressStateKey] = addressModel.state;
        // 邮政编码
        addressDict[(NSString *)kABPersonAddressZIPKey] = addressModel.zip;
        // 国家
        addressDict[(NSString *)kABPersonAddressCountryKey] = addressModel.country;
        // 国别码
        addressDict[(NSString *)kABPersonAddressCountryCodeKey] = addressModel.countryCode;
        
        ABMultiValueAddValueAndLabel(addressRef, (__bridge CFDictionaryRef)(addressDict), (__bridge CFStringRef)addressModel.label, NULL);
    }
    ABRecordSetValue(person, kABPersonAddressProperty, addressRef, &errorRef);
    if (addressRef) CFRelease(addressRef);
    
    /** 日期列表 */
    ABMultiValueRef dateRef = ABMultiValueCreateMutable(kABMultiDateTimePropertyType);
    for (ZMLabelDateModel *dateModel in _dates) {
        ABMultiValueAddValueAndLabel(dateRef, (__bridge CFDateRef)(dateModel.date), (__bridge CFStringRef)(dateModel.label), NULL);
    }
    ABRecordSetValue(person, kABPersonDateProperty, dateRef, &errorRef);
    if (dateRef) CFRelease(dateRef);
    
    /** 电话列表 */
    ABMultiValueRef phoneRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (ZMLabelStringModel *phoneModel in _phones) {
        ABMultiValueAddValueAndLabel(phoneRef, (__bridge CFStringRef)(phoneModel.content), (__bridge CFStringRef)(phoneModel.label), NULL);
    }
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneRef, &errorRef);
    if (phoneRef) CFRelease(phoneRef);
    
    /** 即时信息列表 */
    ABMultiValueRef instantMessageRef = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    for (ZMInstantMessageModel *instantMessageModel in _instantMessages)
    {
        NSMutableDictionary *instantMessageDict = [NSMutableDictionary dictionary];
        // 服务账号
        instantMessageDict[(NSString *)kABPersonInstantMessageUsernameKey] = instantMessageModel.username;
        // 服务名称
        instantMessageDict[(NSString *)kABPersonInstantMessageServiceKey] = instantMessageModel.service;
        
        ABMultiValueAddValueAndLabel(instantMessageRef, (__bridge CFDictionaryRef)(instantMessageDict), (__bridge CFStringRef)instantMessageModel.label, NULL);
    }
    ABRecordSetValue(person, kABPersonInstantMessageProperty, instantMessageRef, &errorRef);
    if (instantMessageRef) CFRelease(instantMessageRef);
    
    /** URL列表 */
    ABMultiValueRef urlRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (ZMLabelStringModel *urlModel in _urls) {
        ABMultiValueAddValueAndLabel(urlRef, (__bridge CFStringRef)(urlModel.content), (__bridge CFStringRef)(urlModel.label), NULL);
    }
    ABRecordSetValue(person, kABPersonURLProperty, urlRef, &errorRef);
    if (urlRef) CFRelease(urlRef);
    
    /** 关联人列表 */
    ABMultiValueRef relatedNameRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (ZMLabelStringModel *relatedNameModel in _relatedNames) {
        ABMultiValueAddValueAndLabel(relatedNameRef, (__bridge CFStringRef)(relatedNameModel.content), (__bridge CFStringRef)(relatedNameModel.label), NULL);
    }
    ABRecordSetValue(person, kABPersonRelatedNamesProperty, relatedNameRef, &errorRef);
    if (relatedNameRef) CFRelease(relatedNameRef);
    
    /** 社交资料列表 */
    ABMultiValueRef socialProfileRef = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    for (ZMSocialProfileModel *socialProfileModel in _socialProfiles)
    {
        NSMutableDictionary *socialProfileDict = [NSMutableDictionary dictionary];
        // 社交链接
        socialProfileDict[(NSString *)kABPersonSocialProfileURLKey] = socialProfileModel.url;
        // 服务名称
        socialProfileDict[(NSString *)kABPersonSocialProfileServiceKey] = socialProfileModel.service;
        // 社交服务账号
        socialProfileDict[(NSString *)kABPersonSocialProfileUsernameKey] = socialProfileModel.username;
        // 用户标识
        socialProfileDict[(NSString *)kABPersonSocialProfileUserIdentifierKey] = socialProfileModel.userIdentifier;
        
        ABMultiValueAddValueAndLabel(socialProfileRef, (__bridge CFDictionaryRef)(socialProfileDict), NULL, NULL);
    }
    ABRecordSetValue(person, kABPersonSocialProfileProperty, socialProfileRef, &errorRef);
    if (socialProfileRef) CFRelease(socialProfileRef);
    
    // 错误消息处理
    if (errorRef) {
        NSLog(@"ZMPersonModel to RecordRef error:%@", errorRef);
        CFRelease(errorRef);
        return NO;
    }
    
    return YES;
}


@end


#pragma mark - 子Model


/** String标签Model */
@implementation ZMLabelStringModel


@end


/** Date标签Model */
@implementation ZMLabelDateModel


@end


/** 即时信息Model */
@implementation ZMInstantMessageModel


@end


/** 社交资料Model */
@implementation ZMSocialProfileModel


@end


/** 农历生日Model */
@implementation ZMAlternateBirthdayModel


@end


/** 地址Model */
@implementation ZMAddressModel


@end
