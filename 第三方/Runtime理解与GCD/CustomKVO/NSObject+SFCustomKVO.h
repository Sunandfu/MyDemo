//
//  NSObject+SFCustomKVO.h
//  MedProAdapter
//
//  Created by lurich on 2022/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^sf_KVOObserverBlock)(id observedObject, NSString *observedKeyPath, id oldValue, id newValue);

@interface NSObject (SFCustomKVO)

- (void)sf_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
              callback:(sf_KVOObserverBlock)callback;

- (void)sf_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
