//
//  SFPermenantThread.m
//  AdDemo
//
//  Created by lurich on 2021/6/16.
//

#import "SFPermenantThread.h"

/** SFThread **/
@interface SFThread : NSThread

@end

@implementation SFThread

- (void)dealloc{
    //用来检测是否销毁
    NSLog(@"%s", __func__);
}

@end

/** SFPermenantThread **/
@interface SFPermenantThread()

@property (strong, nonatomic) SFThread *innerThread;

@end

@implementation SFPermenantThread

#pragma mark - public methods
- (instancetype)init{
    if (self = [super init]) {
        self.innerThread = [[SFThread alloc] initWithTarget:self selector:@selector(permenantThreadFunc) object:nil];
        [self.innerThread start];
    }
    return self;
}

- (void)permenantThreadFunc{
    // 创建上下文（要初始化一下结构体）
    CFRunLoopSourceContext context = {0};
    // 创建source
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    // 往Runloop中添加source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    // 销毁source
    CFRelease(source);
    // 启动
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
}

- (void)executeTask:(SFPermenantThreadTask)task{
    if (!self.innerThread || !task) return;
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop{
    if (!self.innerThread) return;
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [self stop];
}

#pragma mark - private methods
- (void)__stop{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(SFPermenantThreadTask)task{
    task();
}

@end
