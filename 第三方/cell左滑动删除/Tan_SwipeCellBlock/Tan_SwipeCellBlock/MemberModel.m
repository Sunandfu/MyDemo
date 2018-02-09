//
//  MemberModel.m
//  Tan_SwipeTableViewCell
//
//  Created by PX_Mac on 16/3/26.
//  Copyright © 2016年 PX_Mac. All rights reserved.
//

#import "MemberModel.h"

@implementation MemberModel

+ (instancetype)memberWithID: (int)ID displayname: (NSString *)name email: (NSString *)email phone: (NSString *)phone{
    MemberModel *model = [[MemberModel alloc] init];
    
    model.ID = ID;
    model.displayname = name;
    model.email = email;
    model.phone = phone;
    return model;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com