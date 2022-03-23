//
//  NSObject+CJLKVO.h
//  CJLCustom
//
//  Created by - on 2020/10/28.
//  Copyright © 2020 CJL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LGKVOBlock)(id observer,NSString *keyPath,id oldValue,id newValue);

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CJLKVO)

//------响应式编程
- (void)cjl_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

- (void)cjl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;

- (void)cjl_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;



//------函数式编程
- (void)cjl_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(LGKVOBlock)block;

@end

NS_ASSUME_NONNULL_END
