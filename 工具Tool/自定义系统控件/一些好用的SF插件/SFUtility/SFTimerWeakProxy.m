//
//  SFTimerWeakProxy.m
//  AdDemo
//
//  Created by lurich on 2021/6/16.
//

#import "SFTimerWeakProxy.h"

@interface SFTimerWeakProxy ()

@property (nonatomic, weak) id timerTarget;

@end

@implementation SFTimerWeakProxy

- (instancetype)initTimerProxyWithTarget:(id)target {
    self.timerTarget = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[self alloc] initTimerProxyWithTarget:target];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.timerTarget respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.timerTarget];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if (self.timerTarget) {
       return [self.timerTarget methodSignatureForSelector:sel];
    }
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

@end
