//
//  Contact.m
//  01-模糊查询
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (instancetype)contactWithName:(NSString *)name phone:(NSString *)phone
{
    Contact *c = [[self alloc] init];
    
    c.name = name;
    c.phone = phone;
    
    return c;
}

@end
