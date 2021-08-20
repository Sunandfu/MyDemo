//
//  ZMAddressBookManager.m
//  ZMAddressBook
//
//  Created by ZengZhiming on 2017/4/6.
//  Copyright © 2017年 菜鸟基地. All rights reserved.
//

#import "ZMAddressBookManager.h"
#import <AddressBook/AddressBook.h>

@interface ZMAddressBookManager ()

/** 通讯录 */
@property (nonatomic, assign) ABAddressBookRef addressBook;
/** 排序方式 */
@property (nonatomic, assign) PersonSort personSort;
/** 完成回调 */
@property (nonatomic, copy) void(^completionBlock)(int code, NSArray<ZMPersonModel *> *personArray, NSString *msg);

@end

@implementation ZMAddressBookManager


/** 获取单例对象 */
+ (instancetype)getInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


/** 重新初始化方法 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 创建AddressBook
        _addressBook = ABAddressBookCreate();
        // 注册通讯录变动的回调
        ABAddressBookRegisterExternalChangeCallback(_addressBook, addressBookChangeCallBack, (__bridge_retained void *)(self));
    }
    return self;
}


/**
 通讯录联系人变动的回调
 
 @param addressBook 注册的addressBook
 @param info        变动之后进行的回调方法
 @param context     传参，这里是将自己作为参数传到方法中
 */
void addressBookChangeCallBack(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    // 清除缓存,重置addressBook
    ABAddressBookRevert(addressBook);
    
    // 获取ZMAddressBookManager单例对象
    ZMAddressBookManager *addressBookManager = [ZMAddressBookManager getInstance];
    if (addressBookManager.completionBlock) {
        [addressBookManager getAddressBookPersonListWithSort:addressBookManager.personSort completionBlock:addressBookManager.completionBlock];
    }
}


/**
 获取通讯录联系人列表
 
 @param personSort 排序方式
 @param completionBlock 完成回调
            code 等于1成功,否则失败
            personArray 成功返回ZMPersonModel数组, 失败返回nil
            msg 成功或者失败消息
 */
- (void)getAddressBookWithSort:(PersonSort)personSort completionBlock:(void (^)(int code, NSArray<ZMPersonModel *> *personArray, NSString *msg))completionBlock
{
    // 判断权限
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusNotDetermined:   //!< 未选择权限.
        {
            // 请求通讯录访问权限
            [self requestAddressBookAccessWithCompletion:^(int code, NSString *msg) {
                if (code == 1) {
                    // 异步获取通讯录人员列表
                    [self getAddressBookPersonListWithSort:personSort completionBlock:completionBlock];
                } else {
                    // 请求通讯录访问权限失败
                    if (completionBlock) completionBlock(code, nil, msg);
                }
            }];
        }
            break;
        case kABAuthorizationStatusRestricted:      //!< 权限被限制.
        {
            if (completionBlock) completionBlock(-1, nil, @"通讯录访问权限被限制");
        }
            break;
        case kABAuthorizationStatusDenied:          //!< 已拒绝权限.
        {
            if (completionBlock) completionBlock(-1, nil, @"通讯录访问权限被拒绝");
        }
            break;
        case kABAuthorizationStatusAuthorized:      //!< 已授权.
        {
            // 异步获取通讯录人员列表
            [self getAddressBookPersonListWithSort:personSort completionBlock:completionBlock];
        }
            break;
            
        default:
            break;
    }
}


/**
 请求通讯录访问权限

 @param completion 权限回调
 */
- (void)requestAddressBookAccessWithCompletion:(void (^)(int code, NSString *msg))completion
{
    // 请求访问用户通讯录,注意无论成功与否block都会调用
    ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
        // 回调到主线程返回结果
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (completion) completion(1, @"请求通讯录访问权限成功");
            } else {
                if (completion) completion(-1, @"请求通讯录访问权限失败");
            }
        });
    });
}


/**
 异步获取通讯录联系人列表

 @param personSort 排序方式
 @param completionBlock 完成回调
            code 等于1成功,否则失败
            personArray 成功返回ZMPersonModel数组, 失败返回nil
            msg 成功或者失败消息
 */
- (void)getAddressBookPersonListWithSort:(PersonSort)personSort completionBlock:(void (^)(int code, NSArray<ZMPersonModel *> *personArray, NSString *msg))completionBlock
{
    // 记录获取参数
    _completionBlock = completionBlock;
    _personSort = personSort;
    
    // 在默认并行队列的异步子线程中处理.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 获取通讯录数据
        NSArray<ZMPersonModel *> *personArray = [self getAddressBookPersonListWithSort:personSort];
        
        // 回调到主线程.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (personArray != nil) {
                if (completionBlock) completionBlock(1, personArray, @"获取通讯录数据成功");
            } else {
                if (completionBlock) completionBlock(-1, nil, @"通讯录访问权限失败");
            }
        });
    });
}


/**
 *  同步获取通讯录联系人列表
 *
 *  @return 通讯录ZMPersonModel数组
 */
