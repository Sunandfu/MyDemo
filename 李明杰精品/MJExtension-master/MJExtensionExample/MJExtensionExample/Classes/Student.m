//
//  Student.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/1/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Student.h"
//#import "MJExtension.h"
// 其实只要replacedKeyFromPropertyName方法敲出来了，这个头文件都可以删掉了，这样就更加没有侵入性

@implementation Student
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             @"desc" : @"desciption",
             @"oldName" : @"name.oldName",
             @"nowName" : @"name.newName",
             @"nameChangedTime" : @"name.info.nameChangedTime",
             @"bag" : @"other.bag"
        };
}
@end
