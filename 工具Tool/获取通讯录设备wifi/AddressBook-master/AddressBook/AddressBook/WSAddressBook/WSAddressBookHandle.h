//
//  WSAddressBookHandle.h
//  AddressBook
//
//  Created by iMac on 17/2/27.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif
#import <AddressBook/AddressBook.h>

#import "WSPersonModel.h"
#import "WSSingleton.h"

#define IOS9_LATER ([[UIDevice currentDevice] systemVersion].floatValue > 9.0 ? YES : NO )



/** 一个联系人的相关信息*/
typedef void(^PPPersonModelBlock)(WSPersonModel *model);
/** 授权失败的Block*/
typedef void(^AuthorizationFailure)(void);




@interface WSAddressBookHandle : NSObject

WSSingletonH(AddressBookHandle)


/**
 请求用户通讯录授权
 
 @param success 授权成功的回调
 */
- (void)requestAuthorizationWithSuccessBlock:(void(^)(void))success;

/**
 *  返回每个联系人的模型
 *
 *  @param personModel 单个联系人模型
 *  @param failure     授权失败的Block
 */
- (void)getAddressBookDataSource:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure;


@end
