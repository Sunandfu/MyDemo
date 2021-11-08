//
//  NSObject+SFObserverHelper.h
//  TestAdA
//
//  Created by lurich on 2021/4/12.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SFDeallockCallbackTask)(id obj);
typedef void(^SFKVOObservedChangeHandler)(id target, NSDictionary<NSKeyValueChangeKey,id> *_Nullable change);
typedef void(^SFKVOObservedChangeValues)(id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal);
typedef NSInteger SFKVOObserverToken;

/// - KVO -
/// Add Observer (autoremove) [target, keyPath, change]
extern SFKVOObserverToken
sfkvo_observe(id target, NSString *keyPath, SFKVOObservedChangeHandler handler);

/// Add Observer (autoremove) [target, keyPath, options, change]
extern SFKVOObserverToken __attribute__((overloadable))
sfkvo_observe(id target, NSString *keyPath, NSKeyValueObservingOptions options, SFKVOObservedChangeHandler handler);

/// Add Observer (autoremove) [target, keyPath, options, change]
extern SFKVOObserverToken __attribute__((overloadable))
sfkvo_observe_values(id target, NSString *keyPath, SFKVOObservedChangeValues values);

/// Remove Observer
extern void
sfkvo_remove(id target, SFKVOObserverToken token);


/// - KVO -
@interface NSObject (SFKVOHelper)
/// Add an observer, you don't need to remove observer (autoremove)
/// 添加观察者, 无需移除 (将会自动移除)
- (void)sf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

/// Add an observer, you don't need to remove observer (autoremove)
/// 添加观察者, 无需移除 (将会自动移除)
- (void)sf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context;

/// Add an observer, you don't need to remove observer (autoremove)
/// 添加观察者, 无需移除 (将会自动移除)
- (void)sf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
@end

/// - Notification -
@interface NSObject (SFNotificationHelper)
/// Autoremove
- (void)sf_observeWithNotification:(NSNotificationName)notification target:(id _Nullable)sender usingBlock:(void(^)(id self, NSNotification *note))block;

/// Autoremove
- (void)sf_observeWithNotification:(NSNotificationName)notification target:(id _Nullable)sender queue:(NSOperationQueue *_Nullable)queue usingBlock:(void(^)(id self, NSNotification *note))block;
@end

/// - DeallocCallback -
@interface NSObject (SFDeallocCallback)

/// Add a task that will be executed when the object is destroyed
/// 添加一个任务, 当对象销毁时将会执行这些任务
- (void)sf_addDeallocCallbackTask:(SFDeallockCallbackTask)callback;

@end

/**
 Common tasks for NSObject.
 */
@interface NSObject (SFRunTime)

#pragma mark - Swap method (Swizzling)
///=============================================================================
/// @name Swap method (Swizzling)
///=============================================================================

/**
 在一个类中交换两个实例方法的实现。 Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)sf_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 在一个类中交换两个类方法的实现。Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)sf_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;


#pragma mark - Associate value
///=============================================================================
/// @name Associate value
///=============================================================================

/**
 将一个对象与“self”关联，就好像它是一个强属性一样 (strong, nonatomic).
 
 @param value   The object to associate.
 @param key     The pointer to get value from `self`.
 */
- (void)sf_setAssociateValue:(id)value withKey:(void *)key;

/**
 将一个对象与“self”关联，就好像它是弱属性一样 (week, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)sf_setAssociateWeakValue:(id)value withKey:(void *)key;

/**
 从“self”获取关联的值。
 
 @param key The pointer to get value from `self`.
 */
- (id)sf_getAssociatedValueForKey:(void *)key;

/**
 删除所有关联的值。
 */
- (void)sf_removeAssociatedValues;


#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 返回NSString中的类名。
 */
+ (NSString *)sf_className;

/**
 返回NSString中的类名。
 
 @discussion Apple已在NSObject（NSLayoutConstraintCalls）中实现了此方法，但没有公开。
 */
- (NSString *)sf_className;

/**
 返回实例的副本，其中包含`NSKeyedArchiver`和`nskeyedunachiver`。
 如果发生错误，则返回nil。
 */
- (id)sf_deepCopy;

/**
 返回实例archiver和unarchiver的副本。
 如果发生错误，则返回nil。
 
 @param archiver   NSKeyedArchiver class or any class inherited.
 @param unarchiver NSKeyedUnarchiver clsas or any class inherited.
 */
- (id)sf_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;

@end

NS_ASSUME_NONNULL_END
