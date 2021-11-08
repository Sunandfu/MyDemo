//
//  NSObject+SFObserverHelper.h
//  TestAdA
//
//  Created by lurich on 2021/4/12.
//  Copyright © 2021 . All rights reserved.
//

#import "NSObject+SFAdd.h"
#import <objc/message.h>
#import <objc/objc.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
@interface __SFKVOAutoremove: NSObject {
@public
    char _key;
}
@property (nonatomic, unsafe_unretained, nullable) id target;
@property (nonatomic, unsafe_unretained, nullable) id observer;
@property (nonatomic, weak, nullable) __SFKVOAutoremove *factor;
@property (nonatomic, copy, nullable) NSString *keyPath;
@end

@implementation __SFKVOAutoremove
- (void)dealloc {
    if ( _factor ) {
        [_target removeObserver:_observer forKeyPath:_keyPath];
        _factor = nil;
    }
}
@end

@implementation NSObject (SFKVOHelper)
- (void)sf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    [self sf_addObserver:observer forKeyPath:keyPath context:NULL];
}

- (void)sf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    [self sf_addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:context];
}

- (void)sf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    NSParameterAssert(observer);
    NSParameterAssert(keyPath);
    
    if ( !observer || !keyPath ) return;
    
    NSString *hashstr = [NSString stringWithFormat:@"%lu-%@", (unsigned long)[observer hash], keyPath];
    
    static dispatch_semaphore_t lock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSMutableSet *set = [self sf_observerhashSet];
    if ( [set containsObject:hashstr] ) {
        dispatch_semaphore_signal(lock);
        return;
    }
    
    [set addObject:hashstr];
    dispatch_semaphore_signal(lock);
    
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
    
    __SFKVOAutoremove *helper = [__SFKVOAutoremove new];
    __SFKVOAutoremove *sub = [__SFKVOAutoremove new];
    
    sub.target = helper.target = self;
    sub.observer = helper.observer = observer;
    sub.keyPath = helper.keyPath = keyPath;
    
    helper.factor = sub;
    sub.factor = helper;
    
    __weak typeof(set) _set = set;
    [observer sf_addDeallocCallbackTask:^(id  _Nonnull obj) {
        if ( _set == nil ) return;
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        [_set removeObject:hashstr];
        dispatch_semaphore_signal(lock);
    }];
    
    objc_setAssociatedObject(self, &helper->_key, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(observer, &sub->_key, sub, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet<NSString *> *)sf_observerhashSet {
    NSMutableSet<NSString *> *set = objc_getAssociatedObject(self, _cmd);
    if ( set ) return set;
    set = [NSMutableSet set];
    objc_setAssociatedObject(self, _cmd, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return set;
}

@end


#pragma mark - Notification
@implementation NSObject (SFNotificationHelper)
- (void)sf_observeWithNotification:(NSNotificationName)notification target:(id _Nullable)target usingBlock:(void(^)(id self, NSNotification *note))block {
    [self sf_observeWithNotification:notification target:target queue:NSOperationQueue.mainQueue usingBlock:block];
}
- (void)sf_observeWithNotification:(NSNotificationName)notification target:(id _Nullable)target queue:(NSOperationQueue *_Nullable)queue usingBlock:(void(^)(id self, NSNotification *note))block {
    __weak typeof(self) _self = self;
    id token = [NSNotificationCenter.defaultCenter addObserverForName:notification object:target queue:queue usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( block ) block(self, note);
    }];
    
    [self sf_addDeallocCallbackTask:^(id  _Nonnull obj) {
        [NSNotificationCenter.defaultCenter removeObserver:token];
    }];
}
@end


#pragma mark - SFDeallocCallback
@interface __SFDeallockCallback : NSObject {
@public
    char _key;
}
@property (nonatomic, unsafe_unretained, nullable) id target;
@property (nonatomic, copy, nullable) SFDeallockCallbackTask task;
@end

@implementation __SFDeallockCallback
- (void)dealloc {
    if ( _task ) _task(_target);
}
@end

@implementation NSObject (SFDeallocCallback)
- (void)sf_addDeallocCallbackTask:(SFDeallockCallbackTask)block {
    __SFDeallockCallback *callback = [__SFDeallockCallback new];
    callback.target = self;
    callback.task = block;
    objc_setAssociatedObject(self, &callback->_key, callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@interface __SFKVOObserver : NSObject {
@public
    char _key;
}
@property (nonatomic, unsafe_unretained, readonly) id target;
@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, readonly) NSKeyValueObservingOptions options;
@property (nonatomic, copy, readonly) SFKVOObservedChangeHandler handler;
@property (nonatomic, copy, readonly) SFKVOObservedChangeValues values;
@end
@implementation __SFKVOObserver
- (instancetype)initWithTarget:(__unsafe_unretained id)target
                    forKeyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                        change:(SFKVOObservedChangeHandler)handler {
    self = [super init];
    if ( !self ) return nil;
    _target = target;
    _keyPath = [keyPath copy];
    _handler = handler;
    [_target addObserver:self forKeyPath:keyPath options:options context:NULL];
    return self;
}
- (instancetype)initWithTarget:(__unsafe_unretained id)target
                    forKeyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                   valueChange:(SFKVOObservedChangeValues)values {
    self = [super init];
    if ( !self ) return nil;
    _target = target;
    _keyPath = [keyPath copy];
    _values = values;
    [_target addObserver:self forKeyPath:keyPath options:options context:NULL];
    return self;
}
- (void)dealloc {
    @try {
        [_target removeObserver:self forKeyPath:_keyPath];
    } @catch (NSException *__unused exception) { }
}
- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change context:(nullable void *)context {
    if ( _handler ) _handler(object, change);
    if ( _values ) {
        BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
        if (isPrior) return;
        
        NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
        if (changeKind != NSKeyValueChangeSetting) return;
        
        id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
        if (oldVal == [NSNull null]) oldVal = nil;
        
        id newVal = [change objectForKey:NSKeyValueChangeNewKey];
        if (newVal == [NSNull null]) newVal = nil;
        
        _values(object, oldVal, newVal);
    }
}
@end

SFKVOObserverToken
sfkvo_observe(id target, NSString *keyPath, SFKVOObservedChangeHandler handler) {
    return sfkvo_observe(target, keyPath, NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld, handler);
}

SFKVOObserverToken __attribute__((overloadable))
sfkvo_observe(id target, NSString *keyPath, NSKeyValueObservingOptions options, SFKVOObservedChangeHandler handler) {
    if ( !target )
        return 0;
    __SFKVOObserver *observer = [[__SFKVOObserver alloc] initWithTarget:target forKeyPath:keyPath options:options change:handler];
    objc_setAssociatedObject(target, &observer->_key, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return (SFKVOObserverToken)&observer->_key;
}

SFKVOObserverToken __attribute__((overloadable))
sfkvo_observe_values(id target, NSString *keyPath, SFKVOObservedChangeValues values) {
    if ( !target )
        return 0;
    __SFKVOObserver *observer = [[__SFKVOObserver alloc] initWithTarget:target forKeyPath:keyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld valueChange:values];
    objc_setAssociatedObject(target, &observer->_key, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return (SFKVOObserverToken)&observer->_key;
}

void
sfkvo_remove(id target, SFKVOObserverToken token) {
    objc_setAssociatedObject(target, (void *)token, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@implementation NSObject (SFRunTime)

+ (BOOL)sf_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)sf_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

- (void)sf_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sf_setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)sf_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)sf_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

+ (NSString *)sf_className {
    return NSStringFromClass(self);
}

- (NSString *)sf_className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

- (id)sf_deepCopy {
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}

- (id)sf_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver {
    id obj = nil;
    @try {
        obj = [unarchiver unarchiveObjectWithData:[archiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}

@end

NS_ASSUME_NONNULL_END
