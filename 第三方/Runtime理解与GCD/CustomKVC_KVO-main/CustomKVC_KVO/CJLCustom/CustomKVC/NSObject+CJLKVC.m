//
//  NSObject+CJLKVC.m
//  CJLCustom
//
//  Created by - on 2020/10/26.
//  Copyright © 2020 CJL. All rights reserved.
//

#import "NSObject+CJLKVC.h"
#import <objc/runtime.h>

@implementation NSObject (CJLKVC)

//设值
- (void)cjl_setValue:(nullable id)value forKey:(NSString *)key{
    
//    1、判断key 是否存在
    if (key == nil || key.length == 0) return;
    
//    2、找setter方法，顺序是：setXXX、_setXXX、 setIsXXX
    // key 要大写
    NSString *Key = key.capitalizedString;
    // key 要大写
    NSString *setKey = [NSString stringWithFormat:@"set%@:", Key];
    NSString *_setKey = [NSString stringWithFormat:@"_set%@:", Key];
    NSString *setIsKey = [NSString stringWithFormat:@"setIs%@:", Key];
    
    if ([self cjl_performSelectorWithMethodName:setKey value:value]) {
        NSLog(@"*************%@*************", setKey);
        return;
    }else if([self cjl_performSelectorWithMethodName:_setKey value:value]){
        NSLog(@"*************%@*************", _setKey);
        return;
    }else if([self cjl_performSelectorWithMethodName:setIsKey value:value]){
        NSLog(@"*************%@*************", setIsKey);
        return;
    }
    
    
//    3、判断是否响应`accessInstanceVariablesDirectly`方法，即间接访问实例变量，返回YES，继续下一步设值，如果是NO，则崩溃
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"CJLUnKnownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    }
    
//    4、间接访问变量赋值，顺序为：_key、_isKey、key、isKey
    // 4.1 定义一个收集实例变量的可变数组
    NSMutableArray *mArray = [self getIvarListName];
    // _<key> _is<Key> <key> is<Key>
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", key];
    NSString *isKey = [NSString stringWithFormat:@"is%@", key];
    if ([mArray containsObject:_key]) {
        // 4.2 获取相应的 ivar
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        // 4.3 对相应的 ivar 设置值
        object_setIvar(self, ivar, value);
        return;
    }else if ([mArray containsObject:_isKey]) {
        
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }else if ([mArray containsObject:key]) {
        
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }else if ([mArray containsObject:isKey]) {
        
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    
//    5、如果找不到则抛出异常
    @throw [NSException exceptionWithName:@"CJLUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ %@]: this class is not key value coding-compliant for the key name.****",self,NSStringFromSelector(_cmd)] userInfo:nil];
    
}
//取值
- (nullable id)cjl_valueForKey:(NSString *)key{
    
//    1、判断非空
    if (key == nil || key.length == 0) {
        return nil;
    }
    
//    2、找到相关方法：get<Key> <key> countOf<Key>  objectIn<Key>AtIndex
    // key 要大写
    NSString *Key = key.capitalizedString;
    // 拼接方法
    NSString *getKey = [NSString stringWithFormat:@"get%@",Key];
    NSString *countOfKey = [NSString stringWithFormat:@"countOf%@",Key];
    NSString *objectInKeyAtIndex = [NSString stringWithFormat:@"objectIn%@AtIndex:",Key];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:NSSelectorFromString(getKey)]) {
        return [self performSelector:NSSelectorFromString(getKey)];
    }else if ([self respondsToSelector:NSSelectorFromString(key)]){
        return [self performSelector:NSSelectorFromString(key)];
    }
    //集合类型
    else if ([self respondsToSelector:NSSelectorFromString(countOfKey)]){
        if ([self respondsToSelector:NSSelectorFromString(objectInKeyAtIndex)]) {
            int num = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
            for (int i = 0; i<num-1; i++) {
                num = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            }
            for (int j = 0; j<num; j++) {
                id objc = [self performSelector:NSSelectorFromString(objectInKeyAtIndex) withObject:@(num)];
                [mArray addObject:objc];
            }
            return mArray;
        }
    }

#pragma clang diagnostic pop
    
//    3、判断是否响应`accessInstanceVariablesDirectly`方法，即间接访问实例变量，返回YES，继续下一步设值，如果是NO，则崩溃
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"CJLUnKnownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    }
    
//    4.找相关实例变量进行赋值，顺序为：_<key>、 _is<Key>、 <key>、 is<Key>
    // 4.1 定义一个收集实例变量的可变数组
    NSMutableArray *mArray = [self getIvarListName];
    // 例如：_name -> _isName -> name -> isName
    NSString *_key = [NSString stringWithFormat:@"_%@",key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@",Key];
    NSString *isKey = [NSString stringWithFormat:@"is%@",Key];
    if ([mArray containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        return object_getIvar(self, ivar);;
    }else if ([mArray containsObject:_isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        return object_getIvar(self, ivar);;
    }else if ([mArray containsObject:key]) {
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        return object_getIvar(self, ivar);;
    }else if ([mArray containsObject:isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        return object_getIvar(self, ivar);;
    }

    return @"";
    
    return @"";
}

#pragma mark - 相关方法
- (BOOL)cjl_performSelectorWithMethodName:(NSString *)methodName value:(id)value{
    if ([self respondsToSelector:NSSelectorFromString(methodName)]) {
#pragma clang diagnostic push
        //如果你确定不会发生内存泄漏的情况下，可以使用如下的语句来忽略掉这条警告
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(methodName) withObject:value];
#pragma clang diagnostic pop
        return YES;
    }
    return NO;
}

- (id)performSelectorWithMethodName:(NSString *)methodName{
    if ([self respondsToSelector:NSSelectorFromString(methodName)]) {
#pragma clang diagnostic push
        //如果你确定不会发生内存泄漏的情况下，可以使用如下的语句来忽略掉这条警告
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:NSSelectorFromString(methodName) ];
#pragma clang diagnostic pop
    }
    return nil;
}

- (NSMutableArray *)getIvarListName{
    //创建可变数组，用于存储ivar成员变量
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
    unsigned int count = 0;
    //获取类的成员变量列表
    Ivar *ivars = class_copyIvarList([self class], &count);
    //遍历成员变量列表
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        //获取成员变量名字字符
        const char *ivarNameChar = ivar_getName(ivar);
        //将字符转换成字符串
        NSString *ivarName = [NSString stringWithUTF8String:ivarNameChar];
        NSLog(@"ivarName == %@", ivarName);
        //存入可变数组
        [mArray addObject:ivarName];
    }
    //释放成员变量列表
    free(ivars);
    return mArray;
}

@end

