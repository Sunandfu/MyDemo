//
//  NSObject+SFCustomKVO.m
//  MedProAdapter
//
//  Created by lurich on 2022/3/22.
//

#import "NSObject+SFCustomKVO.h"
#import "SFKVOObserverItem.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (SFCustomKVO)

static void *const sf_KVOObserverAssociatedKey = (void *)&sf_KVOObserverAssociatedKey;
static NSString *sf_KVOClassPrefix = @"SFCustomKVO_";

- (void)sf_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
              callback:(sf_KVOObserverBlock)callback {
    // 1. 通过keyPath获取当前类对应的setter方法，如果获取不到，说明setter 方法即不存在与KVO类，也不存在与原始类，这总情况正常情况下是不会发生的，触发Exception
    NSString *setterString = sf_setterByGetter(keyPath);
    SEL setterSEL = NSSelectorFromString(setterString);
    Method method = class_getInstanceMethod(object_getClass(self), setterSEL);
    
    if (method) {
        // 2. 查看当前实例对应的类是否是KVO类，如果不是，则生成对应的KVO类，并设置当前实例对应的class是KVO类
        Class objectClass = object_getClass(self);
        NSString *objectClassName = NSStringFromClass(objectClass);
        if (![objectClassName hasPrefix:sf_KVOClassPrefix]) {
            Class kvoClass = [self makeKvoClassWithOriginalClassName:objectClassName]; // 为原始类创建KVO类
            object_setClass(self, kvoClass); // 将当前实例的类设置为KVO类
        }
        
        // 3. 在KVO类中查找是否重写过keyPath 对应的setter方法，如果没有，则添加setter方法到KVO类中
        // 注意，此时object_getClass(self)获取到的class应该是KVO class
        if (![self hasMethodWithMethodName:setterString]) {
            class_addMethod(object_getClass(self), NSSelectorFromString(setterString), (IMP)sf_setter, method_getTypeEncoding(method));
        }
        
        // 4. 注册Observer
        NSMutableArray<SFKVOObserverItem *> *observerArray = objc_getAssociatedObject(self, sf_KVOObserverAssociatedKey);
        if (observerArray == nil) {
            observerArray = [NSMutableArray new];
            objc_setAssociatedObject(self, sf_KVOObserverAssociatedKey, observerArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        SFKVOObserverItem *item = [SFKVOObserverItem new];
        item.keyPath = keyPath;
        item.observer = observer;
        item.callback = callback;
        [observerArray addObject:item];
        
        
    }else {
        NSString *exceptionReason = [NSString stringWithFormat:@"%@ Class %@ setter SEL not found.", NSStringFromClass([self class]), keyPath];
        NSException *exception = [NSException exceptionWithName:@"NotExistKeyExceptionName" reason:exceptionReason userInfo:nil];
        [exception raise];
    }
}
- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClassName {
    // 1. 检查KVO类是否已经存在, 如果存在，直接返回
    NSString *kvoClassName = [NSString stringWithFormat:@"%@%@", sf_KVOClassPrefix, originalClassName];
    Class kvoClass = objc_getClass(kvoClassName.UTF8String);
    if (kvoClass) {
        return kvoClass;
    }
    
    // 2. 创建KVO类，并将原始class设置为KVO类的super class
    kvoClass = objc_allocateClassPair(object_getClass(self), kvoClassName.UTF8String, 0);
    objc_registerClassPair(kvoClass);
    
    // 3. 重写KVO类的class方法，使其指向我们自定义的IMP,实现KVO class的‘伪装’
    Method classMethod = class_getInstanceMethod(object_getClass(self), @selector(class));
    const char* types = method_getTypeEncoding(classMethod);
    class_addMethod(kvoClass, @selector(class), (IMP)sf_class, types);
    return kvoClass;
}

#pragma mark - 重写setter方法，向父类发消息（响应式编程 / 函数式编程）
static void sf_setter(id self, SEL _cmd, id newValue){
    //此时应该有willChange的代码
    
    //往父类LGPerson发消息 - 通过objc_msgSendSuper
    //通过系统强制类型转换自定义objc_msgSendSuper
    void (*cjl_msgSendSuper)(void *, SEL, id) = (void *)objc_msgSendSuper;
    //定义一个结构体
    struct objc_super superStruct = {
        .receiver = self, //消息接收者 为 当前的self
        .super_class = class_getSuperclass(object_getClass(self)), //第一次快捷查找的类 为 父类
    };
    //调用自定义的发送消息函数
    cjl_msgSendSuper(&superStruct, _cmd, newValue);
    
    //此时应该有didChange的代码
    
    /*---函数式编程*/
    NSString *keyPath = sf_getterBySetter(NSStringFromSelector(_cmd));
    id oldValue = [self valueForKey:keyPath];
    NSMutableArray *mArray = objc_getAssociatedObject(self, sf_KVOObserverAssociatedKey);
    for (SFKVOObserverItem *info in mArray) {
        if ([info.keyPath isEqualToString:keyPath] && info.callback) {
           info.callback(info.observer, keyPath, oldValue, newValue);
        }
    }
}
// 自定义的class方法实现
static Class sf_class(id self, SEL selector) {
    return class_getSuperclass(object_getClass(self));  // 因为我们将原始类设置为了KVO类的super class，所以直接返回KVO类的super class即可得到原始类Class
}
- (void)sf_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    NSMutableArray<SFKVOObserverItem *> *observerArray = objc_getAssociatedObject(self, sf_KVOObserverAssociatedKey);
    [observerArray enumerateObjectsUsingBlock:^(SFKVOObserverItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.observer == observer && [obj.keyPath isEqualToString:keyPath]) {
            [observerArray removeObject:obj];
        }
    }];
    
    if (observerArray.count == 0) { // 如果已经没有了observer，则把isa复原，销毁临时的KVO类
        Class originalClass = [self class];
        Class kvoClass = object_getClass(self);
        object_setClass(self, originalClass);
        objc_disposeClassPair(kvoClass);
    }
}
#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *sf_getterBySetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}
static NSString *sf_setterByGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}
- (BOOL)hasMethodWithMethodName:(NSString *)sel{
    return NO;
}

@end
