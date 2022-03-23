//
//  CJLPerson.m
//  CJLCustom
//
//  Created by - on 2020/10/26.
//  Copyright © 2020 CJL. All rights reserved.
//

#import "CJLPerson.h"

@implementation CJLPerson

+ (BOOL)accessInstanceVariablesDirectly{
    return YES;
}

//- (void)setName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);
//}
//
//- (void)_setName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);
//}
//
//- (void)setIsName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);
//}

//- (NSString *)name{
//    return NSStringFromSelector(_cmd);
//}


- (void)setNickName:(NSString *)nickName{
    NSLog(@"来到 CJLPerson 的setter方法 :%@",nickName);
    _nickName = nickName;
}

- (void)setName:(NSString *)name{
    NSLog(@"来到 CJLPerson 的setter方法 :%@",name);
    _name = name;
}

- (void)dealloc
{
    NSLog(@"来到 CJLPerson 的%@方法",__func__);
}

@end