- (NSArray<ZMPersonModel *> *)getAddressBookPersonListWithSort:(PersonSort)personSort
{
    // 检测权限
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return nil;
    }

    // 按照排序读取所有联系人
    CFArrayRef allPerson = NULL;
    switch (personSort) {
        case SortByFirstName:   //!< 名字排序.
            allPerson = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(_addressBook, kABSourceTypeLocal, kABPersonSortByFirstName);
            break;
        case SortByLastName:    //!< 姓氏排序.
            allPerson = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(_addressBook, kABSourceTypeLocal, kABPersonSortByLastName);
            break;
        case SortByCreationTime://!< 创建时间排序.
        default:
            allPerson = ABAddressBookCopyArrayOfAllPeople(_addressBook);
            break;
    }
    
    // 存储通讯录的数组
    NSMutableArray<ZMPersonModel *> *addressBookArray = [NSMutableArray array];

    // 循环遍历，获取每个联系人信息
    for (NSInteger i = 0; i < CFArrayGetCount(allPerson); i++)  {
        ABRecordRef person = CFArrayGetValueAtIndex(allPerson, i);
        ZMPersonModel *personModel =  [[ZMPersonModel alloc] initWithPerson:person];
        [addressBookArray addObject:personModel];
    }
    
    // 释放资源
    if (allPerson) CFRelease(allPerson);
    
    return addressBookArray;
}


/**
 根据RecordID查找联系人

 @param recordID 联系人ID
 @return ZMPersonModel对象
 */
- (ZMPersonModel *)getPersonWithRecordID:(ABRecordID)recordID
{
    // 获取Person
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressBook, recordID);
    
    // 初始化为ZMPersonModel
    ZMPersonModel *personModel = [[ZMPersonModel alloc] initWithPerson:person];
    
    return personModel;
}


/**
 根据Name查找联系人

 @param name 查找关键字
 @return ZMPersonModel数组
 */
- (NSArray<ZMPersonModel *> *)getPersonsWithName:(NSString *)name
{
    // 空值过滤
    if (name == nil || name.length == 0) {
        return nil;
    }
    
    // 根据Name获取联系人
    CFArrayRef persons =  ABAddressBookCopyPeopleWithName(_addressBook, (__bridge CFStringRef)(name));

    // 存储通讯录的数组
    NSMutableArray<ZMPersonModel *> *personArray = [NSMutableArray array];
    
    // 循环遍历，获取每个联系人信息
    for (NSInteger i = 0; i < CFArrayGetCount(persons); i++)  {
        ABRecordRef person = CFArrayGetValueAtIndex(persons, i);
        ZMPersonModel *personModel =  [[ZMPersonModel alloc] initWithPerson:person];
        [personArray addObject:personModel];
    }
    
    // 释放资源
    if (persons) CFRelease(persons);

    return personArray;
}


/**
 添加联系人到通讯录

 @param personModel ZMPersonModel对象
 @return 添加结果
 */
- (BOOL)addPerson:(ZMPersonModel *)personModel
{
    // 空值过滤
    if (personModel == nil) {
        return NO;
    }
    
    // 添加到通讯录
    return [self addPersons:@[personModel]];
}


/**
 批量添加联系到通讯录
 
 @param personArray ZMPersonModel数组
 @return 添加结果
 */
- (BOOL)addPersons:(NSArray<ZMPersonModel *> *)personArray
{
    // 空值过滤
    if (personArray == nil || personArray.count == 0) {
        return NO;
    }
    
    // 添加结果
    BOOL result = YES;
    
    // 遍历数组将联系人添加到通讯录中
    for (ZMPersonModel *personModel in personArray)
    {
        // 实例化CFErrorRef
        CFErrorRef errorRef = NULL;
        
        // 添加联系人
        if (ABAddressBookAddRecord(_addressBook, [personModel getRecordRef], &errorRef) == true) {
            // 保存通讯录
            if (!ABAddressBookSave(_addressBook, &errorRef)) {
                result = NO;
            }
        }
        
        // 错误消息处理
        if (errorRef) {
            NSLog(@"Add Person Error:%@", errorRef);
            CFRelease(errorRef);
        }
    }

    return result;
}


/**
 更新联系人
 
 @param personModel ZMPersonModel对象
 @return 更新结果
 */
- (BOOL)updatePerson:(ZMPersonModel *)personModel
{
    BOOL result = NO;
    
    // 空值过滤
    if (personModel == nil) {
        return result;
    }
    
    // 实例化CFErrorRef
    CFErrorRef errorRef = NULL;
    
    // 获取Person
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressBook, personModel.recordID);
    
    // 将Model中数据更新到person中
    if ([personModel updateToRecordRef:person]) {
        // 保存通讯录
        result = ABAddressBookSave(_addressBook, &errorRef);
    }

    // 错误消息处理
    if (errorRef) {
        NSLog(@"Add Person Error:%@", errorRef);
        CFRelease(errorRef);
    }
    
    return result;
}


/**
 删除联系人
 
 @param personModel ZMPersonModel对象
 @return 删除结果
 */
- (BOOL)removePerson:(ZMPersonModel *)personModel
{
    return [self removePersonWithRecordID:personModel.recordID];
}


/**
 根据RecordID删除联系人

 @param recordID 联系人ID
 @return 删除结果
 */
- (BOOL)removePersonWithRecordID:(ABRecordID)recordID
{
    BOOL result = NO;
    
    // 实例化CFErrorRef
    CFErrorRef errorRef = NULL;
    
    // 获取Person
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressBook, recordID);
    if ((person != NULL) && ABAddressBookRemoveRecord(_addressBook, person, &errorRef)) {
        // 保存通讯录
        if (ABAddressBookSave(_addressBook, &errorRef)) {
            result = YES;
        }
    }

    // 错误消息处理
    if (errorRef) {
        NSLog(@"Remove Person Error:%@", errorRef);
        CFRelease(errorRef);
    }
    
    return result;
}


/** 释放调用方法 */
- (void)dealloc
{
    // 移除监听通讯录变动的回调
    ABAddressBookUnregisterExternalChangeCallback(_addressBook, addressBookChangeCallBack, (__bridge void *)(self));
    // 释放_addressBook资源
    if (_addressBook) CFRelease(_addressBook);
}


@end
