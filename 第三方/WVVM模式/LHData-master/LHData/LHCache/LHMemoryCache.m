//
//  LHMemoryCache.m
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/23.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHMemoryCache.h"
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import <pthread.h>

@interface LHCacheModel : NSObject

@end

@implementation LHCacheModel{
    @package
    NSUInteger _setCount;
    NSUInteger _useCount;
    id _key;
    id _value;
}


@end

static dispatch_queue_t destoryQueue(){
    return dispatch_queue_create("com.sancai.lhmemorycache", NULL);
}

static CFComparisonResult ComparatorFunction(const void *val1, const void *val2, void *context)
{
    LHCacheModel* model1 = (__bridge LHCacheModel *)(val1);
    LHCacheModel* model2 = (__bridge LHCacheModel *)(val2);
    return model1->_useCount > model2->_useCount;
}

@implementation LHMemoryCache{
    CFMutableDictionaryRef _dic;
    CFMutableArrayRef _array;
    pthread_mutex_t _lock;
    dispatch_queue_t _destoryQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dic = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,&kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        _array = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
        pthread_mutex_init(&_lock, NULL);
        _destoryQueue = destoryQueue();
        _shouldClearCacheWhenEnterBackground = YES;
        _countMax = 10;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (instancetype)initWithName:(NSString*)name
{
    self = [self init];
    self.name = name;
    return self;
}

- (void)setObject:(id)object forKey:(NSString*)key
{
    if (![key isKindOfClass:[NSString class]]||key.length<=0) {
        return;
    }
    pthread_mutex_lock(&_lock);
    LHCacheModel* model = CFDictionaryGetValue(_dic, (__bridge const void *)(key));
    if (model) {
        model->_key = key;
        model->_value = object;
        model->_setCount += 1;
    }else {
        if (_count == _countMax) {
            LHCacheModel* removeModel = CFArrayGetValueAtIndex(_array, _count-1);
            CFDictionaryRemoveValue(_dic, (__bridge const void *)(removeModel->_key));
            CFArrayRemoveValueAtIndex(_array, _count-1);
            _count -- ;
        }
        LHCacheModel* model = [[LHCacheModel alloc] init];
        model->_key = key;
        model->_value = object;
        model->_setCount = 1;
        _count += 1;
        [self insertCacheWithModel:model];
    }
    pthread_mutex_unlock(&_lock);
}

- (void)insertCacheWithModel:(LHCacheModel*)model
{
    CFArrayAppendValue(_array, (__bridge const void *)(model));
    CFDictionaryAddValue(_dic, (__bridge const void *)(model->_key), (__bridge const void *)(model));
}

- (void)replaceCacheWithModel:(LHCacheModel*)model
{
    CFIndex index = CFArrayGetFirstIndexOfValue(_array, CFRangeMake(0, _count),(__bridge const void *)(model));
    if (index == 0) return;
    for (int i = 0; i < index; i++) {
        LHCacheModel* compareModel = CFArrayGetValueAtIndex(_array, i);
        if (compareModel->_useCount <= model->_useCount) {
            CFArrayRemoveValueAtIndex(_array, index);
            CFArrayInsertValueAtIndex(_array, 0, (__bridge const void *)(model));
            return;
        }
    }
}

- (id)objectForKey:(NSString*)key
{
    if (![key isKindOfClass:[NSString class]]||key.length<=0) {
        return nil;
    }
    pthread_mutex_lock(&_lock);
    LHCacheModel* model = CFDictionaryGetValue(_dic, (__bridge const void *)(key));
    
    if (model) {
        model->_useCount += 1;
        [self replaceCacheWithModel:model];
    }else {
        pthread_mutex_unlock(&_lock);
        return nil;
    }
    pthread_mutex_unlock(&_lock);
    return model->_value;
}

- (BOOL)isContainObjectWithKey:(NSString*)key
{
    if (![key isKindOfClass:[NSString class]]||key.length<=0) {
        return NO;
    }
    pthread_mutex_lock(&_lock);
    BOOL isContain = CFDictionaryContainsKey(_dic, (__bridge const void *)(key));
    pthread_mutex_unlock(&_lock);
    return isContain;
}

- (void)removeMinimumUseCountObjectWithCount:(NSInteger)count
{
    CFArraySortValues(_array, CFRangeMake(0, CFArrayGetCount(_array)), ComparatorFunction, nil);
    for (int i=0; i<count; i++) {
        if (i<_count) {
            LHCacheModel* model = CFArrayGetValueAtIndex(_array, i);
            CFDictionaryRemoveValue(_dic, (__bridge const void *)(model->_key));
            CFArrayRemoveValueAtIndex(_array, i);
            _count -= 1;
            i--;
            count--;
        }else {
            CFDictionaryRemoveAllValues(_dic);
            CFArrayRemoveAllValues(_array);
            _count = 0;
            return;
        }
    }
}

- (void)removeAllObject
{
    CFDictionaryRemoveAllValues(_dic);
    CFArrayRemoveAllValues(_array);
    _count = 0;
}

- (void)_appDidReceiveMemoryWarningNotification
{
    [self removeAllObject];
}

- (void)_appDidEnterBackgroundNotification
{
    if (self.shouldClearCacheWhenEnterBackground) {
        [self removeAllObject];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter ]removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
//    [self removeAllObject];
    CFRelease(self->_dic);
    CFRelease(self->_array);
    pthread_mutex_destroy(&_lock);
}

@end
