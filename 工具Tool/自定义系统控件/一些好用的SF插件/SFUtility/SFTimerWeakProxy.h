//
//  SFTimerWeakProxy.h
//  AdDemo
//
//  Created by lurich on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFTimerWeakProxy : NSProxy

- (instancetype)initTimerProxyWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
