//
//  Contact.h
//  01-模糊查询
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

+ (instancetype)contactWithName:(NSString *)name phone:(NSString *)phone;

@end
