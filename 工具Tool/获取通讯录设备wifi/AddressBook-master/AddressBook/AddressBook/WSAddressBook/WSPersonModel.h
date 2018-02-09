//
//  WSPersonModel.h
//  AddressBook
//
//  Created by iMac on 17/2/27.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WSPersonModel : NSObject

/** 联系人姓名*/
@property (nonatomic, copy) NSString *name;
/** 联系人电话数组,因为一个联系人可能存储多个号码*/
@property (nonatomic, strong) NSMutableArray *mobileArray;
/** 联系人头像*/
@property (nonatomic, strong) UIImage *headerImage;


@end
