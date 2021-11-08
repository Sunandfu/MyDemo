//
//  SFQueue.m
//  ApiTestDemo
//
//  Created by lurich on 2021/8/30.
//

#import "SFQueue.h"

@interface SFQueue ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFQueue

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

//队列里的元素个数
- (NSInteger)size{
    return self.dataArray.count;
}
//入队
- (void)enQueueObject:(id)anObject{
    [self.dataArray addObject:anObject];
}
//出队
- (id)deQueue{
    id obj = [self.dataArray firstObject];
    [self.dataArray removeObjectAtIndex:0];
    return obj;
}
//清空队列里的元素
- (void)clear{
    [self.dataArray removeAllObjects];
}
//判断队列是否为空
- (BOOL)isEmpty{
    return self.dataArray.count==0;
}
//获取队列的第一个元素
- (id)first{
    return [self.dataArray firstObject];
}
- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

@end
